//
//  AppMockManger.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import Foundation
import Combine

class MockManger: ObservableObject{
    static let shared = MockManger()
    
    let NursesListMockModel = [
        Nurse(
            id: UUID().uuidString,
            fullName: "سارة علي",
            specialization: "أورام",
            specializationId: 1,
            licenseNumber: "12345",
            image: "https://picsum.photos/id/237/200/300",
            rating: "4.5",
            latitude: "24.7136",
            longitude: "46.6753"
        ),
        Nurse(
            id: UUID().uuidString,
            fullName: "منى حسن",
            specialization: "أطفال",
            specializationId: 2,
            licenseNumber: "67890",
            image: "https://picsum.photos/seed/picsum/200/300",
            rating: "4.9",
            latitude: "24.7743",
            longitude: "46.7386"
        )
    ]
    
    let nurseMockModel = Nurse(id: "1", fullName: "Noor", specialization: "Noor", specializationId: 1, licenseNumber: "Noor", image: "Noor", rating: "Noor", latitude: "Noor", longitude: "Noor")
    
    
    let serviceListMockModel = [
        ServiceItem(id: 1, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1),
        ServiceItem(id: 2, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1),
        ServiceItem(id: 3, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1),
        ServiceItem(id: 4, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1),
        ServiceItem(id: 5, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1),
        ServiceItem(id: 6, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1)
    ]
    let serviceMockModel =
        ServiceItem(id: 1, name: "Wound Care", description: "Cleaning wounds and changing bandages professionally.", price: 250, subCategoryId: 1)
    
    let orderMockModel = Order(id: "1", nurseName: "ahmed", nursePicture: "20", phoneNumber: "012321r43", nurseId: "1", status: "Completed", speciality: "nurese", longitude: "", latitude: "", nurseLongitude: "", nurseLatitude: "", createdAt: "2025-05-01T17:49:14.4177125", totalPrice: 200)
        
}
