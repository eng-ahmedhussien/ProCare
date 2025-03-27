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
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension APIEndpoint {
    func asURLRequest() throws -> URLRequest {

        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.values.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw APIError.invalidData
            }
        }

        return request
    }
    
    func asURLRequestPublisher() -> URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.values.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                print(" ❌ Error encoding parameters in asURLRequestPublisher method: \(error)")
            }
        }

        return request
        
    }
}


enum APIError: Error {
    case requestFailed
    case invalidResponse
    case invalidData
    case decodingError
    case custom(statusCode: Int, message: String)
}

enum HTTPHeader {
    case custom([String: String])
    case `default`
    case `empty`

    var values: [String: String] {
        switch self {
        case .custom(let headers):
            return HTTPHeader.defaultValues.merging(headers) { (_, new) in new }
        case .default:
            return HTTPHeader.defaultValues
        case .empty:
            return [:]

        }
    }
    
    private static var defaultValues: [String: String] {
           return [
               "accept": "*/*",
               "Content-Type": "application/json"
           ]
       }
}
