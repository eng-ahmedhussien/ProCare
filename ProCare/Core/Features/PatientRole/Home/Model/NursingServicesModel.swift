//
//  NursingServicesModel.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import Foundation

struct NursingServices: Codable {
    let fromCallCenter: Bool?
    let categoryId, id: Int?
    let name, description: String?
    let imageUrl: String?
}

extension NursingServices {
    static var mock: NursingServices {
        return NursingServices(fromCallCenter: false,
                               categoryId: 1,
                               id: 1,
                               name: "Nursing Service",
                               description: "This is a sample nursing service description.",
                               imageUrl: "https://example.com/images/post_op_care.jpg")
    }
    static var mockList: [NursingServices] {
        return [
            NursingServices(
                fromCallCenter: true,
                categoryId: 1,
                id: 101,
                name: "Home Visit",
                description: "A nurse will visit your home for basic medical assistance.",
                imageUrl: "https://example.com/images/home_visit.jpg"
            ),
            NursingServices(
                fromCallCenter: false,
                categoryId: 2,
                id: 102,
                name: "Wound Dressing",
                description: "Professional wound care and dressing changes.",
                imageUrl: "https://example.com/images/wound_dressing.jpg"
            ),
            NursingServices(
                fromCallCenter: true,
                categoryId: 3,
                id: 103,
                name: "IV Therapy",
                description: "Administration of intravenous fluids or medications.",
                imageUrl: "https://example.com/images/iv_therapy.jpg"
            ),
            NursingServices(
                fromCallCenter: false,
                categoryId: 1,
                id: 104,
                name: "Postoperative Care",
                description: "Monitoring and assistance after surgery at home.",
                imageUrl: "https://example.com/images/post_op_care.jpg"
            ),
            NursingServices(
                fromCallCenter: true,
                categoryId: 4,
                id: 105,
                name: "Elderly Care",
                description: "Comprehensive care services for elderly patients.",
                imageUrl: "https://example.com/images/elderly_care.jpg"
            )
        ]
    }
}
