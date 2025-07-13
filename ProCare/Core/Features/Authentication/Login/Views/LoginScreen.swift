    //
    //  LoginScreen.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 02/04/2025.
    //

import SwiftUI

struct LoginScreen: View {
    @StateObject var vm = LoginVM()
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authManager: AuthManager
    
    @State private var showNotConfirmedAlert = false // Add this line
    
    private var isFormValid: Bool {
        !vm.email.isEmpty &&
        !vm.password.isEmpty &&
            //        ValidationRule.email.validate(vm.email) == nil &&
        ValidationRule.password.validate(vm.password) == nil
    }
    
    var body: some View {
        NavigationView {
            content
                .dismissKeyboardOnTap()
                .disabled(vm.viewState == .loading)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        changeLanguageButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SupportButton(color: .appPrimary)
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .alert("account_not_confirmed".localized(), isPresented: $showNotConfirmedAlert) { // Add this modifier
                    Button("ok".localized(), role: .cancel) {
                        appRouter
                            .pushView(
                                OTPScreen(email: vm.email,comeFrom: .login)
                            )
                    }
                } message: {
                    Text("account_not_confirmed_message".localized())
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
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
                        }
                    case .InValidCredintials:
                        showToast(response.message ?? "", appearance: .error)
                        debugPrint("InValidCredintials")
                    case .UserLockedOut:
                        debugPrint("UserLockedOut")
                    case .UserNotConfirmed:
                        showNotConfirmedAlert = true // Show the alert
                        
                            //showToast(response.message ?? "", appearance: .error)
                        
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
    
}

#Preview {
    LoginScreen()
}


