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
    private let apiClient: LoginApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []

    
    init(apiClient: LoginApiClintProtocol = LoginApiClint()) {
        self.apiClient = apiClient
    }

    func login() async {
        
        let parameter = [
            "phoneNumber": phone,
            "password": password
        ]
        
        do {
            let response = try await apiClient.login(parameters: parameter)
            
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
                //self.errorMessage = APIError as? APIResponseError
            }
        }
    }
    
    
}
