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
        
        var request: URLRequest?
        var data: Data?
        var response: URLResponse?
        
        do {
            request = try endpoint.asURLRequest()
            
            if let request = request {
                // 🚀🚀🚀 API Request
                NetworkLogger.logRequest(request)
                
                (data, response) = try await session.data(for: request)
                
                guard let data = data, let response = response else {
                    throw APIResponseError(
                        type: nil,
                        title: "No response or data",
                        status: nil,
                        errors: ["network": ["No data or response received"]],
                        traceId: nil
                    )
                }
                
                let apiResponse = try self.manageResponse(data: data, response: response, request: request, responseType: T.self)
                //✅✅✅ API Response
                if let httpResponse = response as? HTTPURLResponse {
                    NetworkLogger.logResponse(request: request, response: httpResponse, data: data)
                }
                
                return apiResponse
                
            }else {
                throw APIResponseError(
                    type: nil,
                    title: "Invalid request",
                    status: nil,
                    errors: ["request": ["Request could not be created"]],
                    traceId: nil
                )
            }
            
        } catch let error as APIResponseError {
            NetworkLogger.logError(
                request: request,
                response: response as? HTTPURLResponse,
                data: data,
                error: error.errors?.values.first?.first ?? " 💥 Errors array is  empty 💥"
            )
            throw error
            
        }catch let error as URLError {
            handleURLError(error, request)
            throw error // optional: rethrow if you want to pass it up
            
        } catch {
            NetworkLogger.logError(
                request: request,
                response: response as? HTTPURLResponse,
                data: data,
                error: " 💥 Unknown error: \(error.localizedDescription) 💥"
            )
            throw error
            
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

extension ApiClient {
    // MARK: - manageResponse
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse, request: URLRequest, responseType: T.Type) throws -> APIResponse<T> {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            let errorMessage = "Invalid HTTP response"
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP": [errorMessage]], traceId: nil)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decodedResponse = try self.decoder.decode(APIResponse<T>.self, from: data)
            return decodedResponse // ✅ Return response even if status is not .Success
        case 401:
            let errorMessage = "Error: Unauthorized: \(httpResponse.statusCode)"
            throw APIResponseError(type: nil, title: nil, status: 401, errors: ["Unauthorized": ["manageResponse func error : \(errorMessage)"]], traceId: nil)
        default:
            if let decodedError = try? self.decoder.decode(APIResponseError.self, from: data) {
                throw decodedError
            }
            let errorMessage = "Unexpected status code: \(httpResponse.statusCode)"
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["decodedError": ["manageResponse func error : \(errorMessage)"]], traceId: nil)
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
    
    // MARK: - handleURLError
    private func handleURLError(_ error: URLError,_ request: URLRequest?) {
         switch error.code {
         case .notConnectedToInternet:
             NetworkLogger.logError( request: request, error: "🔌 No internet connection")
             // Show offline alert, fallback to cache, etc.
             
         case .timedOut:
             NetworkLogger.logError( request: request, error: "⏱ Request timed out")
             // Retry or prompt user
             
         case .networkConnectionLost:
             NetworkLogger.logError( request: request, error: "📡 Connection lost during request")
             // Retry or notify user
             
         case .cannotFindHost, .cannotConnectToHost:
             NetworkLogger.logError( request: request, error: "❌ Cannot connect to server")
             // Inform user or log
             
         case .dnsLookupFailed:
             NetworkLogger.logError( request: request, error: "🌐 DNS lookup failed")
             // May indicate network issues
         default:
             NetworkLogger.logError( request: request, error: "⚠️ URLError: \(error.code.rawValue) - \(error.localizedDescription)")
         }
     }
}

extension ApiClient {
    
    func requestWithRetry<T: Codable>(
        _ endpoint: EndpointType,
        retries: Int = 3,
        delay: TimeInterval = 2
    ) async throws -> APIResponse<T> {
        var currentAttempt = 0
        
        while currentAttempt <= retries {
            do {
                return try await request(endpoint)
            } catch let error as URLError {
                currentAttempt += 1
                
                // Only retry for specific URLError codes
                switch error.code {
                case .timedOut, .networkConnectionLost, .notConnectedToInternet:
                    if currentAttempt > retries {
                        throw error
                    }
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                default:
                    throw error
                }
            } catch {
                throw error
            }
        }
        
        throw APIResponseError(
            type: nil,
            title: "Maximum retries reached",
            status: nil,
            errors: ["Retry": ["Exceeded maximum retry attempts"]],
            traceId: nil
        )
    }
}

