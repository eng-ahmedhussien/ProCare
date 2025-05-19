//
//  NursingServicesModel.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import Foundation

struct NursingServices: Codable {
    let fromCallCenter: Bool?
    let categoryId, id: Int?
    let name, description: String?
    let imageUrl: String?
}
