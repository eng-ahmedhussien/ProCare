//
//  ResetPasswordFlowApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import Foundation

protocol PasswordFlowApiClintProtocol {
    func resendCode(parameters: [String: String]) async throws -> APIResponse<String>
    func checkCode(parameters: [String: String]) async throws -> APIResponse<checkCodeModel>
    func resetPassword(parameters: [String: String]) async throws -> APIResponse<String>
    func forgetPassword(parameters: [String: String]) async throws -> APIResponse<String> // send code
    func confirmCode(parameters: [String: String]) async throws -> APIResponse<UserDataLogin> // after sign up
    func changePassword( parameters: [String:Any]) async throws -> APIResponse<EmptyData>
    
}

class PasswordFlowApiClint: ApiClient<PasswordFlowEndPoints>, PasswordFlowApiClintProtocol {
    func resendCode(parameters: [String : String]) async throws -> APIResponse<String> {
        return try await request(.resendCode(parameters: parameters))
    }
    
    func checkCode(parameters: [String : String]) async throws -> APIResponse<checkCodeModel> {
        return try await request(PasswordFlowEndPoints.checkCode(parameters: parameters))
    }
    
    func resetPassword(parameters: [String : String]) async throws -> APIResponse<String> {
        return try await request(PasswordFlowEndPoints.resetPassword(parameters: parameters))
    }
    
    func forgetPassword(parameters: [String: String]) async throws -> APIResponse<String>{
        return try await request(PasswordFlowEndPoints.forgetPassword(parameters: parameters))
    }
    
    func confirmCode(parameters: [String : String]) async throws -> APIResponse<UserDataLogin> {
        return try await request(PasswordFlowEndPoints.confirmCode(parameters: parameters))
    }
    
    func changePassword( parameters: [String:Any]) async throws -> APIResponse<EmptyData> {
        return try await request(PasswordFlowEndPoints.changePassword(parameters: parameters))
    }
}
