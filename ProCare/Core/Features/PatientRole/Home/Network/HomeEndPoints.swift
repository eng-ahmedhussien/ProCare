//
//  HomeEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Foundation

enum HomeEndPoints{
    
    case categories
    case subCategories(id : Int)
  
    case services(parameters: [String: Any], subCategoryId: Int)
    case visitService
    
    case reservation(parameters: [String: Any])
    
    case getAllNurses(parameters: [String : Any])
    
    case submitRequest(Parameters: [String:Any])
    case getRequestById(requestId: String)
}

extension HomeEndPoints: APIEndpoint {

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
        case .reservation:
            return "/Reservation/Reserve"
        case .getAllNurses:
            return "/Nurse/GetAllMobileNurses"
        case .submitRequest:
            return "/Request/Submit"
        case .getRequestById(let requestId):
            return "/Request/GetById/\(requestId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories, .subCategories, .visitService, .getRequestById:
            return .get
        case .services, .reservation, .getAllNurses, .submitRequest:
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
        case .reservation(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .getAllNurses(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .submitRequest(let Parameters):
            return .requestParameters(parameters: Parameters, encoding: .JSONEncoding())
        default:
            return .requestNoParameters
        }
     
    }
    
}

