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
    @EnvironmentObject var profileVM: ProfileVM
    private var isFormValid: Bool {
        ValidationRule.phone.validate(vm.phone) == nil &&
        ValidationRule.password.validate(vm.password) == nil
    }
    
    var body: some View {
        NavigationView{
            content
                .disabled(vm.viewState == .loading)
                .dismissKeyboardOnTap()
                .toolbar {
                    changeLanguageButton
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack{
            headerTitle
            
            loginTextFields
            
            forgotPasswordButton
            
            Spacer()
            
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
        VStack(alignment: .center){
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
        VStack(alignment: .leading,spacing: 0){
            Group {
                AppTextField(text: $vm.phone, placeholder: "phone_number".localized(), validationRules: [.phone])
                AppTextField(text: $vm.password, placeholder: "password".localized(), validationRules: [.password], isSecure: true)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    
    var forgotPasswordButton: some View {
        Button {
            appRouter.push(.PhoneScreen)
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
                await vm.login(){ response in
                    guard let data = response.data else {return}
                    
                    switch data.loginStatus {
                    case .Success:
                        if data.token != nil {
                            Task{
                                await profileVM.fetchProfile()
                            }
                            authManager.login(userDataLogin: data )
                        }
                    case .InValidCredintials:
                        showToast(response.message ?? "" , appearance: .error)
                        debugPrint("InValidCredintials")
                    case .UserLockedOut:
                        debugPrint("UserLockedOut")
                    case .UserNotConfirmed:
                        showToast(response.message ?? "" , appearance: .error)
                        appRouter.pushView(OTPScreen(phonNumber: vm.phone))
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
                    .appProgressStyle()
            } else {
                Text("log_in".localized())
                    .font(.title3)
            }
        }
        .buttonStyle(AppButton(kind: .solid,width: 300 ,disabled: !isFormValid))
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


