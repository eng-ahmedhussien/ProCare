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
    
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("hello!")
                Text("create account")
            }
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack{
                HStack{
                    TextField("name", text: $name)
                    TextField("second name", text: $secondName)
                }
                TextField("phone", text: $phone)
                TextField("password", text: $password)
                TextField("confirm password", text: $confirmPassword)
            }
            .mainTextFieldStyle()
            
            Spacer()
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
//            "firstName": "ahmed",
//             "lastName": "hussien",
//             "phoneNumber": "+201553855450",
//             "password": "@Benten10",
//             "confirmPassword": "@Benten10"
            
            VStack(spacing: 0){
                Button {
                   // Task {
                        let parameter = [
                            "firstName": name,
                             "lastName": secondName,
                             "phoneNumber": phone,
                             "password": password,
                             "confirmPassword": confirmPassword
                        ]
//                        await vm.signUp(parameters: parameter)
//                    }
                    
                    vm.signUpComin(parameters: parameter)
                    
                } label: {
                    Text("Sign Up")
                        .font(.title3)
                }
                .solid(width: 300)
                
                Button {
                    print("sign up")
                } label: {
                    Text("have account? ")
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



