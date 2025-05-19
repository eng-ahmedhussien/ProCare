//
//  DataClass.swift
//  ProCare
//
//  Created by ahmed hussien on 28/04/2025.
//

import Foundation

// MARK: - DataClass
struct ServiceData: Codable {
    let pagedResult: PagedResult?
    let type: Int?
    let callCenter: Bool?
}

// MARK: - PagedResult
struct PagedResult: Codable {
    let items: [ServiceItem]?
    let totalCount, pageNumber, pageSize, totalPages: Int?
    let count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}

// MARK: - Item
struct ServiceItem: Codable {
    let id: Int?
    let name, description: String?
    let price, subCategoryId: Int?

}
