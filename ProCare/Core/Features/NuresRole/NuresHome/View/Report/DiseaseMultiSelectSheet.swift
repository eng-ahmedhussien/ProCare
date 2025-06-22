//
//  DiseaseMultiSelectSheet.swift
//  ProCare
//
//  Created by ahmed hussien on 24/05/2025.
//
import SwiftUI

struct DiseaseMultiSelectSheet: View {
    let allDiseases: [Disease]
    @Binding var selectedDiseases: [Disease]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(allDiseases) { disease in
                Button {
                    if selectedDiseases.contains(disease) {
                        selectedDiseases.removeAll { $0.id == disease.id }
                    } else {
                        selectedDiseases.append(disease)
                    }
                } label: {
                    HStack {
                        Text(disease.name ?? "")
                            .font(.body)
                        Spacer()
                        if selectedDiseases.contains(disease) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Select Diseases".localized())
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done".localized()) {
                        dismiss()
                    }.foregroundStyle(.appPrimary)
                }
            }
        }
    }
}

#Preview {
    DiseaseMultiSelectSheet(allDiseases: Disease.mockDiseases, selectedDiseases: .constant([]))
}
