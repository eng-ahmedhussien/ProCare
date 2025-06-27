//
//  NewPasswordScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import SwiftUI

struct NewPasswordScreen: View {

    @StateObject var vm = PasswordFlowVM()
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
                AppTextField(text: $vm.password, placeholder: "new_password".localized(), validationRules: [.password], isSecure: true)
                AppTextField(text: $vm.confirmPassword, placeholder: "confirm_new_password".localized(), validationRules: [.confirmPassword($vm.password)], isSecure: true)
            }
            .padding(.top,30)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                Task {
                    await vm.resetPassword(email: phone,resetToken: resetToken) {
                        appRouter.popToRoot()
                    }
                }
            } label: {
                Text("save".localized())
                    .font(.title3)
            }
            .buttonStyle(AppButton(kind: .solid,disabled: !isFormValid))
            .disabled(!isFormValid)
            .padding(.horizontal)
        }
        .appNavigationBar(title: "reset_password".localized())
    }
}

#Preview {
    NewPasswordScreen()
}
