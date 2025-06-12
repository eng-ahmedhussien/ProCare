//
//  DataClass.swift
//  ProCare
//
//  Created by ahmed hussien on 15/05/2025.
//
import Foundation
import CoreLocation
import MapKit


struct OrdersPagination: Codable {
    let items: [Order]?
    let totalCount, pageNumber, pageSize, totalPages: Int?
    let count: Int?
    let hasNextPage, hasPreviousPage: Bool?
}

struct Order: Codable {
    let id, nurseName: String?
    let nursePicture: String?
    let phoneNumber, nurseId, status, speciality: String?
    let longitude, latitude, nurseLongitude, nurseLatitude: String?
    let createdAt: String?
    let totalPrice: Int?
    let statusId: RequestStatuses?
}

extension Order{
    enum RequestStatuses : Int, Codable {
        case New = 1
        case Approved = 2
        case Cancelled = 3
        case Rejected = 4
        case Completed = 5
    }
}

extension Order {
    // Computed property to calculate distance
    var distance: CLLocationDistance? {
        guard let latStr = latitude,
              let lonStr = longitude,
              let nurseLatStr = nurseLatitude,
              let nurseLonStr = nurseLongitude,
              let lat = Double(latStr),
              let lon = Double(lonStr),
              let nurseLat = Double(nurseLatStr),
              let nurseLon = Double(nurseLonStr) else {
            return nil
        }
        
        let userLocation = CLLocation(latitude: lat, longitude: lon)
        let nurseLocation = CLLocation(latitude: nurseLat, longitude: nurseLon)
        
        return userLocation.distance(from: nurseLocation) // in meters
    }
    
    // estimatedTimeMinutes
    var estimatedTimeMinutes: Int? {
        guard let meters = distance else { return nil }
        let averageSpeed = 40.0 // km/h
        let timeInHours = (meters / 1000) / averageSpeed
        return Int(timeInHours * 60)
    }
    
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
          // displayFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // Add 'a' for AM/PM
           displayFormatter.locale = Locale.current               // Localized
           displayFormatter.timeZone = TimeZone.current           // Device timezone
           displayFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd hmma")

           return displayFormatter.string(from: date)
    }
}

extension Order {
    static let mock: Order = Order(
        id: "1",
        nurseName: "Jane Doe",
        nursePicture: "https://example.com/nurse.jpg",
        phoneNumber: "1234567890",
        nurseId: "nurse_001",
        status: "active",
        speciality: "Pediatrics",
        longitude: "31.2357",
        latitude: "30.0444",
        nurseLongitude: "31.2400",
        nurseLatitude: "30.0500",
        createdAt: "2024-06-01T12:34:56.1234567",
        totalPrice: 200, statusId: .Completed
    )
}
