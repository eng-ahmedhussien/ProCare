//
//  RequestModel.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import Foundation

struct RequestModel: Codable {
    let nurseId, patientId: String?
    let addressId: Int?
    let latitude, longitude: String?
    let serviceIds: [Int]?
}
