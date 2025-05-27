//
//  Disease.swift
//  ProCare
//
//  Created by ahmed hussien on 24/05/2025.
//

import Foundation



// MARK: - DataClass
struct PagedDisease: Codable {
    let items: [Disease]?
    let totalCount, pageNumber, pageSize, totalPages: Int?
    let count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}

// MARK: - Disease
struct Disease: Codable,Identifiable, Equatable {
    let id: String
    let name: String?
}

extension Disease {
    static let mockDiseases: [Disease] = [
        Disease(id: "c2a9e8d2-5c7e-4147-e242-08dd91a53272", name: "لاشئ"),
        Disease(id: "66707958-7447-440f-e243-08dd91a53272", name: "ارتفاع ضغط الدم"),
        Disease(id: "c7f846d0-d46a-41e8-540f-08dd91a9bfe2", name: "الربو"),
        Disease(id: "519981da-201e-46c6-5410-08dd91a9bfe2", name: "أمراض القلب"),
        Disease(id: "b8d66a4a-e0c8-4cdf-5411-08dd91a9bfe2", name: "أمراض القلب"),
        Disease(id: "8478fd64-83c5-45c2-5412-08dd91a9bfe2", name: "فقر الدم"),
        Disease(id: "0ef39c7a-40e2-46d5-6f75-08dd95599f7d", name: "sadsad")
    ]
}
// ...existing code.
