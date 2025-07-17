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
    @State private var name = ""

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
            
            AppTextField(text: $name,placeholder: "name",  validationRules: [.isEmpty], style:  .plain
            )
            
        }
        .padding()
        .onAppear {
              password = "123"
              confirmPassword = "1234"
              age = "abc"
              phoneNumber = ""
              name = " "
          }
    }
}
#Preview {
    AppTextFieldPreview()
}

struct AppTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var validationRules: [ValidationRule] = []
    var isSecure: Bool = false
    var style: AppTextFieldStyle = .bordered
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                            .textContentType(textContentType)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            // Enable password AutoFill
                            .textInputAutocapitalization(.never)
                    } else {
                        TextField(placeholder, text: $text)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            // Enable AutoFill for username/email
                            .textInputAutocapitalization(.never)
                    }
                }
                .foregroundStyle(.appSecode)
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
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .overlay(
                Group {
                    switch style {
                    case .bordered:
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(showError ? Color.red : Color.appSecode, lineWidth: 1)
                    case .plain:
                        if showError {
                            // Uncomment if needed
                            // RoundedRectangle(cornerRadius: 30)
                            //     .stroke(Color.red, lineWidth: 1)
                        }
                    }
                }
            )
            
            if showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
                    .padding(.leading)
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
enum AppTextFieldStyle {
    case plain
    case bordered
}
