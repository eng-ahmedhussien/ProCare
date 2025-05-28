//
//  PhoneScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import SwiftUI

struct PhoneScreen: View {
    //MARK: - Properties
    @StateObject var vm = ResetPasswordFlowVM()
    @EnvironmentObject var appRouter: AppRouter
    private var isFormValid: Bool {
        ValidationRule.phone.validate(vm.phone) == nil
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            AppTextField(text: $vm.phone, placeholder: "phone".localized(), validationRules: [.phone])
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
extension PhoneScreen {
    var sendButton: some View {
        Button {
            Task {
                await vm.resendCode {
                    appRouter.pushView(OTPScreen(phonNumber: vm.phone, comeFrom: .forgetPassword))
                }
            }
        } label: {
            if vm.viewState == .loading  {
                ProgressView()
                    .appProgressStyle()
            }
            else{
                Text("send".localized())
                    .font(.title3)
            }
        }
        .buttonStyle(AppButton(kind: .solid,width: 300,disabled: !isFormValid))
        .disabled(!isFormValid)
        .padding()
    }
}

#Preview {
    PhoneScreen()
}
