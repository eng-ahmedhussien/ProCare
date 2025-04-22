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
}

class HomeApiClint: ApiClient<HomeEndPoints>, HomeApiClintProtocol {
    func categories() async throws -> APIResponse<[Category]> {
        return try await request(HomeEndPoints.categories)
    }
    func subCategories(id: Int) async throws -> APIResponse<[NursingServices]> {
        return try await request(HomeEndPoints.subCategories(id: id))
    }
}
