//
//  OTPVM.swift
//  ProCare
//
//  Created by ahmed hussien on 03/04/2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class OTPVM : ObservableObject{
    @Published var userDataLogin : UserDataLogin?
    @Published var errorMessage: APIResponseError?
    @Published var viewState: ViewState = .idle

    private let apiClient:  OTPApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: OTPApiClintProtocol = OTPApiClint()) {
        self.apiClient = apiClient
    }
    
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
