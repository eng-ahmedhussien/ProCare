//
//  LoginScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var popUpControl: PopUpHelper
    @StateObject var vm = LoginVM()
    @EnvironmentObject var appRouter: AppRouter
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
            .onTapGesture {
                popUpControl.show(
                    VStack(spacing: 20) {
                        Text("This is a custom popup!")
                        Button("Close") {
                            popUpControl.dismiss()
                        }
                    }
                    .frame(maxWidth: 300)
                )
                
                popUpControl.show(
                    VStack {
                        Text("Tap outside or 'Close' to dismiss")
                        Button("Close") {
                            popUpControl.dismiss()
                        }
                    },
                    dismissOnBackgroundTap: true
                )
            }
            
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
                .buttonStyle(.plain)
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Spacer()
            
            VStack(spacing: 0){
                Button {
                    Task {
                        await vm.login(){
                            appRouter.presentFullScreenCover(.otpScreen)
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
                .buttonStyle(.solid, width: 300, disabled: isFormValid == false)
                
                Button {
                    appRouter.presentFullScreenCover(.signUp)
                } label: {
                    Text("create account".localized())
                        .font(.title3)
                        .underline()
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    LoginScreen()
}
