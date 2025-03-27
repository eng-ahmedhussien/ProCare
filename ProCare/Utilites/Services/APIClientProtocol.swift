//
//  APIClient.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI
import Combine

protocol APIClientProtocol {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, Error>
    func request<T: Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClientProtocol {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    

    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
        let request = try endpoint.asURLRequest()

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let validData = try self.validateResponse(data: data, response: response)

            let decodedResponse = try decoder.decode(APIResponse<T>.self, from: validData)
            
            switch decodedResponse.status {
            case .Success:
                return decodedResponse
            case .Error:
                throw APIError.custom(statusCode: decodedResponse.subStatus, message: decodedResponse.message)
            case .AuthFailure:
                throw APIError.custom(statusCode: decodedResponse.subStatus, message: decodedResponse.message)
            case .Conflict:
                throw APIError.custom(statusCode: decodedResponse.subStatus, message: decodedResponse.message)
            }
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.decodingError
        }
    }
    
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, Error> {
        let request =  endpoint.asURLRequestPublisher()
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.requestFailed
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw self.decodeAPIError(from: data, statusCode: httpResponse.statusCode)
                }
            }
            .decode(type: APIResponse<T>.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Shared Validation
extension URLSessionAPIClient{
    private func validateResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed
        }

        guard let data = data, !data.isEmpty else {
            throw APIError.invalidData
        }

        if (200...299).contains(httpResponse.statusCode) {
            return data
        } else {
            do {
                let apiError = try JSONDecoder().decode(APIResponseError.self, from: data)
                var message = ""

                // ✅ Extract validation errors if present
                if let errorDetails = apiError.errors {
                    let allErrors = errorDetails.flatMap { $0.value }.joined(separator: "\n")
                    message += "\n\(allErrors)"
                }
                
                
                    throw APIError.custom(statusCode: httpResponse.statusCode, message: message)
            

            } catch let decodingError as DecodingError {
                // 🔍 Debugging logs for better visibility
                print("❌ Decoding Failed: \(decodingError.localizedDescription)")

                throw APIError.custom(
                    statusCode: httpResponse.statusCode,
                    message: "Unable to decode error response"
                )
            }
        }
    }
    private func decodeAPIError(from data: Data, statusCode: Int) -> APIError {
        do {
            let apiError = try JSONDecoder().decode(APIResponseError.self, from: data)
            let message: String = apiError.errors?
                .flatMap { $0.value }
                .joined(separator: "\n") ?? "Unknown error occurred."

            return APIError.custom(statusCode: statusCode, message: message)
        } catch {
            print("❌ Decoding Failed: \(error.localizedDescription)")
            return APIError.custom(statusCode: statusCode, message: "Unable to decode error response")
        }
    }
}
   
//    
//    // MARK: - Error Handling
//    private func mapError(_ error: Error) -> APIError {
//        switch error {
//        case let apiError as APIError:
//            return apiError
//        case is DecodingError:
//            return .decodingFailed
//        case let urlError as URLError:
//            return urlError.code == .notConnectedToInternet ? .requestFailed : .unknown
//        default:
//            return .unknown
//        }
//    }
//


//    func request<T:Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
//        let request = try endpoint.asURLRequest()
//        let (data, response) =  try await URLSession.shared.data(for:request)
//        let validData =  try self.validateResponse(data: data, response: response)
//       // return try decoder.decode(T.self, from: validData)
//        return try decoder.decode(APIResponse<T>.self, from: validData)
//    }


//MARK: using validateResponse func
//    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
//
//        let request =  try endpoint.asURLRequest()
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            let validData = try self.validateResponse(data: data, response: response)
//            return try decoder.decode(APIResponse<T>.self, from: validData)
//        } catch let error as APIError {
//            throw error
//        } catch {
//            throw APIError.decodingError
//        }
//    }


