//
//  ProfileEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import Foundation
import UIKit

enum ProfileEndPoints : APIEndpoint {
    case getProfile
    case deleteProfile
    //case updateProfile(parameters: [String: Any])
    case updateProfile(params: [String: Any], image: UIImage? = nil )
    
    //MARK: location
    case getGovernorates
    case getCityByGovernorateId(id: Int)
    
    var path: String {
        switch self {
        case .getProfile:
            return "/Profile/GetPatientProfile"
        case .deleteProfile:
            return "/Profile/DeleteAccount"
        case .updateProfile:
            return "/Profile/UpdatePatientProfile"
        case .getGovernorates:
            return "/Governorate/GetMobileGovernorates"
        case .getCityByGovernorateId(let id):
            return "/City/GetCityByGovernorateId/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile, .getGovernorates, .getCityByGovernorateId:
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
    
    var task: Parameters {
        switch self {
        case .getProfile, .deleteProfile, .getGovernorates, .getCityByGovernorateId:
            return .requestNoParameters
        case .updateProfile(let params, let image):
                    if let img = image {
                        return .requestWithMultipart(parameters: params, multipartParamters: .single(key: "Image", image: img))
                    } else {
                        return .requestWithMultipart(parameters: params, multipartParamters: .dictionary([:])) // No image
                            
                    }
        }
    }

}
