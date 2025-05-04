//
//  Gender.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import Foundation

enum Gender: Int, CaseIterable, Identifiable {
    case notSpecified = 0
    case male = 1
    case female = 2

    var id: Int { self.rawValue }

    var displayName: String {
        switch self {
        case .notSpecified: return "Not Specified"
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}
