//
//  Models.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: ResponseStatus
    let message: String
    let internalMessage: String?
    let data: T?
    let subStatus: Int
}
enum ResponseStatus : Int, Codable {
    case Success = 0
    case Error = 1
    case AuthFailure = 2
    case Conflict = 3
}

struct ApiError: Error {

    var statusCode: Int!
    let errorCode: String
    var message: String

    init(statusCode: Int = 0, errorCode: String, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }

    var errorCodeNumber: String {
        let numberString = errorCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return numberString
    }

    private enum CodingKeys: String, CodingKey {
        case errorCode
        case message
    }
}

extension ApiError: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
}

struct APIResponseError: Codable , Error{
    let type: String?
    let title: String?
    let status: Int?
    let errors: [String: [String]]? // 🔥 Dynamic Dictionary to handle multiple fields
    let traceId: String?

}

