//
//  LoginVM.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation
import Combine

@MainActor
class LoginVM: ObservableObject {
    
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var userDataLogin : UserDataLogin?
    @Published var goToOTP = false
    private let apiClient: LoginApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []

    
    init(apiClient: LoginApiClintProtocol = LoginApiClint()) {
        self.apiClient = apiClient
    }

    func login(completion: @escaping () -> Void) async {
        
        let parameter = [
            "phoneNumber": phone,
            "password": password
        ]
        
        do {
            let response = try await apiClient.login(parameters: parameter)
            
            await MainActor.run {
                if  let userDataLogin = response.data {
                    self.userDataLogin = userDataLogin
                    
                    switch userDataLogin.loginStatus {
                    case .Success:
                        if let token = userDataLogin.token {
                            AuthManger.shared.saveToken(token)
                        }
                    case .InValidCredintials:
                        debugPrint("InValidCredintials")
                    case .UserLockedOut:
                        debugPrint("UserLockedOut")
                    case .UserNotConfirmed:
                        completion()
                    case .Error:
                        debugPrint("Error")
                    case .none:
                        debugPrint("none")
                    }
                    
                } else {
                    debugPrint("Response received but no user data")
                }
            }
        } catch let APIError{
            await MainActor.run {
                debugPrint("Unexpected error: \(APIError.localizedDescription)")
            }
        }
    }
    
    
}
