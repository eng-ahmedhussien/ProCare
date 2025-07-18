    //
    //  OrdersPagination.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 20/05/2025.
    //


    import Foundation


    struct NurseRequest: Codable {
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
        let patientCity,  addressNotes, patientGovernorate:  String?
        let longitude, latitude, nurseLongitude, nurseLatitude: Double?
        let createdAt: String?
        let totalPrice: Int?
        let gender: Int?
        let statusId: RequestStatuses?
    }

    extension Request{
        enum RequestStatuses : Int, Codable {
            case New = 1
            case Approved = 2
            case Cancelled = 3
            case Rejected = 4
            case Completed = 5
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
    //        displayFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // Add 'a' for AM/PM
            displayFormatter.locale = Locale.current               // Localized
            displayFormatter.timeZone = TimeZone.current           // Device timezone
            displayFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd hmma")
            
            return displayFormatter.string(from: date)
        }
        

    }


    extension Request{
        static let mock = Request(
            id: "REQ12345",
            patientName: "Jane Doe",
            patientPicture: "https://example.com/patient.jpg",
            phoneNumber: "+1234567890",
            patientId: "PAT56789",
            status: "pending",
            birthDate: "1990-01-01",
            bloodType: "A+",
            medicalHistory: "Diabetes, Hypertension",
            patientCity: "naser city",
            addressNotes: "Near the main square",
            patientGovernorate: "Cairo",
            longitude: 31.2357,
            latitude: 30.0444,
            nurseLongitude: 31.2400,
            nurseLatitude: 30.0500,
            createdAt: "2025-05-14T17:27:16.0523865",
            totalPrice: 1500,
            gender: 1, statusId: .New
        )
        
        static let mocklist: [Request] = [
            mock,
            mock,
            mock,
            mock,
            mock,
            mock,
            mock,
            mock,
            mock,
            mock
        ]
        
    }
