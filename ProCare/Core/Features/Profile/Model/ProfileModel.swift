//
//  DataClass.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//


struct Profile: Codable {
    let id: Int?
    let firstName, lastName: String?
    let image, birthDate: String?
    let phoneNumber: String?
    let medicalHistory, bloodType, latitude, longitude: String?
    let city, governorate, cityId, addressNotes: String?
    let governorateId, gender, addressId: Int?
}
