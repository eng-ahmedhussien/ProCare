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
    private var isFormValid: Bool {
        ValidationRule.phone.validate(vm.phone) == nil &&
        ValidationRule.password.validate(vm.password) == nil
    }
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack(alignment: .leading){
                Text("hello!".localized())
                Text("log in to start".localized())
            }
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack(alignment: .leading,spacing: 0){
                Group {
                    AppTextField(text: $vm.phone, placeholder: "phone number".localized(), validationRules: [.phone])
                    AppTextField(text: $vm.password, placeholder: "password".localized(), validationRules: [.password], isSecure: true)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                Button {
                    appRouter.push(.PhoneScreen)
                } label: {
                    Text("forget password ?".localized())
                        .foregroundStyle(.appPrimary)
                        .font(.title3)
                        .underline()
                }
                .buttonStyle(AppButton(kind: .plain))
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
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
                                authManager.login(userDataLogin: data )
                            }
                        }
                    }
                } label: {
                    if vm.viewState == .loading {
                        ProgressView()
                            .appProgressStyle()
                    } else {
                        Text("log in".localized())
                            .font(.title3)
                    }
                }
                .buttonStyle(AppButton(kind: .solid,width: 300 ,disabled: !isFormValid))
                .disabled(!isFormValid)
                
                Button {
                    appRouter.presentFullScreenCover(.signUp)
                } label: {
                    Text("create account".localized())
                        .font(.title3)
                        .underline()
                }
                .buttonStyle(AppButton(kind: .plain))
            }
        }
    }
}

#Preview {
    LoginScreen()
}
