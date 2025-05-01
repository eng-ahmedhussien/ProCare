//
//  ServiceEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//

import Foundation

enum ServiceEndPoints: APIEndpoint {

    case Services(parameters: [String: String], id : Int)
    
    var path: String {
        switch self {
        case .Services( _ ,_):
            return "/ServiceCatalog/GetMobileServices"
     
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
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
        }
        
    }
    
    var parameters: [String : String]? {
        switch self {
        case .Services(let parameters, _):
            return parameters
        }
    }
    
}

