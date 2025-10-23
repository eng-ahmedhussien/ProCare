//
//  NurseProfile.swift
//  ProCare
//
//  Created by ahmed hussien on 30/05/2025.
//


struct NurseProfile: Codable {
    let id, firstName, lastName, phoneNumber: String?
    let rate: Double?
    let specialization: String?
    let specializationId: Int?
    let imageUrl: String?
    let governorateId: Int?
    let cityId: Int?
    let latitude, longitude: Double?
    let city, governorate,licenseNumber: String?
    let isBusy: Bool?
}

extension NurseProfile {
    static let mockNurseProfile = NurseProfile(
        id: "1",
        firstName: "ahmed",
        lastName: "hussien",
        phoneNumber: "01010101010",
        rate: 5,
        specialization: "General",
        specializationId: 1,
        imageUrl: "https://picsum.photos/200",
        governorateId: 1,
        cityId: 1,
        latitude: 30,
        longitude: 30,
        city: "",
        governorate: "",
        licenseNumber: "",
        isBusy: true
    )
    
}
