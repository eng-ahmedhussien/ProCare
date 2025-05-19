//
//  LoginModel.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation


// MARK: - DataClass
struct UserDataLogin: Codable {
    let token, firstName, lastName, phoneNumber: String?
    let birthOfDate: String?
    let role: Roles?
    let loginStatus: LoginStatus?
}


enum LoginStatus : Int, Codable {
    case Success = 1
    case InValidCredintials = 2
    case UserLockedOut = 3
    case UserNotConfirmed = 4
    case Error = 5
}

enum Roles : Int, Codable {
    case Patient = 1
    case Nurse = 2
}



