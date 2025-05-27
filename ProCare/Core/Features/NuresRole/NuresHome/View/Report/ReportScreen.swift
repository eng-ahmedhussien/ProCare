//
//  ReportScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 24/05/2025.
//


import SwiftUI

struct ReportScreen: View {
    
    @ObservedObject var vm: RequestsVM
    
    @State private var requestId: String = ""
    @State private var drugs: String = ""
    @State private var notes: String = ""
    @State private var diseasesIdsText: String = ""
    @State private var serviceIdsText: String = ""
    
    @State private var showDiseaseSheet = false
    @State private var selectedDiseases: [Disease] = []
 
    
    var onSubmit: ((Report) -> Void)?
  
    
    var body: some View {
        ScrollView{
            AppTextField(text: $drugs, placeholder: "Drugs", validationRules: [.isEmpty])
                .padding(.horizontal)
                .padding(.vertical, 12)
          
            
            
            Button {
                showDiseaseSheet = true
            } label: {
                HStack {
                    Text(selectedDiseases.isEmpty ? "Select Diseases" : selectedDiseases.map { $0.name }.joined(separator: ", "))
                        .foregroundColor(selectedDiseases.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
            }
            .sheet(isPresented: $showDiseaseSheet) {
                DiseaseMultiSelectSheet(
                    allDiseases:  Disease.mockDiseases,
                    selectedDiseases: $selectedDiseases
                ).presentationDetents([.medium, .fraction(0.7), .large])
            }

            
            AppTextField(text: $serviceIdsText, placeholder: "Service IDs (comma separated)", validationRules: [.isEmpty])
                .padding(.horizontal)
                .padding(.vertical, 12)
                .keyboardType(.numbersAndPunctuation)
            
            AppTextField(text: $notes, placeholder: "Notes", validationRules: [.isEmpty])
                .padding(.horizontal)
                .padding(.vertical, 12)
            
            Button("Submit") {
                let diseasesIds = diseasesIdsText
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                let serviceIds = serviceIdsText
                    .split(separator: ",")
                    .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                
                let report = Report(
                    requestId: requestId.isEmpty ? nil : requestId,
                    drugs: drugs.isEmpty ? nil : drugs,
                    notes: notes.isEmpty ? nil : notes,
                    diseasesIds: diseasesIds.isEmpty ? nil : diseasesIds,
                    serviceIds: serviceIds.isEmpty ? nil : serviceIds
                )
                onSubmit?(report)
            }
            .buttonStyle(AppButton(kind: .solid, width: 300))
            .padding()
        
        }
        .appNavigationBar(title: "Add Report")
    }
}

extension {
    var addressDetails: some View {
        VStack(alignment: .leading, spacing : 10){
            Text("Detailed address")
                .font(.body)
            TextEditor(text: $vm.addressInDetails)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
        .padding()
    }
}



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

#Preview {
    NavigationView {
        var vm = RequestsVM()
        vm.allDiseases = Disease.mockDiseases
        return ReportScreen(vm: vm)
    }
}
