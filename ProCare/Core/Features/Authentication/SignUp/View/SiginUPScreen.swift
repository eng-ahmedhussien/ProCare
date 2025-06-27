//
//  SiginUPScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import SwiftUI

struct SignUPScreen: View {
    @StateObject var vm = SignUpVM()
    @EnvironmentObject var appRouter: AppRouter
    private var isFormValid: Bool {
        ValidationRule.isEmpty.validate(vm.name) == nil &&
        ValidationRule.isEmpty.validate(vm.secondName) == nil &&
        ValidationRule.email.validate(vm.email) == nil &&
        ValidationRule.phone.validate(vm.phone) == nil &&
        ValidationRule.password.validate(vm.password) == nil &&
        ValidationRule.confirmPassword($vm.password).validate(vm.confirmPassword) == nil
    }
    //MARK: - Body
    var body: some View {
        content
            .popupHost()
            .disabled(vm.viewState == .loading)
            .dismissKeyboardOnTap()
    }
    
    @ViewBuilder
    private var content: some View {
        VStack{
            header
            signUpForm
            Spacer()
            SignUpButton
            haveAccountButton
        }
    }
}

extension SignUPScreen {
    var header: some View {
        VStack(alignment: .leading){
            Text("hello".localized())
            Text("create_account".localized())
        }
        .font(.title.bold())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    var signUpForm: some View {
        VStack(spacing: 30){
            HStack(spacing: 30){
                AppTextField(
                    text: $vm.name,
                    placeholder: "name".localized(),
                    validationRules: [.isEmpty]
                )
                AppTextField(
                    text: $vm.secondName,
                    placeholder: "second_name".localized(),
                    validationRules: [.isEmpty]
                )
            }
            AppTextField(
                text: $vm.email,
                placeholder: "email".localized(),
                validationRules: [.email]
            )
            AppTextField(
                text: $vm.phone,
                placeholder: "phone".localized(),
                validationRules: [.phone]
            )
            AppTextField(
                text: $vm.password,
                placeholder: "password".localized(),
                validationRules: [.password],isSecure: true
            )
            AppTextField(
                text:  $vm.confirmPassword,
                placeholder: "confirm_password".localized(),
                validationRules: [.confirmPassword($vm.password)], isSecure: true
            )
        }
        .padding()
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    
    var SignUpButton: some View {
        Button {
            Task {
                await vm.signUp(){ response in
                    if let status = response.status {
                        switch status {
                        case .Success:
                            showToast("\(response.message ?? "")", appearance: .success)
                            appRouter.dismissFullScreenOver()
                            appRouter.pushView(OTPScreen(email: vm.email))
                        case .Error:
                            showToast("\(response.message ?? "")", appearance: .error)
                        case .AuthFailure:
                            return
                        case .Conflict:
                            return
                        }
                    }
                }
            }
        } label: {
            if vm.viewState == .loading {
                ProgressView()
                    .appProgressStyle()
            } else {
                Text("sign_up".localized())
                    .font(.title3)
            }
      
        }
        .buttonStyle(AppButton(kind: .solid,disabled: !isFormValid))
        .disabled(!isFormValid)
        .padding(.horizontal)
    }
    
    var haveAccountButton: some View {
        Button {
            appRouter.dismissFullScreenOver()
        } label: {
            Text("have_account".localized())
                .font(.title3)
                .underline()
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    SignUPScreen()
        .environment(\.locale, .init(identifier: "ar"))
}
