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
    
    // time
    var estimatedTimeMinutes: Int? {
        guard let meters = distance else { return nil }
        let averageSpeed = 40.0 // km/h
        let timeInHours = (meters / 1000) / averageSpeed
        return Int(timeInHours * 60)
    }
}

