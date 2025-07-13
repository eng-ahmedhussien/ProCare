    //
    //  SupportView.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 12/07/2025.
    //

import SwiftUI

struct InformationScreen: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Group {
                    SupportRow(icon: "phone.fill", label: "Tel:", value: "0224554050")
                    SupportRow(icon: "message.circle.fill", label: "WhatsApp:", value: "+201119858928")
                    SupportRow(icon: "envelope.fill", label: "General:", value: "info@procare.live")
                    SupportRow(icon: "envelope.fill", label: "HR:", value: "hr@procare.live")
                    SupportRow(icon: "wrench.fill", label: "Support:", value: "support@procare.live")
                    SupportRow(icon: "building.2.fill", label: "Address:", value: "6 Al-Tabar Street, Helwan Metro Station, Ground Floor, Apartment 1, Cairo")
                    SupportRow(icon: "doc.text.fill", label: "Agreement:", value: "Terms and conditions")
                }
                .padding(.horizontal)
            }
            .padding(.top, 24)
        }
    }
}

struct SupportRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(label)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SupportView()
}
