//MARK: - NuresEndPoints
//  NuresEndPoinds.swift
//  ProCare
//
//  Created by ahmed hussien on 30/05/2025.
//

import Foundation

enum NuresProfileEndPoints : APIEndpoint {
    case updateLocation(parameters: [String: Any])
    case changeStatus(isBusy: Bool)
    case getNurseProfile
    
    var path: String {
        switch self {
        case .updateLocation:
            return "/Nurse/UpdateLocation"
        case .changeStatus:
            return "Nurse/changeStatus"
        case .getNurseProfile:
            return "Profile/GetNurseProfile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateLocation, .changeStatus:
            return .put
        case .getNurseProfile:
            return .get
        }
    }
    
    
    var headers: HTTPHeader? {
        return .authHeader
    }
    
    var task: Parameters {
        switch self {
        case .updateLocation(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())

        case .changeStatus(let isBusy):
            return .requestParameters(parameters: ["isBusy": isBusy], encoding: .URLEncoding(.queryString))
        default:
            return .requestNoParameters
            
        }
    }
}


