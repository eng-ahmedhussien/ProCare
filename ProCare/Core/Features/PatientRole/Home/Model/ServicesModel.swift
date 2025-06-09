//
//  DataClass.swift
//  ProCare
//
//  Created by ahmed hussien on 28/04/2025.
//

import Foundation

// MARK: - ServiceData
struct ServiceData: Codable {
    let pagedResult: PagedResult?
    let type: Int?
    let callCenter: Bool?
}

struct PagedResult: Codable {
    let items: [ServiceItem]?
    let totalCount, pageNumber, pageSize, totalPages: Int?
    let count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}

struct ServiceItem: Codable, Identifiable,Equatable{
    let id: Int
    let name, description: String?
    let price, subCategoryId: Int?

}

extension ServiceItem {
    static let mockServices: [ServiceItem] = [
        ServiceItem(id: 1, name: "Home Nursing", description: "Professional nursing care at home.", price: 500, subCategoryId: 10),
        ServiceItem(id: 2, name: "Physiotherapy", description: "Expert physiotherapy sessions.", price: 300, subCategoryId: 11),
        ServiceItem(id: 3, name: "Lab Test", description: "Blood and urine sample collection at home.", price: 200, subCategoryId: 12)
    ]
}
