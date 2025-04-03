//
//  OTPApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 03/04/2025.
//

import Foundation

protocol OTPApiClintProtocol {
    func confirmCode(parameters: [String: String]) async throws -> APIResponse<UserDataLogin>
    func resendCode(parameters: [String: String]) async throws -> APIResponse<UserDataLogin>
}

class OTPApiClint: ApiClient<OTPEndPoints>, OTPApiClintProtocol {
    func confirmCode(parameters: [String : String]) async throws -> APIResponse<UserDataLogin> {
        return try await request(OTPEndPoints.confirmCode(parameters: parameters))
    }
    func resendCode(parameters: [String : String]) async throws -> APIResponse<UserDataLogin> {
        return try await request(OTPEndPoints.resendCode(parameters: parameters))
    }
}
