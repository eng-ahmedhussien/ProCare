//
//  NurseData.swift
//  ProCare
//
//  Created by ahmed hussien on 12/06/2025.
//

import Foundation
import CoreLocation

// MARK: - DataClass
struct NurseData: Codable {
    let items: [Nurse]?
    let totalCount, pageNumber, pageSize, totalPages, count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}


// MARK: - Item
struct Nurse: Codable {
    let id, fullName, specialization: String?
    let specializationId: Int?
    let licenseNumber: String?
    let image: String?
    let rating: Double?
    let latitude, longitude: Double?
    let reviews: [Review]
    let isBusy: Bool?
    let numberOfReviews: Int? 
    
    var coordinate: CLLocation? {
           if let lat = latitude, let lon = longitude {
               return CLLocation(latitude: lat, longitude: lon)
           }
           return nil
       }

}

// Review
struct Review: Codable {
    let id: Int?
    let comment: String?
    let rating: Double?
    let patientName: String?
    let createdAt: String?
}

extension Review {
    var formattedCreatedAt: String? {
        guard let createdAt = createdAt else { return nil }
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: createdAt) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mma"
//        formatter.amSymbol = "AM"
//        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }
}
    

// MARK: - Preview Helpers

extension Nurse {
    static var mock: Nurse {
        return Nurse(
            id: "1",
            fullName: "John Doe",
            specialization: "Pediatrics",
            specializationId: 1,
            licenseNumber: "123456",
            image: "https://fastly.picsum.photos/id/214/200/300.jpg?hmac=XWc2pr4xabaprbyVoKEw9VsBDZ0ibySoVWMJaKokGRU",
            rating: 2,
            latitude: 37.7749,
            longitude: -122.4194,
            reviews: Review.mockReviews,
            isBusy: false, numberOfReviews: 3
            
        )
    }
}

extension NurseData {
    static var mock: NurseData {
        return NurseData(
            items: [Nurse.mock],
            totalCount: 1,
            pageNumber: 1,
            pageSize: 10,
            totalPages: 1,
            count: 1,
            hasNextPage: false,
            hasPreviousPage: false
        )
    }
}
extension Review {
    static var mock: Review {
        return Review(
            id: 1,
            comment: "Great service!",
            rating: 5,
            patientName: "Jane Doe",
            createdAt: "2023-10-01T12:00:00Z"
        )
    }
    static var mockReviews: [Review]{
        return [Review(
            id: 1,
            comment: "Great service!",
            rating: 5,
            patientName: "Jane Doe",
            createdAt: "2023-10-01T12:00:00Z"
        ),Review(
            id: 2,
            comment: "Very professional.",
            rating: 4,
            patientName: "John Smith",
            createdAt: "2023-10-02T12:00:00Z"
        ),Review(
            id: 3,
            comment: "Highly recommended!",
            rating: 5,
            patientName: "Alice Johnson",
            createdAt: "2023-10-03T12:00:00Z"
        )]
    }
}

