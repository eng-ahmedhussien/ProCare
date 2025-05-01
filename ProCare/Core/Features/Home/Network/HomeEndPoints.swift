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
    case Services(parameters: [String: String], id : Int)
    
    var path: String {
        switch self {
        case .categories:
            return "/ServiceCategory/GetMobileCategories"
        case .subCategories(let id):
            return "/SubCategory/GetMobileSubCategories/\(id)"
        case .Services( _ ,_):
            return "/ServiceCatalog/GetMobileServices"
     
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories, .subCategories:
            return .get
        case .Services:
            return .post
        }
    }
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .Services(_ , let id):
            return [ URLQueryItem(name: "subCategoryId", value: "\(id)")]
        case .categories:
            return nil
        case .subCategories:
            return nil
        }
        
    }
    
    var parameters: [String : String]? {
        switch self {
        case .Services(let parameters, _):
            return parameters
        case .categories:
            return nil
        case .subCategories(id: _):
            return nil
        }
    }
    
}

