//
//  HomeApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Combine

protocol HomeApiClintProtocol {
    func categories() async throws -> APIResponse<[Category]>
}

class HomeApiClint: ApiClient<HomeEndPoints>, HomeApiClintProtocol {
    func categories() async throws -> APIResponse<[Category]> {
        return try await request(HomeEndPoints.categories)
    }
}
