//
//  LoginApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation


protocol LoginApiClintProtocol {
    func login(parameters: [String: String]) async throws -> APIResponse<UserDataLogin>
}

class LoginApiClint: ApiClient<LoginEndPoints>, LoginApiClintProtocol {
    func login(parameters: [String : String]) async throws -> APIResponse<UserDataLogin> {
        return try await request(LoginEndPoints.login(parameters: parameters))
    }
}
