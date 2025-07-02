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
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForRequest = 30 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 300 // seconds for whole resource request to complete ,.
        return URLSession(configuration: configuration)
    }
    
    // MARK: - request async
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
        
        var request: URLRequest
       
        
        do {
            request = try endpoint.asURLRequest()
        }catch {
            throw APIResponseError(
                type: nil,
                title: "Failed to build request",
                status: nil,
                errors: ["request": [error.localizedDescription]],
                traceId: nil
            )
        }
        
        var data: Data = Data()
        var response: URLResponse = URLResponse()
        // 🚀🚀🚀 API Request
        NetworkLogger.logRequest(request)
          
        do {
           (data, response) = try await session.data(for: request)
            let apiResponse = try self.handleAPIResponse(data: data, response: response, request: request, responseType: T.self)
                //✅✅✅ API Response
            if let httpResponse = response as? HTTPURLResponse {
                NetworkLogger.logResponse(request: request, response: httpResponse, data: data)
            }
            
            return apiResponse
            
        } catch let error as APIResponseError {
            NetworkLogger.logError(
                request: request,
                response: response as? HTTPURLResponse,
                data: data,
                error: "\(error.title ?? "") : \(error.errors?.values.first?.first ?? "💥 Errors array is  empty 💥" )"
            )
            throw error
            
        }catch let error as URLError {
           // handleURLError(error, request)
            handleURLError(error, request, endpoint: endpoint)
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

}

extension ApiClient {
// MARK: - handleAPIResponse
    private func handleAPIResponse<T: Decodable>(data: Data, response: URLResponse, request: URLRequest, responseType: T.Type) throws -> APIResponse<T> {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIResponseError(type: "HTTPError", title: "Invalid HTTP response", status: 10, errors: ["HTTP": ["Invalid HTTP response type"]], traceId: nil)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedResponse = try self.decoder.decode(APIResponse<T>.self, from: data)
                return decodedResponse // ✅ Return response even if status is not .Success
            } catch {
                throw handleDecodingError(error, for: T.self, data: data)
            }

        case 401:
            let errorMessage = "Error: Unauthorized (\(httpResponse.statusCode)) 🚫🔑"
            throw APIResponseError(type: nil, title: "Error: Unauthorized", status: 401, errors: ["Unauthorized": ["manageResponse func error : \(errorMessage)"]], traceId: nil)
        default:
            if let decodedError = try? self.decoder.decode(APIResponseError.self, from: data) {
                throw decodedError
            }
            let errorMessage = "Unexpected status code: \(httpResponse.statusCode)"
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["decodedError": ["manageResponse func error : \(errorMessage)"]], traceId: nil)
        }
    }
    
// MARK: - handleURLError
    private func handleURLError(_ error: URLError,_ request: URLRequest?, endpoint: EndpointType) {
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
    
    // MARK: - handleDecodingError
    private func handleDecodingError<T>( _ error: Error,for type: T.Type, data: Data) -> APIResponseError {
        var errorMessage = "Decoding failed for type: \(T.self)"
        var errorDetails: [String] = []

        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                errorMessage = "Type mismatch for type \(type)"
                errorDetails.append("\(context.debugDescription) - CodingPath: \(context.codingPath.map(\.stringValue).joined(separator: " → "))")

            case .valueNotFound(let type, let context):
                errorMessage = "Value not found for type \(type)"
                errorDetails.append("\(context.debugDescription) - CodingPath: \(context.codingPath.map(\.stringValue).joined(separator: " → "))")

            case .keyNotFound(let key, let context):
                errorMessage = "Missing key: \(key.stringValue)"
                errorDetails.append("\(context.debugDescription) - CodingPath: \(context.codingPath.map(\.stringValue).joined(separator: " → "))")

            case .dataCorrupted(let context):
                errorMessage = "Data corrupted"
                errorDetails.append("\(context.debugDescription) - CodingPath: \(context.codingPath.map(\.stringValue).joined(separator: " → "))")

            @unknown default:
                errorMessage = "Unknown decoding error"
            }
        } else {
            errorMessage = "Unexpected decoding error: \(error.localizedDescription)"
        }

        return APIResponseError(
            type: "DecodingError",
            title: errorMessage,
            status: 10,
            errors: ["Decoding": errorDetails],
            traceId: nil
        )
    }
}

struct EmptyResponse: Codable {}

extension ApiClient {
    
    func requestWithRetry<T: Codable>( _ endpoint: EndpointType, retries: Int = 3, delay: TimeInterval = 2) async throws -> APIResponse<T> {
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
 // MARK: -  request AnyPublisher
extension ApiClient{
      
        func request<T: Codable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, APIResponseError> {
            do {
                let request = try endpoint.asURLRequest()
                
                // 🔹 Log the request
                NetworkLogger.logRequest(request)
                
                return session
                    .dataTaskPublisher(for: request)
                    .tryMap { output in
                        let apiResponse = try self.handleAPIResponse(data: output.data, response: output.response, request: request, responseType: T.self)
                        
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
