//
//  ResetPasswordFlowApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import Foundation

protocol ResetPasswordFlowApiClintProtocol {
    func resendCode(parameters: [String: String]) async throws -> APIResponse<String>
    func checkCode(parameters: [String: String]) async throws -> APIResponse<Bool>
    func resetPassword(parameters: [String: String]) async throws -> APIResponse<String>
}

class ResetPasswordFlowApiClint: ApiClient<ResetPasswordFlowEndPoints>, ResetPasswordFlowApiClintProtocol {
    func resendCode(parameters: [String : String]) async throws -> APIResponse<String> {
        return try await request(.resendCode(parameters: parameters))
    }
    
    func checkCode(parameters: [String : String]) async throws -> APIResponse<Bool> {
        return try await request(ResetPasswordFlowEndPoints.checkCode(parameters: parameters))
    }
    
    func resetPassword(parameters: [String : String]) async throws -> APIResponse<String> {
        return try await request(ResetPasswordFlowEndPoints.resetPassword(parameters: parameters))
    }
}
