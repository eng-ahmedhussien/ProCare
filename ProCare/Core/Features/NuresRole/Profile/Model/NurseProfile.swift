//
//  NurseProfile.swift
//  ProCare
//
//  Created by ahmed hussien on 30/05/2025.
//


struct NurseProfile: Codable {
    let id, firstName, lastName, phoneNumber: String?
    let rate: Int?
    let specialization: String?
    let specializationId: Int?
    let imageUrl: String?
    let governorateId: Int?
    let cityId: Int?
    let latitude, longitude: Double?
    let city, governorate,licenseNumber: String?
    let isBusy: Bool?

}
