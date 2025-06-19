//
//  GovernoratesModel.swift
//  ProCare
//
//  Created by ahmed hussien on 06/05/2025.
//

import Foundation

struct Governorates: Codable, DropdownOption {
    var id: Int
    var name: String
}

extension Governorates {
    static let mock: Governorates = Governorates(id: 1, name: "Cairo")

    static let mockList: [Governorates] = [
        Governorates(id: 1, name: "Cairo"),
        Governorates(id: 2, name: "Giza"),
        Governorates(id: 3, name: "Alexandria"),
        Governorates(id: 4, name: "Aswan")
    ]
}
