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
        VStack{
            heater

            Spacer()
            
            VStack(alignment: .leading){
                Text("hello".localized())
                Text("log_in_to_start".localized())
            }
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            loginTextFields
            
            Spacer()
            
            VStack(spacing: 0){
                Button {
                    Task {
                        await vm.login(){ state in
                            switch state {
                            case .userNotConfirmed:
                                appRouter.pushView(OTPScreen(phonNumber: vm.phone))
                            case .withToken:
                                guard let data = vm.userDataLogin else { return }
                                Task{
                                    await profileVM.fetchProfile()
                                }
                                authManager.login(userDataLogin: data )
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
                
                Button {
                    appRouter.presentFullScreenCover(.signUp)
                } label: {
                    Text("create_account".localized())
                        .font(.title3)
                        .underline()
                }
                .buttonStyle(AppButton(kind: .plain))
            }
        }
        .disabled(vm.viewState == .loading)
        .dismissKeyboardOnTap()
    }
}

extension LoginScreen {
    var heater: some View {
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
    
    var loginTextFields: some View {
        VStack(alignment: .leading,spacing: 0){
            Group {
                AppTextField(text: $vm.phone, placeholder: "phone_number".localized(), validationRules: [.phone])
                AppTextField(text: $vm.password, placeholder: "password".localized(), validationRules: [.password], isSecure: true)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            
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
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}

#Preview {
    LoginScreen()
}
