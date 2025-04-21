//
//  PharmacyCardView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/04/2025.
//

import SwiftUI

struct PharmacyCardView: View {
    var name: String
    var phone: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 140, height: 100)
                .cornerRadius(10)
            Text(name)
                .font(.subheadline)
                .bold()
            Text(phone)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    PharmacyCardView(name: "", phone: "")
}
