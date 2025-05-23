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

struct ServiceItem: Codable {
    let id: Int?
    let name, description: String?
    let price, subCategoryId: Int?

}

