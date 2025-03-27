//
//  SignUpEndpoints.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import Foundation

//enum  SignUpEndpoints : APIEndpoint{
//    
//    case signUp(parameters: [String: Any])
//    
//    var baseURL: URL {
//        return URL(string: "https://procare.runasp.net/api/")!
//    }
//    
//    var path: String {
//        switch self {
//        case .signUp:
//            return "Auth/register"
//        }
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .signUp:
//            return .post
//        }
//    }
//    
//    var headers: HTTPHeader? {
//        get {
//            return HTTPHeader.default
//        }
//    }
//    
//    var parameters: [String : Any]? {
//        switch self {
//        case .signUp(let parameters):
//            return parameters
//        }
//    }
//}


enum SignUpEndpoints: APIEndpoint {
   
    
    case signUp(parameters: [String: String]?)
    
    var baseURL: URL {
        return URL(string: "http://procare.runasp.net/api/Auth")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
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
        case .signUp(let parameters):
            return parameters
        }
    }
}
