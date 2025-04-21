//
//  APIEndpoint.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI
import Combine



protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeader? { get }
    var parameters: [String: String]? { get }
   // var queryItems: [URLQueryItem]? { get }
    //var mockFile: String? { get }
}


extension APIEndpoint {
    var baseURL: URL  { URL(string: "http://procare.runasp.net/api")! }
    var parameters: [String: String]? { nil }
    func asURLRequest() throws -> URLRequest {
       /// let url = baseURL.appendingPathComponent(path)
        
        // Ensure the baseURL is valid
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            let errorMessage = "URL error: Invalid baseURL"
            NetworkLogger.logError(request: nil, response: nil, data: nil, error: errorMessage)
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["URL": [errorMessage]], traceId: nil)
        }
        
        // Append path correctly
        urlComponents.path += path
        
        // Append query parameters if available
//        if let queryItems = queryItems {
//            urlComponents.queryItems = queryItems
//        }
        
        // Validate the final URL
        guard let finalURL = urlComponents.url else {
            let errorMessage = "URL error: Failed to construct URL"
            NetworkLogger.logError(request: nil, response: nil, data: nil, error: errorMessage)
            throw APIResponseError(type: nil, title: nil, status: 10, errors: ["URL": [errorMessage]], traceId: nil)
        }

        // Create request
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        // Set headers
        headers?.values.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Set HTTP body if parameters exist
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {

                let errorMessage = "Error encoding HTTP body: \(error.localizedDescription)"
                NetworkLogger.logError(request: request, response: nil, data: nil, error: errorMessage)
                throw APIResponseError(type: nil, title: nil, status: 10, errors: ["parameters": [errorMessage]], traceId: nil)
            }
        }
        

        return request
    }
}


enum HTTPHeader {
    case custom([String: String])
    case `default`
    case `empty`
    case  authHeader

    var values: [String: String] {
        switch self {
        case .custom(let headers):
            return HTTPHeader.defaultValues.merging(headers) { (_, new) in new }
        case .default:
            return HTTPHeader.defaultValues
        case .empty:
            return [:]
        case .authHeader:
            return HTTPHeader.bearer

        }
    }
    
    private static var defaultValues: [String: String] {
        return [
            "accept": "ar-EG",
            "Content-Type": "application/json"
        ]
    }
    
    private static var bearer: [String: String] {
        guard let token = UserDefaults.standard.string(forKey: "auth_token")  else { return [:] }
        return [
            "accept": "*/*",
            "Authorization": "Bearer \(token)"
        ]
    }
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


enum APIError: Error {
    case requestFailed
    case invalidResponse
    case invalidData
    case decodingError
    case custom(statusCode: Int, message: String)
}


extension Encodable {

    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
