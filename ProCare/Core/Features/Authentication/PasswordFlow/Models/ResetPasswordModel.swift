//
//  ResetPasswordModel.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import Foundation

struct checkCodeModel: Codable {
    let isValid: Bool?
    let resetToken: String?
}
