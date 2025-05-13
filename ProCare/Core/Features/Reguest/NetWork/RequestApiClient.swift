//
//  RequestApiClient.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import Foundation

protocol RequestApiClientProtocol {
    func submitRequest(Parameters: [String : Any]) async throws -> APIResponse<String>
}

class RequestApiClient : ApiClient<RequestEndPoints>, RequestApiClientProtocol {
    func submitRequest(Parameters: [String : Any]) async throws -> APIResponse<String>{
        return try await request(RequestEndPoints.submitRequest(Parameters: Parameters))
    }
}
