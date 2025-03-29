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

    func request<T: Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
        let request = try endpoint.asURLRequest()
        Logger.info("🌐 Sending API Request: \(request.httpMethod ?? "UNKNOWN") \(request.url?.absoluteString ?? "No URL")")
        do {
            let (data, response) = try await session.data(for: request)
            return try self.manageResponse(data: data, response: response)
        } catch {
            Logger.error("API Request Failed: \(error.localizedDescription)")
            if let apiError = error as? APIResponseError {
                throw apiError // ✅ Only convert if needed
            }
            throw APIResponseError(type: nil,title: nil, status: 10,errors: ["HTTP" : ["Unknown API error \(error.localizedDescription)"]], traceId: nil
            )
        }
    }
    
    
    func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, APIResponseError> {
        do {
            return session
                .dataTaskPublisher(for: try endpoint.asURLRequest())
                .tryMap { output in
                    return try self.manageResponse(data: output.data, response: output.response)
                }
                .mapError {
                    if let apiError = $0 as? APIResponseError {
                        return apiError // ✅ Only convert if needed
                    }
                    return APIResponseError(
                        type: nil,
                        title: "Unknown API error \($0.localizedDescription)",
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
                errors: ["HTTP" : ["Unknown API error \(error.localizedDescription)"]],
                traceId: nil
            )
            return Fail(error: apiError).eraseToAnyPublisher()
        }
    }
}

extension ApiClient {
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> APIResponse<T> {
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.error("Invalid HTTP response")
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP": ["Invalid HTTP response"]], traceId: nil)
        }

        switch httpResponse.statusCode {
        case 200...299:
            let decodedResponse = try self.decoder.decode(APIResponse<T>.self, from: data)
            guard decodedResponse.status == .Success else {
                Logger.warning("API Error: \(decodedResponse.status) - \(decodedResponse.message)")
                throw createAPIError(from: decodedResponse)
            }
            Logger.info("✅ API Call Successful")
            return decodedResponse

        default:
            if let decodedError = try? self.decoder.decode(APIResponseError.self, from: data) {
                Logger.error("API Error Response: \(decodedError)")
                throw decodedError
            }
            Logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP": ["Response out of expected range"]], traceId: nil)
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

//    // Extend APIResponseStatus enum (assuming it exists)
//    private extension APIResponseStatus {
//        var errorKey: String {
//            switch self {
//            case .Error: return "Error"
//            case .AuthFailure: return "AuthFailure"
//            case .Conflict: return "Conflict"
//            default: return "Unknown"
//            }
//        }
//    }
}


