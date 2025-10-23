//
//  ChangePasswordScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 07/07/2025.
//

import SwiftUI

struct ChangePasswordScreen: View {

    @StateObject var vm = PasswordFlowVM()
    @EnvironmentObject var appRouter: AppRouter

    private var isFormValid: Bool {
        ValidationRule.password.validate(vm.oldPassword) == nil &&
        ValidationRule.password.validate(vm.password) == nil
    }
    
    var body: some View {
        VStack {
            Group{
                AppTextField(text: $vm.oldPassword, placeholder: "old_password".localized(), validationRules: [.password], isSecure: true)
                AppTextField(text: $vm.password, placeholder: "new_password".localized(), validationRules: [.password], isSecure: true)
            }
            .padding(.top,30)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                Task {
                    await vm.changePassword() {
                        appRouter.popToRoot()
                    }
                }
            } label: {
                Text("save".localized())
                    .font(.title3)
            }
            .appButtonStyle(.solid,disabled: !isFormValid)
            .padding(.horizontal)
        }
        .appNavigationBar(title: "reset_password".localized())
    }
}

#Preview {
    ChangePasswordScreen()
}
