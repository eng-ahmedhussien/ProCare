//
//  NurseModel.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import Foundation
import CoreLocation

// MARK: - DataClass
struct NurseList: Codable {
    let items: [Nurse]?
    let totalCount, pageNumber, pageSize, totalPages: Int?
    let count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}

// MARK: - Item
struct Nurse: Codable {
    let id, fullName, specialization: String?
    let specializationId: Int?
    let licenseNumber: String?
    let image: String?
    let rating: String?
    let latitude, longitude: String?
    
    var coordinate: CLLocation? {
           if let lat = latitude, let lon = longitude,
              let latDouble = Double(lat), let lonDouble = Double(lon) {
               return CLLocation(latitude: latDouble, longitude: lonDouble)
           }
           return nil
       }

}
