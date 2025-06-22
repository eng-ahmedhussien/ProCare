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
    @Published var viewState: ViewState = .idle
    

    private let apiClient: LoginApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: LoginApiClintProtocol = LoginApiClint()) {
        self.apiClient = apiClient
    }

    func login(completion: @escaping (APIResponse<UserDataLogin>) -> Void) async {
        
        viewState = .loading
        
        let parameter = [
            "Email": phone,
            "password": password,
            "DeviceToken": KeychainHelper.shared.get(forKey: .deviceToken) ?? "",
        ]
        
        do {
            let response = try await apiClient.login(parameters: parameter)
            viewState = .loaded
            
            completion(response)
            
            if  let userDataLogin = response.data {
                self.userDataLogin = userDataLogin
                
//                switch userDataLogin.loginStatus {
//                case .Success:
//                    if userDataLogin.token != nil {
//                        completion(.withToken)
//                    }
//                case .InValidCredintials:
//                    debugPrint("InValidCredintials")
//                case .UserLockedOut:
//                    debugPrint("UserLockedOut")
//                case .UserNotConfirmed:
//                    showToast(response.message ?? "" , appearance: .error)
//                    completion(.userNotConfirmed)
//                case .Error:
//                    debugPrint("Error")
//                case .none:
//                    debugPrint("none")
//                }
                
            } else {
                showToast("Response received but no user data", appearance: .error, position: .top)
                debugPrint("Response received but no user data")
            }
        } catch let APIError{
            await MainActor.run {
                showToast("Unexpected error: \(APIError.localizedDescription)", appearance: .error, position: .top)
                debugPrint("Unexpected error: \(APIError.localizedDescription)")
            }
        }
    }
    
    
}

enum UserState {
    case userNotConfirmed
    case withToken
}
