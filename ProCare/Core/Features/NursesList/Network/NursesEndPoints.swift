//
//  NursesEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import Foundation

enum NurseEndPoints : APIEndpoint {
    
    case getAllNurses(parameters: [String : String])
    
    var path: String {
        switch self {
        case .getAllNurses:
            return "/Nurse/GetAllMobileNurses"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllNurses:
            return .post
        }
    }
    
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
    var task: Parameters {
        switch self {
        case .getAllNurses(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        }
    }
}
