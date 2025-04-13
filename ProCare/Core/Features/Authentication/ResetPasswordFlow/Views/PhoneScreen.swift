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
    private var isFormValid: Bool {
        ValidationRule.phone.validate(vm.phone) == nil
    }
    
    var body: some View {
        VStack {
            AppTextField(text: $vm.phone, placeholder: "phone".localized(), validationRules: [.phone])
            
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
            .buttonStyle(.solid, width: 300, disabled: isFormValid == false)
            .disabled(isFormValid == false)
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
