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
    
    //MARK: - services
    case services(parameters: [String: Any], subCategoryId: Int)
    case visitService
    
    var path: String {
        switch self {
        case .categories:
            return "/ServiceCategory/GetMobileCategories"
        case .subCategories(let id):
            return "/SubCategory/GetMobileSubCategories/\(id)"
        case .services:
            return "/ServiceCatalog/GetMobileServices"
        case .visitService:
            return "/ServiceCatalog/GetVisitService"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories, .subCategories, .visitService:
            return .get
        case .services:
            return  .post
        }
    }
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
    var task: Parameters {
        switch self {
        case .services(let parameters, let id):
                   return .requestWithQueryAndBody(
                       query: ["subCategoryId": id],
                       body: parameters,
                       encoding: .JSONEncoding(.default)
                   )
        default:
            return .requestNoParameters
        }
     
    }
    
}

