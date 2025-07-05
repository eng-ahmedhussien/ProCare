//
//  LoginScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
    @StateObject var vm = LoginVM()
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var profileVM: ProfileVM
    
    private var isFormValid: Bool {
        ValidationRule.email.validate(vm.email) == nil &&
        ValidationRule.password.validate(vm.password) == nil
    }
    
    var body: some View {
        NavigationView {
            content
                .disabled(vm.viewState == .loading)
                .dismissKeyboardOnTap()
                .toolbar { changeLanguageButton }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            headerTitle
            
            loginTextFields
            
            forgotPasswordButton
            
            loginButton
            
            createAccountButton
        }
    }
}

extension LoginScreen {
    var changeLanguageButton: some View {
        HStack {
            Button(action: {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }) {
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.appPrimary)
            }
            .font(.callout)
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    var headerTitle: some View {
        VStack(alignment: .center) {
            Image(.proCareLogo)
                .resizable()
                .frame(width: 250, height: 250, alignment: .center)
                .opacity(0.9)

            Text("hello".localized())
            Text("log_in_to_start".localized())
        }
        .font(.title.bold())
        .foregroundStyle(.appSecode)
    }
    
    var loginTextFields: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                AppTextField(
                    text: $vm.email,
                    placeholder: "email".localized(),
                    validationRules: [.email],
                    keyboardType: .emailAddress,
                    textContentType: .username
                )
                AppTextField(
                    text: $vm.password,
                    placeholder: "password".localized(),
                    validationRules: [.password],
                    isSecure: true,
                    textContentType: .password
                )
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        // Enable password AutoFill for the login form
        .textContentType(.username) // This helps iOS identify this as a login form
    }
    
    var forgotPasswordButton: some View {
        Button {
            appRouter.push(.EmailScreen)
        } label: {
            Text("forget_password".localized())
                .foregroundStyle(.appPrimary)
                .font(.title3)
                .underline()
        }
        .buttonStyle(AppButton(kind: .plain))
    }
    
    var loginButton: some View {
        Button {
            Task {
                await vm.login() { response in
                    guard let data = response.data else { return }
                    
                    switch data.loginStatus {
                    case .Success:
                        if data.token != nil {
                            authManager.login(userDataLogin: data)
                            Task{
                                    // Save credentials to password manager after successful login
                                await saveCredentialsToPasswordManager()
                            }
                        }
                    case .InValidCredintials:
                        showToast(response.message ?? "", appearance: .error)
                        debugPrint("InValidCredintials")
                    case .UserLockedOut:
                        debugPrint("UserLockedOut")
                    case .UserNotConfirmed:
                        showToast(response.message ?? "", appearance: .error)
                        appRouter.pushView(OTPScreen(email: vm.email))
                    case .Error:
                        debugPrint("Error")
                    case .none:
                        debugPrint("none")
                    }
                }
            }
        } label: {
            if vm.viewState == .loading {
                ProgressView()
                    .appProgressStyle(color: .white)
            } else {
                Text("log_in".localized())
                    .font(.title3)
            }
        }
        .buttonStyle(AppButton(kind: .solid, width: 300, disabled: !isFormValid))
        .disabled(!isFormValid)
        .padding(.horizontal)
    }
    
    var createAccountButton: some View {
        Button {
            appRouter.presentFullScreenCover(.signUp)
        } label: {
            Text("create_account".localized())
                .font(.title3)
                .foregroundStyle(.appSecode)
                .underline()
        }
        .buttonStyle(AppButton(kind: .plain))
    }
    
    // MARK: - Password Manager Integration
    
    /// Save credentials to iOS password manager
    private func saveCredentialsToPasswordManager() async {
        // Get your app's bundle identifier or use a custom service identifier
        let serviceIdentifier = Bundle.main.bundleIdentifier ?? "com.yourapp.login"
        
        // Create the credential
        let credential = ASPasswordCredential(
            user: vm.email,
            password: vm.password
        )
        
        // Save to password manager
        do {
            try await ASCredentialIdentityStore.shared.saveCredentialIdentities([
                ASPasswordCredentialIdentity(
                    serviceIdentifier: ASCredentialServiceIdentifier(
                        identifier: serviceIdentifier,
                        type: .URL
                    ),
                    user: vm.email,
                    recordIdentifier: nil
                )
            ])
            
            // Optional: Show success message
            debugPrint("Credentials saved to password manager successfully")
        } catch {
            debugPrint("Failed to save credentials: \(error)")
        }
    }
}

#Preview {
    LoginScreen()
}


