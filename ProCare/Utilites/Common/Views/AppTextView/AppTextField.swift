//
//  LabelTextView.swift
//  AppTest
//
//  Created by ahmed hussien on 29/04/2024.
//

import SwiftUI

struct AppTextFieldPreview: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var age = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        VStack(spacing: 20) {
            AppTextField(text: $password, placeholder: "Enter password", validationRules: [.isEmpty, .password],
                isSecure: true
            )
            
            AppTextField(text: $confirmPassword, placeholder: "Confirm password",validationRules: [.isEmpty, .confirmPassword($password)],
                isSecure: true
            )
            
            AppTextField(text: $age, placeholder: "Enter your age", validationRules: [.numeric, .limit(min: 13, max: 120)]
            )
            
            AppTextField(text: $phoneNumber,placeholder: "Enter mobile number",  validationRules: [.isEmpty, .phone]
            )
        }
        .padding()
    }
}
#Preview {
    AppTextFieldPreview()
}


struct AppTextField: View {
    @Binding var text: String
    var placeholder: String
    var validationRules: [ValidationRule]
    var isSecure: Bool = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showPassword = false
    @FocusState private var isFocused: Bool
    @State private var hasInteracted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
               // .focused($isFocused)
                .onChange(of: text, perform: { _ in
                    if text.isEmpty {
                        resetValidation()
                    } else {
                        validateInput()
                    }
                })

                if isSecure {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? .red : .gray, lineWidth: 1)
            )
            
            if showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showError)
    }
    
    private func resetValidation() {
        showError = false
        errorMessage = ""
    }
    
    private func validateInput() {
        showError = false
        errorMessage = ""
        
        for rule in validationRules {
            if let error = rule.validate(text) {
                showError = true
                errorMessage = error
                break
            }
        }
    }
}
