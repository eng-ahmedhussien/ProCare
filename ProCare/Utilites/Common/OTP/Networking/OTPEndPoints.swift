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
    
    var baseURL: URL {
        return URL(string: "http://procare.runasp.net/api/Auth")!
    }
    
    var path: String {
        switch self {
        case .confirmCode:
            return "/ConfirmCode"
        case .resendCode:
            return "/ResendCode"
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
    
    var parameters: [String: String]? {
        switch self {
        case .confirmCode(let parameters):
            return parameters
        case .resendCode(let parameters):
            return parameters
        }
    }
}
