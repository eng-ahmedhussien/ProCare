//
//  SignUpVM.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import SwiftUI
import Combine

@MainActor
final class SignUpVM: ObservableObject {

    @Published var name: String = ""
    @Published var secondName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var viewState: ViewState = .idle
    
    private let apiClient: SignUpApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: SignUpApiClintProtocol = SignUpApiClint()) {
        self.apiClient = apiClient
    }

    
    func signUp(completion: @escaping (APIResponse<String>) -> Void) async {
        viewState = .loading
        let parameter = [
            "firstName": name,
            "lastName": secondName,
            "email": email,
            "phoneNumber": phone,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        do {
            let response = try await apiClient.signUp(parameters: parameter)
            viewState = .loaded
            completion(response)
        } catch let APIError{
            viewState = .loaded
           debugPrint("Error in signUp no response : \(APIError)")
        }
    }
}
