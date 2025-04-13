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
    
    var baseURL: URL {
        return URL(string: "http://procare.runasp.net/api/Auth")!
    }
    
    var path: String {
        switch self {
        case .resendCode:
            return "/ResendCode"
        case .checkCode:
            return "/CheckCode"
        case .resetPassword:
            return "/ResetPassword"
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
