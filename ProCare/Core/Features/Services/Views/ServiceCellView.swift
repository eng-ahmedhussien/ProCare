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
            
            Toggle("", isOn: Binding(
                get: { selectedServices.contains(where: { $0.id == service.id }) },
                set: { isSelected in
                    if isSelected {
                        selectedServices.append(service)
                    } else {
                        selectedServices.removeAll(where: { $0.id == service.id })
                    }
                }
            ))
            .toggleStyle(CheckboxStyle())

        }
        .frame(height: screenHeight/10)
        .padding(8)
        .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
        .padding(.horizontal)
    }
}

#Preview {
    ServiceCellView(service: MockManger.shared.serviceMockModel, selectedServices: .constant([]))
}

struct CheckboxStyle: ToggleStyle {
    var width:CGFloat = 24
    var height:CGFloat = 24
    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack(alignment: .top) {
           // Image(configuration.isOn ? "toggleOn" : "emptySquare")
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: width, height: height)
                .foregroundStyle(configuration.isOn ? .appPrimary : .gray)
               // .tint(configuration.isOn ? .yellow : .gray)
              //  configuration.label
           // Spacer()
        }
        .onTapGesture { configuration.isOn.toggle() }

    }
}
