//
//  PhoneScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import SwiftUI

struct PhoneScreen: View {
    
    @StateObject var vm = ResetPasswordFlowVM()
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        VStack {
            TextField("phone", text: $vm.phone)
                .mainTextFieldStyle(errorMessage: vm.phonePrompt)
                .padding(.top,20)
                .padding(.horizontal,10)
                .keyboardType(.phonePad)
            
            Spacer()
            
            Button {
                Task {
                    await vm.resendCode {
                        appRouter.pushView(OTPScreen(phonNumber: vm.phone, comeFrom: .forgetPassword))
                    }
                }
            } label: {
                if vm.viewState == .loading  {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                else{
                    Text("send".localized())
                        .font(.title3)
                }
            }
            .solid(width: 300, isDisabled: !vm.isPhoneValid())
            .disabled(!vm.isPhoneValid())
            .padding()
        }
        .disabled(vm.viewState == .loading)
        .appNavigationBar(title:"forget password".localized())
    }
}

#Preview {
    PhoneScreen()
}


struct NavigationBar<Title: View, Leading: View, Trailing: View>: View {
    
    // MARK: - Init
    
    init(@ViewBuilder title: () -> Title, leading: () -> Leading = { EmptyView() }, trailing: () -> Trailing = { EmptyView() }) {
        self.title = title()
        self.leading = leading()
        self.trailing = trailing()
    }
    
    // MARK: - Properties
    
    var title: Title
    var leading: Leading
    var trailing: Trailing
    
    // MARK: - Properties (View)
    
    var body: some View {
        ZStack {
            Color.white
            HStack(spacing: 0) {
                leading.padding()
                Spacer()
                trailing.padding()
            }
            HStack {
                title.padding()
            }
        }
        .foregroundStyle(Color.black)
        .frame(height: 50)
    }
    
}
