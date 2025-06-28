//
//  ServiceCellView.swift
//  ProCare
//
//  Created by ahmed hussien on 28/04/2025.
//

import SwiftUI

struct ServiceCellView: View {
    var service: ServiceItem
    let screenHeight = UIScreen.main.bounds.height
    @Binding var selectedServices: [ServiceItem]
    
    
      private var isSelected: Bool {
          selectedServices.contains(where: { $0.id == service.id })
      }

    private func toggleSelection() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if isSelected {
                selectedServices.removeAll { $0.id == service.id }
            } else {
                selectedServices.append(service)
            }
        }
    }
     
    var body: some View {
        Button(action: toggleSelection) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(service.name ?? "Service")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(service.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .accessibilityLabel("Description: \(service.description ?? "")")
                }
                Spacer()
                Text("\(service.price ?? 0)")
                    .font(.body)
                    .foregroundStyle(.appPrimary)
                
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .appPrimary : .gray)
                    .accessibilityLabel(isSelected ? "Selected" : "Not selected")
                
            }
            .padding()
            .frame(minHeight: 100)
            .backgroundCard(
                color: .white,
                cornerRadius: 10,
                shadowRadius: 2,
                shadowColor: Color(.systemGray4)
            )
        } .buttonStyle(PlainButtonStyle())
            .accessibilityElement(children: .combine)
            .padding(.horizontal)
            .padding(.vertical, 4)
    }
}

#Preview {
    ServiceCellView(
        service: ServiceItem.mockService,
        selectedServices: .constant([])
    )
}
