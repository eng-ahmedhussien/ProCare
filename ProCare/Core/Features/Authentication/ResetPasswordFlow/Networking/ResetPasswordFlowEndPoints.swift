//
//  ResetPasswordFlowEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import Foundation

enum ResetPasswordFlowEndPoints : APIEndpoint {
    case resendCode(parameters: [String: String])
    case checkCode(parameters: [String: String])
    case resetPassword(parameters: [String: String])

    var path: String {
        switch self {
        case .resendCode:
            return "/Auth/ResendCode"
        case .checkCode:
            return "/Auth/CheckCode"
        case .resetPassword:
            return "/Auth/ResetPassword"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .resendCode, .checkCode, .resetPassword:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.default
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .resendCode(let parameters):
            return parameters
        case .checkCode(let parameters):
            return parameters
        case .resetPassword(let parameters):
            return parameters
        }
    }
}
