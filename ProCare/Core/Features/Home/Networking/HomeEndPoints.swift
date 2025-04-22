//
//  HomeEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Foundation

enum HomeEndPoints: APIEndpoint {

    case categories
    case subCategories(id : Int)
    
    var path: String {
        switch self {
        case .categories:
            return "/ServiceCategory/GetMobileCategories"
        case .subCategories(let id):
            return "/SubCategory/GetMobileSubCategories/\(id)"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories, .subCategories:
            return .get
        }
    }
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
}

