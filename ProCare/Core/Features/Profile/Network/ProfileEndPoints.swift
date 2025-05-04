//
//  ProfileEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import Foundation

enum ProfileEndPoints : APIEndpoint {
    case getProfile
    case deleteProfile
    case updateProfile(parameters: [String: Any])
    
    var path: String {
        switch self {
        case .getProfile:
            return "/Profile/GetPatientProfile"
        case .deleteProfile:
            return "/Profile/DeleteAccount"
        case .updateProfile:
            return "/Profile/UpdatePatientProfile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .deleteProfile:
            return .delete
        case .updateProfile:
            return .put
        }
    }
    
    
    var headers: HTTPHeader? {
        get {
            return HTTPHeader.authHeader
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getProfile, .deleteProfile:
            return nil
        case .updateProfile(let parameters):
            return parameters
        }
    }
}
