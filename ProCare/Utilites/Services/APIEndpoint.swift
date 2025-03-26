//
//  APIEndpoint.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI


protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: Parameters? { get }
}

extension APIEndpoint {
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
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
    case invalidResponse
    case invalidData
    case invalidURL
    case requestFailed
    case custom(statusCode: Int)
    case decodingFailed
    case unknown
}

enum Parameters {
    case requestNoParameters
    
//    case requestParameters(parameters: [String: Any], encoding: APIEncoding)
//    
//    case requestWithMultipart(parameters: [String: Any], multipartParamters: MultipartType)
}
