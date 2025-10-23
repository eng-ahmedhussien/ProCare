//
//  PhoneScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import SwiftUI

struct EmailScreen: View {
    //MARK: - Properties
    @StateObject var vm = PasswordFlowVM()
    @EnvironmentObject var appRouter: AppRouter
    private var isFormValid: Bool {
        ValidationRule.email.validate(vm.email) == nil
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            AppTextField(text: $vm.email, placeholder: "email".localized(), validationRules: [.email])
                .padding(.top,30)
                .padding(.horizontal)
            
            Spacer()
            
            sendButton
        }
        .disabled(vm.viewState == .loading)
        .appNavigationBar(title: "forget_password".localized())
    }
}
//MARK: - extension
extension EmailScreen {
    var sendButton: some View {
        Button {
            Task {
                await vm.forgetPassword {
                    appRouter.pushView(OTPScreen(email: vm.email, comeFrom: .forgetPassword))
                }
            }
        } label: {
            if vm.viewState == .loading  {
                ProgressView()
                    .appProgressStyle(color: .white)
            }
            else{
                Text("send".localized())
                    .font(.title3)
            }
        }
        .appButtonStyle(.solid,disabled: !isFormValid)
        .padding()
    }
}

#Preview {
    EmailScreen()
}
