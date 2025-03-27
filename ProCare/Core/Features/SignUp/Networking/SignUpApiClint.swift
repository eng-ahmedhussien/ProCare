//
//  SignUpApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import Combine


protocol SignUpApiClintProtocol {
    func signUp(parameters: [String: String]?) async throws -> APIResponse<String>
    func signUp(parameters: [String: String]?)-> AnyPublisher<APIResponse<String>, Error>
}

class SignUpApiClint: URLSessionAPIClient<SignUpEndpoints>, SignUpApiClintProtocol {

    func signUp(parameters: [String: String]?) async throws -> APIResponse<String>{
        try await request(.signUp(parameters: parameters))
    }
    
    func signUp(parameters: [String: String]?)-> AnyPublisher<APIResponse<String>, Error>{
        return request(.signUp(parameters: parameters))
    }

}
