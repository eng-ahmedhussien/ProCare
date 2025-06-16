//
//  ResetPasswordFlowVM.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import Foundation
import Combine

@MainActor
class ResetPasswordFlowVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var viewState: ViewState = .idle
    
    // MARK: - Validation Prompts
    var phonePrompt: String {
        if phone.isEmpty || isPhoneValid() {
            return ""
        } else {
            return "Phone number must start with +20 (e.g. +201XXXXXXXXX)"
        }
    }
    var passwordPrompt: String {
        if password.isEmpty || isPasswordValid() {
            return ""
        } else {
            return "Make sure your password has 8+ characters, a capital letter, number, and a symbol."
        }
    }
    var confirmPasswordPrompt: String {
        if confirmPassword.isEmpty || isConfirmedPasswordValid() {
            return ""
        } else {
            return "Passwords do not match"
        }
    }

    private let apiClient: ResetPasswordFlowApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(apiClient: ResetPasswordFlowApiClintProtocol = ResetPasswordFlowApiClint()) {
        self.apiClient = apiClient
    }
    // MARK: - API Methods
    func resendCode(completion: @escaping () -> Void) async {
   
        viewState = .loading

        let parameters = ["phoneNumber": phone]
        do {
            let response = try await apiClient.resendCode(parameters: parameters)
                if let _ = response.data {
                    viewState = .loaded
                    completion()
                } else {
                    debugPrint("Response received but no user data")
                }
        } catch {
                debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }

    func checkCode(phoneNumber: String, otp: String, completion: @escaping (String) -> Void) async {
        viewState = .loading
        let parameters = ["phoneNumber": phoneNumber, "code": otp]
        do {
            let response = try await apiClient.checkCode(parameters: parameters)
            await MainActor.run {
                if let _ = response.data?.isValid {
                    viewState = .loaded
                    completion(response.data?.resetToken ?? "")
                    debugPrint("Code valid: \(response.data?.resetToken ?? "")")
                } else {
                    debugPrint("Code check returned nil")
                    completion("nil")
                }
            }
        } catch {
            debugPrint("Check code error: \(error.localizedDescription)")
            completion("nil")
        }
    }
    
    func resetPassword(phoneNumber: String, resetToken: String,completion: @escaping () -> Void) async {
        viewState = .loading
        let parameters = [
            "phoneNumber": phoneNumber,
            "newPassword": password,
            "resetToken": resetToken
        ]
        
        do {
            let _ = try await apiClient.resetPassword(parameters: parameters)
            await MainActor.run {
                viewState = .loaded
                    debugPrint("Reset password data:")
                    completion()
            }
        } catch {
            await MainActor.run {
                debugPrint("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - Validation Methods
     func isPhoneValid() -> Bool {
        let pattern = #"^\+20(1[0125][0-9]{8})$"#
        return phone.range(of: pattern, options: .regularExpression) != nil
    }

     func isPasswordValid() -> Bool {
        let pattern = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
        return password.range(of: pattern, options: .regularExpression) != nil
    }

     func isConfirmedPasswordValid() -> Bool {
        return password == confirmPassword && isPasswordValid()
    }
}
