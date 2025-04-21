//
//  SignUpApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import Combine


protocol SignUpApiClintProtocol {
    func signUp(parameters: [String: String]) async throws -> APIResponse<String>
    func signUp(parameters: [String: String])-> AnyPublisher<APIResponse<String>, APIResponseError>
}

class SignUpApiClint: ApiClient<SignUpEndpoints>, SignUpApiClintProtocol {

    func signUp(parameters: [String: String]) async throws -> APIResponse<String>{
        return try await request(SignUpEndpoints.signUp(parameters: parameters)) 
    }
    
    func signUp(parameters: [String: String])-> AnyPublisher<APIResponse<String>, APIResponseError>{
        return request(SignUpEndpoints.signUp(parameters: parameters))
    }
}


