//
//  HomeApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Combine

protocol HomeApiClintProtocol {
    func categories() async throws -> APIResponse<[Category]>
    func subCategories(id: Int) async throws -> APIResponse<[NursingServices]>
    //MARK:  - Services
    func getServices(parameters: [String: String], id: Int) async throws -> APIResponse<ServiceData>
    func getVisitService() async throws -> APIResponse<ServiceItem>
    

}

class HomeApiClint: ApiClient<HomeEndPoints>, HomeApiClintProtocol {
    func categories() async throws -> APIResponse<[Category]> {
        return try await request(HomeEndPoints.categories)
    }
    func subCategories(id: Int) async throws -> APIResponse<[NursingServices]> {
        return try await request(HomeEndPoints.subCategories(id: id))
    }
    //MARK:  - Services
    func getServices(parameters: [String: String] ,id: Int) async throws -> APIResponse<ServiceData> {
        return try await request(HomeEndPoints.services(parameters: parameters, subCategoryId: id))
    }
    func getVisitService() async throws -> APIResponse<ServiceItem>{
        return try await request(HomeEndPoints.visitService)
    }

}
