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
    
    var body: some View {
        VStack {
            PasswordTextField(placeHolder: "new password",password: $vm.password)
                .mainTextFieldStyle(errorMessage: vm.passwordPrompt)
                .padding(.top,30)
                .padding(.horizontal)
            
            PasswordTextField(placeHolder: "confirm new password",password: $vm.confirmPassword)
                .mainTextFieldStyle(errorMessage: vm.confirmPasswordPrompt)
                .padding()
            
            Spacer()
            
            Button {
                Task {
                    await vm.resetPassword(phoneNumber: phone) {
                        appRouter.popToRoot()
                    }
                }
            } label: {
                Text("save".localized())
                    .font(.title3)
            }
            .solid(width: 300,isDisabled: !vm.isPasswordValid())
        }
        .appNavigationBar(title: "Reset password".localized())
    }
}

#Preview {
    NewPasswordScreen()
}


