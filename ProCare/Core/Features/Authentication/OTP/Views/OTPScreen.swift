//
//  OTPScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI
import Combine

struct OTPScreen: View {
    
    //MARK: - Properties
    @State private var pinOne: String = ""
    @State private var pinTwo: String = ""
    @State private var pinThree: String = ""
    @State private var pinFour: String = ""
    
    @State private var isLoading = false
    @StateObject var vm = OTPVM()
    @StateObject var resetPasswordFlowVM = ResetPasswordFlowVM()
    @FocusState private var pinFocusState : FocusPin?
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authManager: AuthManager
    
    var phonNumber: String = ""
    var comeFrom: ComeFrom = .login
    
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    enum ComeFrom {
        case login, signUp, forgetPassword
    }
    //MARK: - Body
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                Text("please".localized())
                Text("enter otp!".localized())
            }
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            pinView
         
            ResendOTPView(vm: vm, phonNumber: phonNumber)
            
            VerifyButton
        }
        .appNavigationBar(title: "otp".localized())
//        .disabled(vm.viewState == .loading)
//        .appNavigationBar(title:"otp".localized())
        
    }
}

//MARK: - Extension
extension OTPScreen {
    var pinView: some View {
        HStack(spacing:15) {
            TextField("", text: $pinOne)
                .otpModifer(pin: $pinOne, isFocused: .constant(pinFocusState == .pinOne))
                .onChange(of: pinOne) { newVal in
                    if newVal.count == 1 { pinFocusState = .pinTwo }
                }
                .focused($pinFocusState, equals: .pinOne)
                .textContentType(.oneTimeCode)
            
            TextField("", text: $pinTwo)
                .otpModifer(pin: $pinTwo, isFocused: .constant(pinFocusState == .pinTwo))
                .onChange(of: pinTwo) { newVal in
                    if newVal.count == 1 {
                        pinFocusState = .pinThree
                    } else if newVal.count == 0 {
                        pinFocusState = .pinOne
                    }
                    
                }
                .focused($pinFocusState, equals: .pinTwo)
                .textContentType(.oneTimeCode)
            
            TextField("", text: $pinThree)
                .otpModifer(pin: $pinThree, isFocused: .constant(pinFocusState == .pinThree))
                .onChange(of: pinThree) { newVal in
                    if newVal.count == 1 {
                        pinFocusState = .pinFour
                    } else if newVal.count == 0 {
                        pinFocusState = .pinTwo
                    }
                }
                .focused($pinFocusState, equals: .pinThree)
                .textContentType(.oneTimeCode)
            
            TextField("", text: $pinFour)
                .otpModifer(pin: $pinFour, isFocused: .constant(pinFocusState == .pinFour))
                .onChange(of: pinFour) { newVal in
                    if newVal.count == 0 {
                        pinFocusState = .pinThree
                    }
                }
                .focused($pinFocusState, equals: .pinFour)
                .textContentType(.oneTimeCode)
        }
        .padding(.vertical)
        .onAppear {
            pinFocusState = .pinOne
        }
    }
    
    var VerifyButton: some View {
        Button {
            let parameter = [
                "phoneNumber": phonNumber,
                "code": pinOne + pinTwo + pinThree + pinFour
            ]
            isLoading = true
            Task {
                switch comeFrom {
                case .login, .signUp:
                    await vm.confirmCode(parameter: parameter){
                        guard let userDataLogin = vm.userDataLogin else { return }
                        appRouter.popToRoot()
                        authManager.login(userDataLogin: userDataLogin)
                    }
                case .forgetPassword:
                    await resetPasswordFlowVM.checkCode(phoneNumber:phonNumber, otp: pinOne + pinTwo + pinThree + pinFour){ resetToken in
                        //if status {
                        appRouter.push(.NewPasswordScreen(phone: phonNumber,resetToken: resetToken))
                       // }
                        
                        
                    }
                }
                
                isLoading = false
            }
            
        } label: {
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
            else{
                Text("Verify".localized())
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(AppButton(kind: .solid,disabled: pinOne.isEmpty || pinTwo.isEmpty || pinThree.isEmpty || pinFour.isEmpty))
        .disabled(pinOne.isEmpty || pinTwo.isEmpty || pinThree.isEmpty || pinFour.isEmpty)
        .padding(.horizontal)
    }
}


#Preview {
    OTPScreen()
}
