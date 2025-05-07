//
//  ServiceEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//

import Foundation

enum ServiceEndPoints: APIEndpoint {
    case services(parameters: [String: Any], subCategoryId: Int)

    var path: String {
        switch self {
        case .services:
            return "/ServiceCatalog/GetMobileServices"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var headers: HTTPHeader? {
        return .authHeader
    }

    var task: Parameters {
        switch self {
        case .services(let parameters, let id):
                   return .requestWithQueryAndBody(
                       query: ["subCategoryId": id],
                       body: parameters,
                       encoding: .JSONEncoding(.default)
                   )
        }
        
    }
}

