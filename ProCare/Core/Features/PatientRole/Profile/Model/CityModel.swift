//
//  CityModel.swift
//  ProCare
//
//  Created by ahmed hussien on 07/05/2025.
//

import Foundation

struct City: Codable,DropdownOption {
    var id: Int
    var name: String
    let governorateId: Int?
    let governorate: String?

}

extension City {
    static let mock: City = City(id: 1, name: "Nasr City", governorateId: 1, governorate: "Cairo")

    static let mockList: [City] = [
        City(id: 1, name: "Nasr City", governorateId: 1, governorate: "Cairo"),
        City(id: 2, name: "Dokki", governorateId: 2, governorate: "Giza"),
        City(id: 3, name: "Smouha", governorateId: 3, governorate: "Alexandria")
    ]
}
