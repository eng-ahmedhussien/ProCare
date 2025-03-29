//
//  APIClient.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI
import Combine


protocol ApiProtocol {
    associatedtype EndpointType: APIEndpoint
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T>
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, APIResponseError>
}

class ApiClient<EndpointType: APIEndpoint>: ApiProtocol {
    
    private let decoder: JSONDecoder
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 300 // seconds for whole resource request to complete ,.
        return URLSession(configuration: configuration)
    }

    // MARK: - request async
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
        let request = try endpoint.asURLRequest()
        // 🔹 Log the request
        NetworkLogger.logRequest(request)
        do {
            let (data, response) = try await session.data(for: request)
            // 🔹 Process and log response
            let apiResponse = try self.manageResponse(data: data, response: response, request: request, responseType: T.self)
            NetworkLogger.logResponse(request: request, response: response as! HTTPURLResponse, data: data)
            return apiResponse
        } catch {
            
           // NetworkLogger.logError(request: request, response: nil, data: nil, error: error.localizedDescription)
            
            if let urlError = error as? URLError {
                throw APIResponseError(
                    type: "Network Error",
                    title: "Failed to reach server",
                    status: urlError.errorCode,
                    errors: ["Network": [urlError.localizedDescription]],
                    traceId: nil
                )
            }
            if let apiError = error as? APIResponseError {
                throw apiError
            }
            
            throw APIResponseError(
                type: nil,
                title: nil,
                status: 10,
                errors: ["HTTP": ["Unknown API error \(error.localizedDescription)"]],
                traceId: nil
            )
        }
    }


    // MARK: -  request AnyPublisher
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, APIResponseError> {
        do {
            let request = try endpoint.asURLRequest()
            
            // 🔹 Log the request
            NetworkLogger.logRequest(request)
            
            return session
                .dataTaskPublisher(for: request)
                .tryMap { output in
                    let apiResponse = try self.manageResponse(data: output.data, response: output.response, request: request, responseType: T.self)

                    if let httpResponse = output.response as? HTTPURLResponse {
                        NetworkLogger.logResponse(request: request, response: httpResponse, data: output.data)
                    }
                    
                    return apiResponse
                }
                .mapError { error in
                    NetworkLogger.logError(request: request, response: nil, data: nil, error: error.localizedDescription)
                    
                    if let apiError = error as? APIResponseError {
                        return apiError
                    }
                    
                    return APIResponseError(
                        type: nil,
                        title: "Unknown API error \(error.localizedDescription)",
                        status: 4,
                        errors: nil,
                        traceId: nil
                    )
                }
                .eraseToAnyPublisher()
        } catch {
            let apiError = error as? APIResponseError ?? APIResponseError(
                type: nil,
                title: nil,
                status: 10,
                errors: ["HTTP": ["Unknown API error \(error.localizedDescription)"]],
                traceId: nil
            )
            
            NetworkLogger.logError(request: nil, response: nil, data: nil, error: apiError.localizedDescription)
            
            return Fail(error: apiError).eraseToAnyPublisher()
        }
    }
}


// MARK: - manageResponse
extension ApiClient {
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse, request: URLRequest, responseType: T.Type) throws -> APIResponse<T> {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            let errorMessage = "Invalid HTTP response"
            NetworkLogger.logError(request: request, response: nil, data: nil, error: errorMessage)
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP": [errorMessage]], traceId: nil)
        }

        switch httpResponse.statusCode {
        case 200...299:
            let decodedResponse = try self.decoder.decode(APIResponse<T>.self, from: data)
            guard decodedResponse.status == .Success else {
                let errorMessage = "API Error: \(decodedResponse.status) - \(decodedResponse.message)"
                NetworkLogger.logError(request: request, response: httpResponse, data: data, error: errorMessage)
                throw createAPIError(from: decodedResponse)
            }
            return decodedResponse

        default:
            if let decodedError = try? self.decoder.decode(APIResponseError.self, from: data) {
                NetworkLogger.logError(request: request, response: httpResponse, data: data, error: "API Error Response")
                throw decodedError
            }
            let errorMessage = "Unexpected status code: \(httpResponse.statusCode)"
            NetworkLogger.logError(request: request, response: httpResponse, data: data, error: errorMessage)
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP": ["Unexpected response"]], traceId: nil)
        }
    }

    // Helper function to create APIResponseError
    private func createAPIError<T>(from response: APIResponse<T>) -> APIResponseError {
        return APIResponseError(
            type: nil,
            title: nil,
            status: response.subStatus,
            errors: [response.status.rawValue.description: [response.message]],
            traceId: nil
        )
    }

}


