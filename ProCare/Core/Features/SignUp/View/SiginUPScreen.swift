//
//  SiginUPScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import SwiftUI


struct SignUPScreen: View {
    
    @State private var gotLogin = false
    @State private var gotOTP = false
    @StateObject var vm = SignUpVM()
    @EnvironmentObject var appRouter: AppRouter
    
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("hello!".localized())
                Text("create account".localized())
            }
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack{
                HStack{
                    TextField("name".localized(), text: $vm.name)
                    TextField("second name".localized(), text: $vm.secondName)
                }
                TextField("phone".localized(), text: $vm.phone)
                TextField("password".localized(), text: $vm.password)
                TextField("confirm password".localized(), text: $vm.confirmPassword)
            }
            .mainTextFieldStyle()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Spacer()
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage.errors?.values.flatMap { $0 }.joined(separator: "\n") ?? "")
                    .foregroundColor(.red)
                    .padding()
            }
            
            VStack(spacing: 0){
                Button {
                    Task {
                       
                        await vm.signUp(){ otp in
                            debugPrint(otp ?? "nil")
                            gotOTP.toggle()
                        }
                    }
                } label: {
                    Text("Sign Up".localized())
                        .font(.title3)
                        ///. font(.system(size: 24, weight: .bold, design: .default))
                }
                .solid(width: 300)
                
                Button {
                    gotLogin.toggle()
                } label: {
                    Text("have account?".localized())
                        .font(.title3)
                }
                .plain()
            }
            
        }
        .fullScreenCover(isPresented: $gotLogin) {
            LoginScreen()
        }
        .fullScreenCover(isPresented: $gotOTP) {
            OTPScreen(phonNumber: vm.phone)
        }
        .alert(isPresented: .constant(vm.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage?.errors?.values.flatMap { $0 }.joined(separator: "\n") ?? "Unknown error"))
        }
    }
}

#Preview {
    SignUPScreen()
}



