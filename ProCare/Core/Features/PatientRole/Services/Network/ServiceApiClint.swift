//
//  HomeApiClintProtocol.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//


protocol ServiceApiClintProtocol {
    func GetServices(parameters: [String: String], id: Int) async throws -> APIResponse<ServiceData>
}

class ServiceApiClint: ApiClient<ServiceEndPoints>, ServiceApiClintProtocol {
    func GetServices(parameters: [String: String] ,id: Int) async throws -> APIResponse<ServiceData> {
        return try await request(ServiceEndPoints.services(parameters: parameters, subCategoryId: id))
    }
}
