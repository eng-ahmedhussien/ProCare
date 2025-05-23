//
//  OrdersApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 17/05/2025.
//

import Foundation

protocol OrdersApiClintProtocol {
    func getCurrentOrder() async throws -> APIResponse<Order>
    func getPreviousOrders(parameters: [String: Any]) async throws -> APIResponse<OrdersPagination>
    func cancelOrder(id: String) async throws -> APIResponse<Bool>
}

class OrdersApiClint : ApiClient<OrdersEndPoints>, OrdersApiClintProtocol {
    
    func getCurrentOrder() async throws -> APIResponse<Order> {
        return try await request(.getCurrentOrder)
    }
    
    func getPreviousOrders(parameters: [String: Any]) async throws -> APIResponse<OrdersPagination> {
        return try await request(.getPreviousOrders(parameters: parameters))
    }
    
    func cancelOrder(id: String) async throws -> APIResponse<Bool> {
        return try await request(.cancelOrder(id: id))
    }
}
