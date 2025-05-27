//
//  ReportFormView.swift
//  ProCare
//
//  Created by ahmed hussien on 24/05/2025.
//


import SwiftUI

struct ReportFormView: View {
    @State private var requestId: String = ""
    @State private var drugs: String = ""
    @State private var notes: String = ""
    @State private var diseasesIdsText: String = ""
    @State private var serviceIdsText: String = ""
    
    var onSubmit: ((Report) -> Void)?
    
    var body: some View {
        Form {
            Section(header: Text("Request Info")) {
                TextField("Request ID", text: $requestId)
            }
            
            Section(header: Text("Drugs")) {
                TextField("Drugs", text: $drugs)
            }
            
            Section(header: Text("Notes")) {
                TextField("Notes", text: $notes)
            }
            
            Section(header: Text("Diseases IDs (comma separated)")) {
                TextField("e.g. 1,2,3", text: $diseasesIdsText)
            }
            
            Section(header: Text("Service IDs (comma separated)")) {
                TextField("e.g. 10,20", text: $serviceIdsText)
                    .keyboardType(.numbersAndPunctuation)
            }
            
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
        }
        .navigationTitle("Add Report")
    }
}

#Preview {
    NavigationView {
        ReportFormView()
    }
}