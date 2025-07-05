import Foundation

enum PharmacyEndpoints {
    case getPharmacies(parameters: [String: Any])
}

extension PharmacyEndpoints: APIEndpoint {
    var path: String {
        switch self {
        case .getPharmacies:
            return "/Pharmacy/Mobile/GetAll"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPharmacies:
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
        case .getPharmacies(parameters: let parameters):
                return .requestParameters(parameters: parameters, encoding: .JSONEncoding(.default))
        }
     
    }
    
}

