import SwiftUI

enum SupportInfoType: String, CaseIterable {
    case tel = "0224554050"
    case whatsapp = "+201119858928"
    case general = "info@procare.live"
    case hr = "hr@procare.live"
    case support = "support@procare.live"
    case address = "6 Al-Tabar Street, Helwan Metro Station, Ground Floor, Apartment 1, Cairo"
    case agreement = "Terms and conditions"
    
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