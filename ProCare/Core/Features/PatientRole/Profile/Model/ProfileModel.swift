//
//  DataClass.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//


struct Profile: Codable {
    let id: String?
    let firstName, lastName: String?
    let image, birthDate: String?
    let phoneNumber: String?
    let medicalHistory, bloodType : String?
    let latitude, longitude : Double?
    let city, governorate, addressNotes: String?
    let governorateId, gender, addressId, cityId: Int?
}

extension Profile {
    static let mock = Profile(
        id: "1",
        firstName: "Ahmed",
        lastName: "Hussien",
        image: "https://example.com/image.jpg",
        birthDate: "1990-01-01",
        phoneNumber: "01012345678",
        medicalHistory: "No known allergies",
        bloodType: "O+",
        latitude: 30.0444,
        longitude: 31.2357,
        city: "Cairo",
        governorate: "Cairo",
        addressNotes: "Near the Nile",
        governorateId: 1,
        gender: 1,
        addressId: 1,
        cityId: 1
        
    )
  }

