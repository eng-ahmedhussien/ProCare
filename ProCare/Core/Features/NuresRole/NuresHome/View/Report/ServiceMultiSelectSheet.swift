import SwiftUI

struct ServiceMultiSelectSheet: View {
    let allServices: [ServiceItem]
    @Binding var selectedServices: [ServiceItem]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List(allServices, id: \.id) { service in
                Button {
                    if let idx = selectedServices.firstIndex(where: { $0.id == service.id }) {
                        selectedServices.remove(at: idx)
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
                        if selectedServices.contains(where: { $0.id == service.id }) {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Select Services")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}