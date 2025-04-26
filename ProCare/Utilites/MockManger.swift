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
}
