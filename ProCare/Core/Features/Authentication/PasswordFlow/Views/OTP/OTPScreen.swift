//
//  OTPScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI
import Combine

struct OTPScreen: View {
    
    @StateObject var vm                 = PasswordFlowVM()
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authManager: AuthManager
    
    //MARK: - Properties
    @State private var pinOne: String   = ""
    @State private var pinTwo: String   = ""
    @State private var pinThree: String = ""
    @State private var pinFour: String  = ""
    @State private var isLoading        = false
    @FocusState private var pinFocusState : FocusPin?
    
    var email: String                   = ""
    var comeFrom: ComeFrom              = .login
    
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    enum ComeFrom {
        case login, signUp, forgetPassword
    }
    
    //MARK: - Body
    var body: some View {
        ScrollView {
            header
            
            pinView
            
            ResendOTPView(vm: vm, email: email)
            
            VerifyButton
        }
        .appNavigationBar(title: "otp".localized())
        .task {
            if comeFrom == .login {
                let parameter = ["email": email]
                await vm.resendCode(parameter: parameter)
            }
        }
        //        .disabled(vm.viewState == .loading)
        
    }
}

//MARK: - Extension
extension OTPScreen {
    var header: some View {
        VStack(alignment: .center){
            Image(.proCareLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, alignment: .center)
                .opacity(0.9)
            VStack{
                Text("please".localized())
                Text("enter otp!".localized())
            }.font(.title3.bold())
        }
        .font(.title.bold())
        .foregroundStyle(.appSecode)
        
    }
    
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
                "email": email,
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
                    await vm.checkCode(email:email, otp: pinOne + pinTwo + pinThree + pinFour){ resetToken in
                        appRouter.push(.NewPasswordScreen(phone: email,resetToken: resetToken))
                    }
                }
                
                isLoading = false
            }
            
        } label: {
            Text("Verify".localized())
                .font(.title3)
                .foregroundColor(.white)
        }
        .appButtonStyle(disabled: pinOne.isEmpty || pinTwo.isEmpty || pinThree.isEmpty || pinFour.isEmpty, isLoading: isLoading )
        .padding(.horizontal)
    }
}


#Preview {
    OTPScreen()
}
