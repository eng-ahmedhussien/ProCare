//
//  HomeEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Foundation

enum HomeEndPoints: APIEndpoint {

    case categories
    
    var path: String {
        switch self {
        case .categories:
            return "/ServiceCategory/GetMobileCategories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories:
            return .get
        }
    }
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
}

