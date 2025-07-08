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
    @Published var oldPassword: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var viewState: ViewState = .idle
    //MARK: - otp Properties
    @Published var userDataLogin : UserDataLogin?
    @Published var errorMessage: APIResponseError?
    
    private let apiClient: PasswordFlowApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(apiClient: PasswordFlowApiClintProtocol = PasswordFlowApiClint()) {
        self.apiClient = apiClient
    }
    // MARK: - API Methods
    
    private func handleApiResponse<T: Codable>(_ response: APIResponse<T>, onSuccess: @escaping () -> Void) {
        switch response.status {
        case .Success:
                // Only show success toast if there's a meaningful message
            if let message = response.message, !message.isEmpty {
                showToast(message, appearance: .success)
            }
            onSuccess()
        case .Error, .AuthFailure, .Conflict:
            showToast(
                response.message ?? "خطأ في الشبكة",
                appearance: .error
            )
        case .none:
                // Handle unknown status
            showToast("حدث خطأ غير متوقع", appearance: .error)
        }
    }
}

//MARK: - forgetPassword flow
extension PasswordFlowVM{
        /// call  in
        /// forget password flow to send OTP
        /// { "status": 0, "message": "تم إرسال رمز OTP بنجاح!",  "internalMessage": null,   "data": null,  "subStatus": 0  }
        ///
    func forgetPassword(completion: @escaping () -> Void) async {
        viewState = .loading
        let parameters = ["email": email]
        do {
            let response = try await apiClient.forgetPassword(parameters: parameters)
            viewState = .loaded
            handleApiResponse(response,onSuccess:completion)
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
        /// called after OTP send in forget password flow
        /// {"status": 0, "message": "رمز التحقق صحيح!", "data": {"isValid": true,"resetToken": "86019cb8-0b88-48e1-95f6-63741372c7a1"} }
    func checkCode(email: String, otp: String, completion: @escaping (String) -> Void) async {
        viewState = .loading
        
        let parameters = ["email": email, "code": otp]
        
        do {
            let response = try await apiClient.checkCode(parameters: parameters)
            viewState = .loaded
            
            handleApiResponse(response) {
                // This closure runs only on success
                guard let data = response.data else {
                    debugPrint("Unable to parse response data")
                    return
                }
                
                if data.isValid == true {
                    completion(data.resetToken ?? "")
                } else {
                    // Invalid OTP - show specific error
                    showToast("رمز التحقق خطأ", appearance: .error)
                }
            }
            
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
        /// call  after checkCode api don
        /// { "status": 0, "message": "تم إعادة تعيين كلمة المرور بنجاح!","data": null,}
    func resetPassword(email: String, resetToken: String,completion: @escaping () -> Void) async {
        viewState = .loading
        
        let parameters = [
            "email": email,
            "newPassword": password,
            "resetToken": resetToken
        ]
        
        do {
            let response = try await apiClient.resetPassword(parameters: parameters)
            await MainActor.run {
                viewState = .loaded
                handleApiResponse(response,onSuccess:completion)
            }
        } catch {
                debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}

extension PasswordFlowVM{
    /// call after get OTP in
    ///  sign up
    ///  confirm account
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
    
        /// call in
        ///  resend code button
        ///  when login if account not confirm account
        ///{"status": 0,"message": "تم إرسال رمز OTP بنجاح!", "data": "5381",}
        ///
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

extension PasswordFlowVM{
    func changePassword(completion: @escaping () -> Void) async {
        let parameters: [String:Any] = [
          "oldPassword": oldPassword,
          "newPassword": password
        ]
        
        do {
            let response = try await apiClient.changePassword(parameters: parameters)
            handleApiResponse(response,onSuccess:completion)
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}
