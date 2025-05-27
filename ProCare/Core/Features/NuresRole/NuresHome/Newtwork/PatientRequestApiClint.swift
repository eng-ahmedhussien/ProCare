//
//  PatientRequestApiClintProtocol.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import Foundation

protocol PatientRequestApiClintProtocol {
    func getCurrentRequest() async throws -> APIResponse<Request>
    func getPreviousRequests(parameters: [String: Any]) async throws -> APIResponse<RequestsPagination>
    func cancelRequest(id: String) async throws -> APIResponse<Bool>
    func approveRequest(id: String) async throws -> APIResponse<Bool>
    //MARK: - Reports
    func getReportByPatientId(id: String) async throws -> APIResponse<Report>
    func addOrUpdateReport(parameters: [String: Any]) async throws -> APIResponse<Int>
    func getDeceases(parameters: [String: Any]) async throws -> APIResponse<PagedDisease>
    func getServices(parameters: [String: Any]) async throws -> APIResponse<ServiceData>
}

class PatientRequestApiClint : ApiClient<PatientRequestEndPoints>, PatientRequestApiClintProtocol {
    
    func getCurrentRequest() async throws -> APIResponse<Request> {
        return try await request(.getCurrentRequest)
    }
    
    func getPreviousRequests(parameters: [String: Any]) async throws -> APIResponse<RequestsPagination> {
        return try await request(.getPreviousRequests(parameters: parameters))
    }
    
    func cancelRequest(id: String) async throws -> APIResponse<Bool> {
        return try await request(.cancelRequest(id: id))
    }
    
    func approveRequest(id: String) async throws -> APIResponse<Bool> {
        return try await request(.approveRequest(id: id))
    }
     //MARK: - Reports
    func getReportByPatientId(id: String) async throws -> APIResponse<Report> {
        return try await request(.getReportByPatientId(id: id))
    }

    func addOrUpdateReport(parameters: [String: Any]) async throws -> APIResponse<Int> {
            return try await request(.addOrUpdateReport(parameters: parameters))
    }
    func getDeceases(parameters: [String: Any]) async throws -> APIResponse<PagedDisease> {
        return try await request(.getDeceases(parameters: parameters))
    }
    func getServices(parameters: [String: Any]) async throws -> APIResponse<ServiceData> {
        return try await request(.getServices(parameters: parameters))
    }
}
