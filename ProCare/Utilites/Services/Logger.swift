//
//  Logger.swift
//  ProCare
//
//  Created by ahmed hussien on 29/03/2025.
//


import os
import Foundation

struct Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.yourapp.network"

    static func log(_ message: String, type: OSLogType = .debug, category: String = "Network") {
#if DEBUG
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("%{public}@", log: log, type: type, message)
#endif
    }

    static func error(_ message: String, category: String = "Network") {
        log("❌ \(message)", type: .error, category: category)
    }

    static func warning(_ message: String, category: String = "Network") {
        log("⚠️ \(message)", type: .fault, category: category)
    }

    static func info(_ message: String, category: String = "Network") {
        log("ℹ️ \(message)", type: .info, category: category)
    }
    
    
   
}


struct NetworkLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.yourapp.network"
    
    static func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "No URL"
        let headers = formatHeaders(request.allHTTPHeaderFields)
        let body = formatBody(request.httpBody, headers: request.allHTTPHeaderFields)
        
        let message = """
        ⚡️⚡️⚡️⚡️⚡️ ⬆️ Request Started ⬆️ ⚡️⚡️⚡️⚡️⚡️
        [Method]: \(method)
        [URL]: \(url)
        \(headers.indentingNewlines())
        \(body.indentingNewlines())
        ⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️
        """
        log(message)
    }

    static func logResponse(_ response: HTTPURLResponse, data: Data?) {
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "No URL"
        let headers = formatHeaders(response.allHeaderFields as? [String: String])
        let body = formatBody(data, headers: response.allHeaderFields as? [String: String])

        let message = """
        ⚡️⚡️⚡️⚡️⚡️ ⬇️ Response Received ⬇️ ⚡️⚡️⚡️⚡️⚡️
        [Status]: \(statusCode)
        [URL]: \(url)
        \(headers.indentingNewlines())
        \(body.indentingNewlines())
        ⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️⚡️
        """
        log(message, type: statusCode >= 400 ? .error : .info)
    }

    static func logError(_ error: Error, response: HTTPURLResponse?, data: Data?) {
        let statusCode = response?.statusCode ?? -1
        let url = response?.url?.absoluteString ?? "No URL"
        let body = formatBody(data, headers: response?.allHeaderFields as? [String: String])

        let message = """
        ❌❌❌❌❌ ❗️ Request Failed ❗️ ❌❌❌❌❌
        [Error]: \(error.localizedDescription)
        [Status]: \(statusCode)
        [URL]: \(url)
        \(body.indentingNewlines())
        ❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌
        """
        log(message, type: .error)
    }
}

// MARK: - Helpers
extension NetworkLogger {
    private static func formatHeaders(_ headers: [String: String]?) -> String {
        guard let headers = headers, !headers.isEmpty else { return "[Headers]: None" }
        return "[Headers]:\n\(headers.map { "  \($0.key): \($0.value)" }.joined(separator: "\n"))"
    }

    private static func formatBody(_ data: Data?, headers: [String: String]?) -> String {
        guard let data = data, !data.isEmpty else { return "[Body]: None" }

        let isJSON = headers?["Content-Type"]?.contains("json") ?? false
        if isJSON, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return "[Body]:\n\(jsonString)"
        }

        return "[Body]:\n\(String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines))"
    }

    private static func log(_ message: String, type: OSLogType = .debug) {
        let log = OSLog(subsystem: subsystem, category: "Network")
        os_log("%{public}@", log: log, type: type, message)
    }
}

// MARK: - String Formatting Helper
extension String {
    fileprivate func indentingNewlines(by spaceCount: Int = 4) -> String {
        let spaces = String(repeating: " ", count: spaceCount)
        return replacingOccurrences(of: "\n", with: "\n\(spaces)")
    }
}
