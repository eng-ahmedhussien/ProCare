//
//  NursingServiceCell.swift
//  ProCare
//
//  Created by ahmed hussien on 13/06/2025.
//

import SwiftUI

struct NursingServiceCell: View {
    let nursingServices: NursingServices
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 16) {
                AppImage(
                    urlString: nursingServices.imageUrl ?? "",
                    width: 72,
                    height: 72,
                    backgroundColor: .clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityLabel(Text(nursingServices.name ?? ""))

                VStack(alignment: .leading, spacing: 6) {
                    Text(nursingServices.name ?? "no_title".localized())
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text(nursingServices.description ?? "no_description".localized())
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NursingServiceCell(nursingServices: NursingServices.mock, onTap: {})
}
