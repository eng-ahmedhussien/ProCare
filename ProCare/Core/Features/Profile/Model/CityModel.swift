//
//  CityModel.swift
//  ProCare
//
//  Created by ahmed hussien on 07/05/2025.
//

import Foundation

struct City: Codable,DropdownOption {
    var id: Int
    let nameAr: String?
    let nameEn: String?
    let governorateId: Int?
    let governorate: String?

    var name: String { // required by DropdownItem
        nameEn ?? nameAr ?? ""
    }
}
