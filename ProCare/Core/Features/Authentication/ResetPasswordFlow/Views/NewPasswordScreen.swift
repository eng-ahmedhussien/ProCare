//
//  NewPasswordScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import SwiftUI

struct NewPasswordScreen: View {

    @StateObject var vm = ResetPasswordFlowVM()
    @EnvironmentObject var appRouter: AppRouter
    var phone: String = ""
    var resetToken: String = ""
    
    private var isFormValid: Bool {
        ValidationRule.password.validate(vm.password) == nil &&
        ValidationRule.confirmPassword($vm.password).validate(vm.confirmPassword) == nil
    }
    
    var body: some View {
        VStack {
            
            Group{
                AppTextField(text: $vm.password, placeholder: "new password".localized(), validationRules: [.password], isSecure: true)
                AppTextField(text: $vm.confirmPassword, placeholder: "confirm new password".localized(), validationRules: [.confirmPassword($vm.password)], isSecure: true)
            }
            .padding(.top,30)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                Task {
                    await vm.resetPassword(phoneNumber: phone,resetToken: resetToken) {
                        appRouter.popToRoot()
                    }
                }
            } label: {
                Text("save".localized())
                    .font(.title3)
            }
            .buttonStyle(AppButton(kind: .solid,width: 300,disabled: !isFormValid))
            .disabled(!isFormValid)

        }
        .appNavigationBar(title: "Reset password".localized())
    }
}

#Preview {
    NewPasswordScreen()
}


