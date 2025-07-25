//
//  SignUpEndpoints.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import Foundation
import SwiftUI

enum SignUpEndpoints: APIEndpoint {
    case signUp(parameters: [String: String])
    
    var path: String {
        switch self {
        case .signUp:
            return "/Auth/register"
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
    
    var task: Parameters {
        switch self {
        case .signUp(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        }
    }
    
}

