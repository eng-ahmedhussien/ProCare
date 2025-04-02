//
//  LoginScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import SwiftUI

struct LoginScreen: View {
    
    @StateObject var vm = LoginVM()
    @State private var gotSignUp = false
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack(alignment: .leading){
                Text("hello!".localized())
                Text("log in to start".localized())
            }
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack(alignment: .leading,spacing: 0){
                TextField("phone".localized(), text: $vm.phone)
                TextField("password".localized(), text: $vm.password)
                Button {
                } label: {
                    Text("forget password ?".localized())
                        .foregroundStyle(.appPrimary)
                        .font(.title3)
                        .underline()
                }
                .plain()
                
            }
            .mainTextFieldStyle()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Spacer()
            
            VStack(spacing: 0){
                Button {
                    Task {
                        await vm.login()
                    }
                } label: {
                    Text("log in".localized())
                        .font(.title3)
                }
                .solid(width: 300)
                
                Button {
                    gotSignUp = true
                } label: {
                    Text("create account".localized())
                        .font(.title3)
                        .underline()
                }
                .plain()
            }
            
        }
        .fullScreenCover(isPresented: $gotSignUp) {
            SignUPScreen()
        }
      
    }
}

#Preview {
    LoginScreen()
//        .environment(\.locale, Locale(identifier: "ar"))
//        .environment(\.layoutDirection, .rightToLeft) // Ensures proper RTL layout
}
