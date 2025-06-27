//
//  ResetPasswordFlowEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 10/04/2025.
//

import Foundation

enum PasswordFlowEndPoints : APIEndpoint {
    case resendCode(parameters: [String: String])
    case checkCode(parameters: [String: String])
    case resetPassword(parameters: [String: String])
    case confirmCode(parameters: [String: String])
    case forgetPassword(parameters: [String: String])

    var path: String {
        switch self {
        case .resendCode:
            return "/Auth/ResendCode"
        case .checkCode:
            return "/Auth/CheckCode"
        case .resetPassword:
            return "/Auth/ResetPassword"
        case .forgetPassword:
            return "/Auth/ForgetPassword" // send otp code
        case .confirmCode:
            return "/Auth/ConfirmCode"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .resendCode, .checkCode, .resetPassword, .forgetPassword, .confirmCode:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.default
        }
    }
    
    var task: Parameters {
        switch self {
        case .resendCode(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .checkCode(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .resetPassword(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .forgetPassword(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .confirmCode(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        }
    }
}
