//
//  NursesEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import Foundation

enum NurseEndPoints : APIEndpoint {
    
    case GetAllNurses(parameters: [String : String])
    
    var path: String {
        switch self {
        case .GetAllNurses:
            return "/Nurse/GetAllMobileNurses"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .GetAllNurses:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .GetAllNurses(let parameters):
            return parameters
        }
    }
}
