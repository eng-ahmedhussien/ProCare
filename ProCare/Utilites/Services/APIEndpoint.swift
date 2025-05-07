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
    var task: Parameters { get }
}


extension APIEndpoint {
    var baseURL: URL {
        guard let url = URL(string: "http://procare.runasp.net/api") else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var task: Parameters { .requestNoParameters }
    
    var headers: HTTPHeader? { HTTPHeader.default }
    
    func asURLRequest() throws -> URLRequest {
        var baseRequestURL = baseURL
        baseRequestURL.appendPathComponent(path)

        guard var urlComponents = URLComponents(url: baseRequestURL, resolvingAgainstBaseURL: false) else {
            throw APIResponseError(type: nil, title: "Invalid URL", status: 10, errors: ["URL": ["Cannot create components"]], traceId: nil)
        }

        var request = URLRequest(url: baseRequestURL)
        request.httpMethod = method.rawValue

        // Set headers
        headers?.values.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Handle task
        switch task {
        case .requestNoParameters:
            break

        case .requestParameters(let parameters, let encoding):
            try encodeRequest(&request, parameters: parameters, encoding: encoding)

        case .requestWithMultipart(let parameters, let multipartType):
            try encodeMultipartRequest(&request, parameters: parameters, multipart: multipartType)

        case .requestWithQueryAndBody(let query, let body, let encoding):
            // Append query items to URL
            urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            if let updatedURL = urlComponents.url {
                request.url = updatedURL
            }

            // Encode body
            try encodeRequest(&request, parameters: body, encoding: encoding)
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
        guard let  token : String = AppUserDefaults.shared.get(forKey: .authToken) else { return [:] }
        return [
            "accept": "*/*",
            "Authorization": "Bearer \(token)",
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

enum Parameters {
    case requestNoParameters
    case requestParameters(parameters: [String: Any], encoding: APIEncoding)
    case requestWithMultipart(parameters: [String: Any], multipartParamters: MultipartType)
    case requestWithQueryAndBody(query: [String: Any], body: [String: Any], encoding: APIEncoding) // ✅ NEW
}


enum APIEncoding {
    case URLEncoding(_ type: URLEncodingTypes = .default)
    case JSONEncoding(_ type: JSONEncodingTypes = .default)
    
    public enum URLEncodingTypes {
        case `default`
        case httpBody
        case queryString
        case custom(destination: Destination, arrayEncoding: ArrayEncoding, boolEncoding: BoolEncoding)
        
        public enum Destination {
            case httpBody
            case queryString
            case methodDependent
        }
        
        public enum ArrayEncoding {
            case brackets
            case indexInBrackets
            case noBrackets
        }
        
        public enum BoolEncoding {
            case literal
            case numeric
        }
    }
    
    public enum JSONEncodingTypes {
        case `default`
        case prettyPrinted
        case custom(options: JSONSerialization.WritingOptions)
    }
}

enum MultipartType {
    case single(key: String, image: UIImage)
    case array(key: String, array: [UIImage], startingIndex: Int = 0)
    case dictionary([String: UIImage])
}

private func encodeRequest(_ request: inout URLRequest, parameters: [String: Any], encoding: APIEncoding) throws {
    switch encoding {
    case .URLEncoding(let type):
        switch type {
        case .httpBody:
            let query = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            request.httpBody = query.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
        case .queryString:
            if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = urlComponents.url
            }

        default:
            // Default to methodDependent
            if request.httpMethod == "GET" {
                if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
                    urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                    request.url = urlComponents.url
                }
            } else {
                let query = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                request.httpBody = query.data(using: .utf8)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }

    case .JSONEncoding(let type):
        let options: JSONSerialization.WritingOptions
        switch type {
        case .prettyPrinted:
            options = .prettyPrinted
        case .custom(let customOptions):
            options = customOptions
        default:
            options = []
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: options)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

private func encodeMultipartRequest(_ request: inout URLRequest, parameters: [String: Any], multipart: MultipartType) throws {
    let boundary = "Boundary-\(UUID().uuidString)"
    var body = Data()

    // Append normal parameters
    for (key, value) in parameters {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }

    // Append images
    switch multipart {
    case .single(let key, let image):
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

    case .array(let key, let array, let startingIndex):
        for (index, image) in array.enumerated() {
            let fieldName = "\(key)[\(index + startingIndex)]"
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"image\(index).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

    case .dictionary(let imagesDict):
        for (key, image) in imagesDict {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
    }

    body.append("--\(boundary)--\r\n".data(using: .utf8)!)

    request.httpBody = body
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
}

// MARK: Multipart
extension Parameters {
    public func returnMultipartParameters() -> ([String: Any], [String: UIImage]?) {
        switch self {
        case .requestWithMultipart(let parameters, let multipartParamters):
            
            switch multipartParamters {
            case .single(let key, let image):
                return (parameters, [key: image])
            
            case .array(let key, let array, let startingIndex):
                var dictionary: [String: UIImage] = [:]
                
                for (index, element) in array.enumerated() {
                    dictionary[key + "[\(index + startingIndex)]"] = element
                }
                
                return (parameters, dictionary)
                
            case .dictionary(let dictionary):
                return (parameters, dictionary)
            }
            
        default:
            return ([:], nil)
        }
    }
}

extension Encodable {

    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
