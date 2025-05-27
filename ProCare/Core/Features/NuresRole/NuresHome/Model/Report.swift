//
//  AddReportDto.swift
//  ProCare
//
//  Created by ahmed hussien on 23/05/2025.
//


import Foundation

struct Report: Codable {
    var requestId: String?
    var drugs: String?
    var notes: String?
    var diseasesIds: [String]?
    var serviceIds: [Int]?
}
