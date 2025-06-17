//
//  Models.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import Foundation

struct APIResponse<T: Codable>: Codable,Error {
    let status: ResponseStatus?
    let message: String?
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

struct APIResponseError: Codable , Error{
    let type: String?
    let title: String?
    let status: Int?
    let errors: [String: [String]]? // 🔥 Dynamic Dictionary to handle multiple fields
    let traceId: String?

}


struct EmptyData: Codable {}
