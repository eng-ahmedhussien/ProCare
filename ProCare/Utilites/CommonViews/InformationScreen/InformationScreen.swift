    //
    //  SupportView.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 12/07/2025.
    //

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

struct InformationScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(SupportInfoType.allCases, id: \.self) { info in
                    SupportRow(info: info) {
                        handleTap(on: info)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 24)
        }
        .appNavigationBar(title: "information".localized())
    }
    
    private func handleTap(on info: SupportInfoType) {
            // Handle tap based on type
        print("Tapped on: \(info.label) \(info.rawValue)")
    }
}

struct SupportRow: View {
    let info: SupportInfoType
    var onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: info.icon)
                .foregroundColor(.pink)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(info.label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text(info.rawValue)
                    .font(.body)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .backgroundCard(cornerRadius: 12, shadowRadius: 4, shadowX: 0, shadowY: 2)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    NavigationView{
        InformationScreen()
            .appNavigationBar(title: "information".localized())
    }
}
