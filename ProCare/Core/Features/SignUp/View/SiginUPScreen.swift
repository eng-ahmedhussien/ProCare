//
//  SiginUPScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import SwiftUI


struct SiginUPScreen: View {
    
    @State var name: String = ""
    @State var secondName: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
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
                    TextField("name".localized(), text: $name)
                    TextField("second name".localized(), text: $secondName)
                }
                TextField("phone".localized(), text: $phone)
                TextField("password".localized(), text: $password)
                TextField("confirm password".localized(), text: $confirmPassword)
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
                        let parameter = [
                            "firstName": name,
                            "lastName": secondName,
                            "phoneNumber": phone,
                            "password": password,
                            "confirmPassword": confirmPassword
                        ]
                        await vm.signUp(parameters: parameter){ otp in
                            print(otp ?? "nil")
                            appRouter.presentFullScreenCover(.otpScreen)
                        }
                    }
                } label: {
                    Text("Sign Up".localized())
                        .font(.title3)
                        ///. font(.system(size: 24, weight: .bold, design: .default))
                }
                .solid(width: 300)
                
                Button {
                    print("sign up".localized())
                } label: {
                    Text("have account?".localized())
                        .font(.title3)
                }
                .plain()
            }
            
        }
    }
}

#Preview {
    SiginUPScreen()
}



