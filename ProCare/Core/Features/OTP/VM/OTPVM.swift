//
//  OTPVM.swift
//  ProCare
//
//  Created by ahmed hussien on 03/04/2025.
//

import Foundation
import Combine

class OTPVM : ObservableObject{

    @Published var userDataLogin : UserDataLogin?
    private let apiClient:  OTPApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    @Published var errorMessage: APIResponseError?

    
    init(apiClient: OTPApiClintProtocol = OTPApiClint()) {
        self.apiClient = apiClient
    }
    
    func confirmCode(parameter: [String : String]) async {

        do {
            let response = try await apiClient.confirmCode(parameters: parameter)
            
            await MainActor.run {
                if response.status == .Success, let userDataLogin = response.data {
                    self.userDataLogin = userDataLogin
                    if let token = userDataLogin.token {
                        AuthManger.shared.saveToken(token)
                    }
                } else {
                }
            }
        } catch let APIError{
            await MainActor.run {
                self.errorMessage = APIError as? APIResponseError
            }
        }
    }
    
    func resendCode(parameter: [String : String]) async {

        do {
             try await apiClient.resendCode(parameters: parameter)
        } catch let APIError{
            await MainActor.run {
                //self.errorMessage = APIError as? APIResponseError
            }
        }
    }
    
    
}
