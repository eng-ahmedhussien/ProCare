//
//  OrderEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 15/05/2025.
//

import Foundation

enum OrdersEndPoints: APIEndpoint {
    
    case getCurrentOrder
    case getPreviousOrders(parameters: [String: Any])
    case cancelOrder(id: String)
    
    var path: String {
        switch self {
        case .getCurrentOrder:
            return "/Request/GetCurrentRequest"
        case .getPreviousOrders:
            return "/Request/GetPreviousRequests"
        case .cancelOrder(let id):
            return "/Request/Cancel/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentOrder:
            return .get
        case .getPreviousOrders:
            return .post
        case .cancelOrder:
            return  .put
        }
    }
    
    var headers: HTTPHeader? {
        return .authHeader
    }
    
    var task: Parameters {
        switch self {
        case .getPreviousOrders(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        default:
            return .requestNoParameters
       
        }
    }
}
