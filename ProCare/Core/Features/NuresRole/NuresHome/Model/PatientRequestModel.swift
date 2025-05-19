//
//  OrdersPagination.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import Foundation


struct RequestsPagination: Codable {
    let items: [Request]?
    let totalCount, pageNumber, pageSize, totalPages: Int?
    let count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}

struct Request: Codable {
    let id, patientName: String?
    let patientPicture: String?
    let phoneNumber, patientId, status: String?
    let birthDate, bloodType, medicalHistory : String?
    let patientCity,  addressNotes, patientGovernorate, longitude, latitude, nurseLongitude, nurseLatitude: String?
    let createdAt: String?
    let totalPrice: Int?
    let gender: Int?
}

extension Request{
    var createdDate: String? {
        guard let dateStr = createdAt else { return nil }
        let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC or backend's timezone

           guard let date = formatter.date(from: dateStr) else {
               return "Invalid date"
           }

           let displayFormatter = DateFormatter()
           displayFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // Add 'a' for AM/PM
           displayFormatter.locale = Locale.current               // Localized
           displayFormatter.timeZone = TimeZone.current           // Device timezone

           return displayFormatter.string(from: date)
    }
}
