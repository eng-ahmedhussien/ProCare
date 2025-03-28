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
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
        let request = try endpoint.asURLRequest()
        do {
            let (data, response) = try await session.data(for: request)
            return try self.manageResponse(data: data, response: response)
        } catch let error as APIResponseError { // 3
            throw error
        } catch {
            throw  APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP" : ["Unknown API error\(error.localizedDescription)"]], traceId: nil)
        }
    }
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, APIResponseError> {
        do {
            return session
                .dataTaskPublisher(for: try endpoint.asURLRequest())
                .tryMap { output in
                    return try self.manageResponse(data: output.data, response: output.response)
                }
                .mapError {
                    $0 as? APIResponseError ?? APIResponseError(type: nil, title: "Unknown API error \($0.localizedDescription)", status: 4, errors: nil, traceId: nil)
                }
                .eraseToAnyPublisher()
        } catch let error as APIResponseError { // 6
            return AnyPublisher<APIResponse<T>, APIResponseError>(Fail(error: error))
        } catch {
            return AnyPublisher<APIResponse<T>, APIResponseError>(Fail(error: APIResponseError(type: nil, title: nil, status: 10, errors: ["HTTP" : ["Unknown API error\(error.localizedDescription)"]], traceId: nil)))
        }
    }
    
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> APIResponse<T> {
            guard let response = response as? HTTPURLResponse else {
                debugPrint("❌ Invalid HTTP response")
                throw APIResponseError(type: nil, title: nil, status:10 , errors: ["HTTP" : ["Invalid HTTP response"]], traceId: nil)
            }
            switch response.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                    switch decodedResponse.status {
                    case .Success:
                        return decodedResponse
                    case .Error:
                        debugPrint("❌ validation Error form backend")
                        throw APIResponseError(type: nil, title: nil, status:decodedResponse.subStatus , errors: ["Error" : [decodedResponse.message]], traceId: nil)
                        
                    case .AuthFailure:
                        debugPrint("❌ AuthFailure")
                        throw APIResponseError(type: nil, title: nil, status:decodedResponse.subStatus , errors: ["AuthFailure" : [decodedResponse.message]], traceId: nil)
                    case .Conflict:
                        debugPrint("❌ Conflict")
                        throw APIResponseError(type: nil, title: nil, status:decodedResponse.subStatus , errors: ["Conflict" : [decodedResponse.message]], traceId: nil)
                    }
                    
                } catch let error as APIResponseError{
                    debugPrint("❌ can not decoding error")
                    throw error
                }
            default:
                guard let decodedError = try? JSONDecoder().decode(APIResponseError.self, from: data) else {
                    debugPrint("❌ out  200...299 range")
                    
                    throw APIResponseError(type: nil, title: nil, status:10 , errors: ["decode" : [" out  200...299 range"]], traceId: nil)
                }
                throw decodedError
            }
        }
}


//protocol APIClientProtocol {
//    associatedtype EndpointType: APIEndpoint
//    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, Error>
//    func request<T: Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T>
//}
//

//class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClientProtocol {
//    private let decoder: JSONDecoder
//    
//    init(decoder: JSONDecoder = JSONDecoder()) {
//        self.decoder = decoder
//    }
//    
//
//    
//    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
//        let request = try endpoint.asURLRequest()
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            let validData = try self.validateResponse(data: data, response: response)
//
//            let decodedResponse = try decoder.decode(APIResponse<T>.self, from: validData)
//            
//            switch decodedResponse.status {
//            case .Success:
//                return decodedResponse
//            case .Error:
//                throw APIError.custom(statusCode: decodedResponse.subStatus, message: decodedResponse.message)
//            case .AuthFailure:
//                throw APIError.custom(statusCode: decodedResponse.subStatus, message: decodedResponse.message)
//            case .Conflict:
//                throw APIError.custom(statusCode: decodedResponse.subStatus, message: decodedResponse.message)
//            }
//            
//        } catch let error as APIError {
//            throw error
//        } catch {
//            throw APIError.decodingError
//        }
//    }
//    
//    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<APIResponse<T>, Error> {
//        let request =  endpoint.asURLRequestPublisher()
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .tryMap { data, response -> Data in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    throw APIError.requestFailed
//                }
//                
//                if (200...299).contains(httpResponse.statusCode) {
//                    return data
//                } else {
//                    throw self.decodeAPIError(from: data, statusCode: httpResponse.statusCode)
//                }
//            }
//            .decode(type: APIResponse<T>.self, decoder: decoder)
//            .eraseToAnyPublisher()
//    }
//    
//}
//
//// MARK: - Shared Validation
//extension URLSessionAPIClient{
//    private func validateResponse(data: Data?, response: URLResponse?) throws -> Data {
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw APIError.requestFailed
//        }
//
//        guard let data = data, !data.isEmpty else {
//            throw APIError.invalidData
//        }
//
//        if (200...299).contains(httpResponse.statusCode) {
//            return data
//        } else {
//            do {
//                let apiError = try JSONDecoder().decode(APIResponseError.self, from: data)
//                var message = ""
//
//                // ✅ Extract validation errors if present
//                if let errorDetails = apiError.errors {
//                    let allErrors = errorDetails.flatMap { $0.value }.joined(separator: "\n")
//                    message += "\n\(allErrors)"
//                }
//                
//                
//                    throw APIError.custom(statusCode: httpResponse.statusCode, message: message)
//            
//
//            } catch let decodingError as DecodingError {
//                // 🔍 Debugging logs for better visibility
//                print("❌ Decoding Failed: \(decodingError.localizedDescription)")
//
//                throw APIError.custom(
//                    statusCode: httpResponse.statusCode,
//                    message: "Unable to decode error response"
//                )
//            }
//        }
//    }
//    private func decodeAPIError(from data: Data, statusCode: Int) -> APIError {
//        do {
//            let apiError = try JSONDecoder().decode(APIResponseError.self, from: data)
//            let message: String = apiError.errors?
//                .flatMap { $0.value }
//                .joined(separator: "\n") ?? "Unknown error occurred."
//
//            return APIError.custom(statusCode: statusCode, message: message)
//        } catch {
//            print("❌ Decoding Failed: \(error.localizedDescription)")
//            return APIError.custom(statusCode: statusCode, message: "Unable to decode error response")
//        }
//    }
//}
//   
////    
////    // MARK: - Error Handling
////    private func mapError(_ error: Error) -> APIError {
////        switch error {
////        case let apiError as APIError:
////            return apiError
////        case is DecodingError:
////            return .decodingFailed
////        case let urlError as URLError:
////            return urlError.code == .notConnectedToInternet ? .requestFailed : .unknown
////        default:
////            return .unknown
////        }
////    }
////
//
//
////    func request<T:Codable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
////        let request = try endpoint.asURLRequest()
////        let (data, response) =  try await URLSession.shared.data(for:request)
////        let validData =  try self.validateResponse(data: data, response: response)
////       // return try decoder.decode(T.self, from: validData)
////        return try decoder.decode(APIResponse<T>.self, from: validData)
////    }
//
//
////MARK: using validateResponse func
////    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> APIResponse<T> {
////
////        let request =  try endpoint.asURLRequest()
////
////        do {
////            let (data, response) = try await URLSession.shared.data(for: request)
////            let validData = try self.validateResponse(data: data, response: response)
////            return try decoder.decode(APIResponse<T>.self, from: validData)
////        } catch let error as APIError {
////            throw error
////        } catch {
////            throw APIError.decodingError
////        }
////    }
//
//
