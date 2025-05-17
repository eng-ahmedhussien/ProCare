//
//  OrdersApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 17/05/2025.
//

import Foundation

protocol OrdersApiClintProtocol {
    func getCurrentRequest() async throws -> APIResponse<Order>
    func getPreviousRequests(parameters: [String: Any]) async throws -> APIResponse<OrdersPagination>
}

class OrdersApiClint : ApiClient<OrdersEndPoints>, OrdersApiClintProtocol {
    
    func getCurrentRequest() async throws -> APIResponse<Order> {
        return try await request(.getCurrentRequest)
    }
    
    func getPreviousRequests(parameters: [String: Any]) async throws -> APIResponse<OrdersPagination> {
        return try await request(.getPreviousRequests(parameters: parameters))
    }
}
