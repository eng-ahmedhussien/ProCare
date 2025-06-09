import Foundation
import CoreLocation

// MARK: - PharmacyPagedResult
struct PharmacyPagedResult: Codable {
    let items: [PharmacyItem]
    let totalCount: Int
    let pageNumber: Int
    let pageSize: Int
    let totalPages: Int
    let count: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
}

// MARK: - PharmacyItem
struct PharmacyItem: Codable, Identifiable {
    let id: Int?
    let name: String?
    let email: String?
    let lineNumber: String?
    let latitude: String?
    let longitude: String?
    let cityName: String?
    let governorateName: String?
    let phoneNumber: String?
    let addressNotes: String?
    
  
    var location: CLLocation? {
           if let lat = latitude, let lon = longitude,
              let latDouble = Double(lat), let lonDouble = Double(lon) {
               return CLLocation(latitude: latDouble, longitude: lonDouble)
           }
           return nil
       }
}

// MARK: - Preview Helpers
#if DEBUG

extension PharmacyPagedResult {
    static var mock: PharmacyPagedResult {
        PharmacyPagedResult(
            items: [.mock],
            totalCount: 14,
            pageNumber: 1,
            pageSize: 10,
            totalPages: 2,
            count: 10,
            hasNextPage: true,
            hasPreviousPage: false
        )
    }
}

extension PharmacyItem {
    static var mock: PharmacyItem {
        PharmacyItem(
            id: 1,
            name: "صيدلية هلال Helal pharmacy",
            email: "healthfirst@example.com",
            lineNumber: "02-12345678",
            latitude: "30.0396934",
            longitude: "31.3605326",
            cityName: "مدينة نصر",
            governorateName: "القاهرة",
            phoneNumber: "01234567890",
            addressNotes: nil
        )
    }
}
#endif 
