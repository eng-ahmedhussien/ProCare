//
//  OTPEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 03/04/2025.
//

import Foundation

enum OTPEndPoints : APIEndpoint {
    
    case confirmCode(parameters: [String: String])
    case resendCode(parameters: [String: String])
    
    
    var path: String {
        switch self {
        case .confirmCode:
            return "/Auth/ConfirmCode"
        case .resendCode:
            return "/Auth/ResendCode"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .confirmCode, .resendCode:
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
        case .confirmCode(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .resendCode(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        }
    }
}
