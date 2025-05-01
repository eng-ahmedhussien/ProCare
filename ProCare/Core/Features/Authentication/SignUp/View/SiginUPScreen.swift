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
        ValidationRule.phone.validate(vm.phone) == nil &&
        ValidationRule.password.validate(vm.password) == nil &&
        ValidationRule.confirmPassword($vm.password).validate(vm.confirmPassword) == nil

    }
    //MARK: - Body
    var body: some View {
        VStack{
            header
            
            signUpForm
            
            Spacer()
            
            SignUpButton
            
            haveAccountButton
            
        }
        .appNavigationBar(title: "signUp".localized())
    }
}

extension SignUPScreen {
    var header: some View {
        VStack(alignment: .leading){
            Text("hello!".localized())
            Text("create account".localized())
        }
        .font(.title.bold())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    var signUpForm: some View {
        VStack(spacing: 30){
            HStack(spacing: 30){
                AppTextField(text: $vm.name, placeholder: "name".localized(), validationRules: [.isEmpty])
                AppTextField(text: $vm.secondName, placeholder: "second name".localized(), validationRules: [.isEmpty])
            }
            
            AppTextField(text: $vm.phone, placeholder: "phone".localized(), validationRules: [.phone])
            AppTextField(text: $vm.password, placeholder: "password".localized(), validationRules: [.password])
            AppTextField(text:  $vm.confirmPassword, placeholder: "confirm password".localized(), validationRules: [.confirmPassword($vm.password)])
        }
        .padding()
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    
    var SignUpButton: some View {
        Button {
            Task {
                await vm.signUp(){ otp in
                    debugPrint(otp ?? "nil")
                    appRouter.dismissFullScreenOver()
                    appRouter.pushView(OTPScreen(phonNumber: vm.phone))
                
                }
            }
        } label: {
            Text("Sign Up".localized())
                .font(.title3)
                ///. font(.system(size: 24, weight: .bold, design: .default))
        }
        .buttonStyle(.solid, width: 300, disabled: isFormValid == false)
    }
    
    var haveAccountButton: some View {
        Button {
            appRouter.dismissFullScreenOver()
        } label: {
            Text("have account?".localized())
                .font(.title3)
        }
        .buttonStyle(.plain)
    }

}

#Preview {
    SignUPScreen()
}



