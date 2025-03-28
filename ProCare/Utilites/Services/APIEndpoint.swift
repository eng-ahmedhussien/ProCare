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
    func asURLRequest() throws -> URLRequest {

//        var urlComponents = URLComponents()
//        urlComponents.host =  baseURL.absoluteString
//        urlComponents.path = path
////        if let queryItems = queryItems {
////            urlComponents.queryItems = queryItems
////        }
//        guard let url = urlComponents.url else {
//            debugPrint("❌ URL error")
//            throw APIResponseError(type: nil, title: nil, status:10 , errors: ["URL" : ["URL error"]], traceId: nil)
//        }

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
                debugPrint("❌ Error encoding http body")
                throw APIResponseError(type: nil, title: nil, status:10 , errors: ["parameters" : ["Error encoding http body"]], traceId: nil)
            }
        }

        return request
    }
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
