//
//  ServiceMultiSelectSheet.swift
//  ProCare
//
//  Created by ahmed hussien on 24/05/2025.
//
import SwiftUI

struct ServiceMultiSelectSheet: View {
    let allServices: [ServiceItem]
    @Binding var selectedServices: [ServiceItem]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(allServices) { service in
                Button {
                    if selectedServices.contains(service) {
                        selectedServices.removeAll { $0.id == service.id }
                    } else {
                        selectedServices.append(service)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(service.name ?? "")
                                .font(.body)
                            Text(service.description ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Text("\(service.price ?? 0)")
                            .font(.body)
                            .foregroundStyle(.appPrimary)
                        
                        if selectedServices.contains(service) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("select_services".localized())
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }.foregroundStyle(.appPrimary)
                }
            }
        }
    }
}
#Preview {
    ServiceMultiSelectSheet(allServices: ServiceItem.mockServices, selectedServices: .constant([]))
}
