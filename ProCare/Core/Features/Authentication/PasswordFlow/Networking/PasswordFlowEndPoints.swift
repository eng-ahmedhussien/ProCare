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
    case changePassword(parameters: [String:Any])

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
        case .changePassword:
            return "/Auth/ChangePassword"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .resendCode, .checkCode, .resetPassword, .forgetPassword, .confirmCode,
                .changePassword:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        switch self {
        case .changePassword:
            return HTTPHeader.authHeader
        default:
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
      case .changePassword(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        }
    }
}
