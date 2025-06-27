//
//  ResetPasswordFlowVM.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import Foundation
import Combine

@MainActor
class PasswordFlowVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var viewState: ViewState = .idle
    //MARK: - otp Properties
    @Published var userDataLogin : UserDataLogin?
    @Published var errorMessage: APIResponseError?
    
    // MARK: - Validation Prompts
    var phonePrompt: String {
        if email.isEmpty || isEmailValid() {
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

    private let apiClient: PasswordFlowApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(apiClient: PasswordFlowApiClintProtocol = PasswordFlowApiClint()) {
        self.apiClient = apiClient
    }
    // MARK: - API Methods
    func resendCode(completion: @escaping () -> Void) async {
   
        viewState = .loading

        let parameters = ["email": email]
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

    func checkCode(email: String, otp: String, completion: @escaping (String) -> Void) async {
        viewState = .loading
        let parameters = ["email": email, "code": otp]
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
    private func isEmailValid() -> Bool {
        let pattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func isPasswordValid() -> Bool {
        let pattern = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
        return password.range(of: pattern, options: .regularExpression) != nil
    }

    private func isConfirmedPasswordValid() -> Bool {
        return password == confirmPassword && isPasswordValid()
    }
}

extension PasswordFlowVM{
    func forgetPassword(completion: @escaping () -> Void) async {
        viewState = .loading

        let parameters = ["email": email]
        
        do {
            let response = try await apiClient.forgetPassword(parameters: parameters)
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
}

extension PasswordFlowVM{
    func confirmCode(parameter: [String : String], completion: @escaping () -> Void) async {
        viewState = .loading
        do {
            let response = try await apiClient.confirmCode(parameters: parameter)
            if response.status == .Success, let userDataLogin = response.data {
                viewState = .loaded
                self.userDataLogin = userDataLogin
                if let _ = userDataLogin.token {
                    completion()
                }
            }
        } catch let APIError{
            await MainActor.run {
                self.errorMessage = APIError as? APIResponseError
            }
        }
    }
    
    func resendCode(parameter: [String : String]) async {
        viewState = .loading
        do {
            let _ = try await apiClient.resendCode(parameters: parameter)
            viewState = .loaded
        } catch let APIError{
            await MainActor.run {
                self.errorMessage = APIError as? APIResponseError
            }
        }
    }
}
