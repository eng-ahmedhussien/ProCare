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
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(service.name ?? "")
                    .font(.body)
                    .bold()
                  
                Text(service.description ?? "")
                    .lineLimit(2)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(service.price ?? 0)")
                .font(.body)
                .foregroundStyle(.appPrimary)
            
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                           .resizable()
                           .frame(width: 22, height: 22)
                           .foregroundColor(isSelected ? .appPrimary : .gray)

        }
        .frame(minHeight: 70, maxHeight: 100)
        .padding(12)
        .contentShape(Rectangle()) // makes the full area tappable
        .onTapGesture {
            toggleSelection()
        }
        .backgroundCard(
            color: .white,
            cornerRadius: 10,
            shadowRadius: 2,
            shadowColor: .gray
        )
        .padding(.horizontal)
    }
}

#Preview {
    ServiceCellView(service: MockManger.shared.serviceMockModel, selectedServices: .constant([]))
}
