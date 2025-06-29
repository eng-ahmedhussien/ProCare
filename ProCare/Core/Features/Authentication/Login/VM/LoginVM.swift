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
    
    //@Published var phone: String = ""
    @Published var email: String = ""
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
            "email": email,
            "password": password,
            "DeviceToken": KeychainHelper.shared.get(forKey: .deviceToken) ?? "",
        ]
        
        do {
            let response = try await apiClient.login(parameters: parameter)
            viewState = .loaded
            
            completion(response)
            
            if  let userDataLogin = response.data {
                self.userDataLogin = userDataLogin
            } else {
                showToast("Response received but no user data", appearance: .error)
                debugPrint("Response received but no user data")
            }
        } catch let APIError{
            showToast("Unexpected error: \(APIError.localizedDescription)", appearance: .error)
            debugPrint("Unexpected error: \(APIError.localizedDescription)")
        }
    }
    
    
}

enum UserState {
    case userNotConfirmed
    case withToken
}
