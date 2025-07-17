    //
    //  SupportInfoType.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 12/07/2025.
    //


import SwiftUI

enum SupportInfoType: String, CaseIterable {
    case tel
    case whatsapp
    case general
    case hr
    case support
    case address
    case agreement
    
    var value: String {
        switch self {
        case .tel: return AppConstants.supportNumber
        case .whatsapp: return AppConstants.supportNumber
        case .general: return "info@procare.live"
        case .hr: return "hr@procare.live"
        case .support: return "support@procare.live"
        case .address: return "6 Al-Tabar Street, Helwan Metro Station, Ground Floor, Apartment 1, Cairo"
        case .agreement: return "https://www.procare.live/terms"
        }
    }
    
    var icon: String {
        switch self {
        case .tel: return "phone.fill"
        case .whatsapp: return "message.circle.fill"
        case .general, .hr: return "envelope.fill"
        case .support: return "wrench.fill"
        case .address: return "building.2.fill"
        case .agreement: return "doc.text.fill"
        }
    }
    
    var label: String {
        switch self {
        case .tel: return "Tel:"
        case .whatsapp: return "WhatsApp:"
        case .general: return "General:"
        case .hr: return "HR:"
        case .support: return "Support:"
        case .address: return "Address:"
        case .agreement: return "Agreement:"
        }
    }
}
