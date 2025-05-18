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
    case cancelRequest(id: String)
    
    var path: String {
        switch self {
        case .getCurrentRequest:
            return "/Request/GetCurrentRequest"
        case .getPreviousRequests:
            return "/Request/GetPreviousRequests"
        case .cancelRequest(let id):
            return "/Request/Cancel/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentRequest:
            return .get
        case .getPreviousRequests:
            return .post
        case .cancelRequest:
            return  .put
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
