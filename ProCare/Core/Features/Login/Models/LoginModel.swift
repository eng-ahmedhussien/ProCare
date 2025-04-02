//
//  LoginModel.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation


struct LoginModel: Codable {
    let status: ResponseStatus?
    let message: String?
    let internalMessage: String?
    let data: UserDataLogin?
    let subStatus: Int?
}

// MARK: - DataClass
struct UserDataLogin: Codable {
    let token, firstName, lastName, phoneNumber: String?
    let birthOfDate: String?
    let role, loginStatus: Int?
}


