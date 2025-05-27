//
//  PatientRequestEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import Foundation

enum PatientRequestEndPoints: APIEndpoint {
    
    case getCurrentRequest
    case getPreviousRequests(parameters: [String: Any])
    case cancelRequest(id: String)
    case approveRequest(id: String)
    //MARK: - Reports
    case getReportByPatientId(id: String)
    case addOrUpdateReport(parameters: [String: Any])
    case getDeceases(parameters: [String: Any])
    case getServices(parameters: [String: Any])
    
    var path: String {
        switch self {
        case .getCurrentRequest:
            return "/Request/GetCurrentRequest"
        case .getPreviousRequests:
            return "/Request/GetPreviousRequests"
        case .cancelRequest(let id):
            return "/Request/Cancel/\(id)"
        case .approveRequest(let id):
            return "/Request/Approve/\(id)"
            //MARK: - Reports
        case .getReportByPatientId(let id):
            return "/Report/GetReportByPatientId/\(id)"
        case .addOrUpdateReport:
            return "/Report/AddOrUpdateReport"
        case .getDeceases:
            return "Disease/GetAllMobileDiseases"
        case .getServices:
            return "ServiceCatalog/GetMobileServices"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCurrentRequest, .getReportByPatientId:
            return .get
        case .getPreviousRequests, .addOrUpdateReport, .getDeceases, .getServices:
            return .post
        case .cancelRequest, .approveRequest:
            return  .put
        }
    }
    
    var headers: HTTPHeader? {
        return .authHeader
    }
    
    var task: Parameters {
        switch self {
        case .getPreviousRequests(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .addOrUpdateReport(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .getDeceases(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
       case .getServices(let parameters):
            return .requestWithQueryAndBody(
                query: ["subCategoryId": -1],
                body: parameters,
                encoding: .JSONEncoding(.default)
            )
        default:
            return .requestNoParameters
       
        }
    }
}
