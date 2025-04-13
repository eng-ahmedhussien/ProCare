//
//  LoginEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation


enum LoginEndPoints : APIEndpoint {
    
    case login(parameters: [String: String])
    
    var baseURL: URL {
        return URL(string: "http://procare.runasp.net/api/Auth")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/Login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
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
        case .login(let parameters):
            return parameters
        }
    }
}
