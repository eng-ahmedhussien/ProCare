//
//  HomeCategoryModel.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Foundation


struct Category: Codable {
    let id: Int?
    let name, description: String?
    let imageUrl: String?
}

extension Category {
    static let mockCategories: [Category] = [
        Category(
            id: 1,
            name: "Nursing",
            description: "Professional nursing services at home.",
            imageUrl: "https://example.com/images/nursing.png"
        ),
        Category(
            id: 2,
            name: "Physiotherapy",
            description: "Expert physiotherapy sessions.",
            imageUrl: "https://example.com/images/physiotherapy.png"
        ),
        Category(
            id: 3,
            name: "Lab Tests",
            description: "Home sample collection for lab tests.",
            imageUrl: "https://example.com/images/labtests.png"
        )
    ]
}
