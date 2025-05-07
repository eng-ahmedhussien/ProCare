//
//  CityModel.swift
//  ProCare
//
//  Created by ahmed hussien on 07/05/2025.
//

import Foundation

struct City: Codable,DropdownOption {
    var id: Int
    var name: String { nameEn ?? "" } // conforms to DropdownOption
    let nameAr, nameEn: String?
    let governorateId: Int?
    let governorate: String?
}
