//
//  PatientRequestEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import Foundation

enum PatientRequestEndPoints: APIEndpoint {
    
    case getCurrentRequest
    case getPreviousRequests(parameters: [String: Any])
    case cancelRequest(id: String)
    case approveRequest(id: String)
    
    var path: String {
        switch self {
        case .getCurrentRequest:
            return "/Request/GetCurrentRequest"
        case .getPreviousRequests:
            return "/Request/GetPreviousRequests"
        case .cancelRequest(let id):
            return "/Request/Cancel/\(id)"
        case .approveRequest(let id):
            return "/Request/Approve/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentRequest:
            return .get
        case .getPreviousRequests:
            return .post
        case .cancelRequest, .approveRequest:
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
