//
//  Logger.swift
//  ProCare
//
//  Created by ahmed hussien on 29/03/2025.
//


import os
import Foundation

// MARK: - Custom Logger
struct Logger {
    private let logger: OSLog

    /// Initializes a logger with a specific subsystem and category
    init(subsystem: String = Bundle.main.bundleIdentifier ?? "com.yourapp.default", category: String) {
        self.logger = OSLog(subsystem: subsystem, category: category)
    }

    /// Logs informational messages
    func info(_ message: String) {
        os_log(" %@", log: logger, type: .info, message)
    }

    /// Logs debugging messages
    func debug(_ message: String) {
        os_log(" %@", log: logger, type: .debug, message)
    }

    /// Logs warning messages
    func warning(_ message: String) {
        os_log("⚠️ %@", log: logger, type: .default, message)
    }

    /// Logs error messages
    func error(_ message: String) {
        os_log("%@", log: logger, type: .error, message)
    }

    /// Logs fault messages (critical issues)
    func fault(_ message: String) {
        os_log("🚨 %@", log: logger, type: .fault, message)
    }
}

// MARK: - Network Logger

class NetworkLogger {
    private static let logger = Logger(category: "Network")

    /// Logs API Request
    static func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "No URL"
        let headers = request.allHTTPHeaderFields ?? [:]
        let body = request.httpBody?.prettyPrintedJSONString ?? "No Body"

        logger.info("🚀 [API Request] Method: \(method), URL: \(url)")
        logger.debug("🏷 [Headers]: \(headers)")
        logger.debug("📦 [Body]: \(body)")
    }

    /// Logs API Response
    static func logResponse(request: URLRequest, response: HTTPURLResponse, data: Data) {
        let url = request.url?.absoluteString ?? "No URL"
        let statusCode = response.statusCode
        let responseBody = data.prettyPrintedJSONString ?? "No Response Body"

        logger.info("✅ [API Response] URL: \(url)")
        logger.debug("🔢 [Status Code]: \(statusCode)")
        logger.debug("📦 [Response Bod]: \(responseBody)")
    }

    /// Logs API Errors
    static func logError(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: String) {
        let url = request?.url?.absoluteString ?? "No URL"
        let statusCode = response?.statusCode ?? 0
        let responseBody = data?.prettyPrintedJSONString ?? "No Response Body"

        logger.error(" ❌ [URL]: \(url)")
        logger.debug("❌ [Error]: \(error)")
        logger.debug("🔢 [Status Code]: \(statusCode)")
        logger.debug("📦 [Response Body]: \(responseBody)")
    }
}

// MARK: - Pretty Printed JSON Extension
private extension Data {
    var prettyPrintedJSONString: String? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
              let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let prettyString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
