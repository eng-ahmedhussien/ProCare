//
//  RequestEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import Foundation

enum RequestEndPoints : APIEndpoint {
    
    case submitRequest(Parameters: [String:Any])
    
    var path: String {
        switch self {
        case .submitRequest:
            return "/Request/Submit"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .submitRequest:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
    var task: Parameters {
        switch self {
        case .submitRequest(let Parameters):
            return .requestParameters(parameters: Parameters, encoding: .JSONEncoding())
        }
    }
}
