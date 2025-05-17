//
//  OrderEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 15/05/2025.
//

import Foundation

enum OrdersEndPoints: APIEndpoint {
    
    case getCurrentRequest
    case getPreviousRequests(parameters: [String: Any])
    
    var path: String {
        switch self {
        case .getCurrentRequest:
            return "/Request/GetCurrentRequest"
        case .getPreviousRequests:
            return "/Request/GetPreviousRequests"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentRequest:
            return .get
        case .getPreviousRequests:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        return .authHeader
    }
    
    var task: Parameters {
        switch self {
        case .getPreviousRequests(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        default:
            return .requestNoParameters
        }
    }
}
