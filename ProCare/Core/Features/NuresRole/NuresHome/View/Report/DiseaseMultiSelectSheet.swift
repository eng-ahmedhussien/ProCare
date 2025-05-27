struct DiseaseMultiSelectSheet: View {
    let allDiseases: [Disease]
    @Binding var selectedDiseases: [Disease]
    @Environment(\.dismiss) var dismiss

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
                        Text(disease.name)
                            .foregroundStyle(.black)
                        Spacer()
                        if selectedDiseases.contains(disease) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Select Diseases")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}