    //
    //  ReviewEndPoints.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 14/07/2025.
    //

import Foundation

enum ReviewEndPoints : APIEndpoint {
    case getLastRequestIdNotReviewed
    case AddReview(parameters: [String: Any])
    case cancelReviewByRequestId(requestId: String)
    
    var path: String {
        switch self {
        case .getLastRequestIdNotReviewed:
            return "/Review/GetLastRequestIdNotReviewed"
        case .AddReview:
            return "Review/AddReview"
        case .cancelReviewByRequestId(let requestId):
            return "/Review/CancelReviewByRequestId/\(requestId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLastRequestIdNotReviewed:
            return .get
        case .AddReview:
            return .post
        case .cancelReviewByRequestId:
            return .delete
        }
    }
    
    
    var headers: HTTPHeader? {
        return .authHeader
    }
    
    var task: Parameters {
        switch self {
        case .AddReview(let parameters):
            return .requestParameters(parameters: parameters,encoding: .JSONEncoding())
        default:
            return .requestNoParameters
            
        }
    }
}
