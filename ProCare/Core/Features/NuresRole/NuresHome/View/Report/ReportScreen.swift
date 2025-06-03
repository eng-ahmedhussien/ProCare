//
//  ReportScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 24/05/2025.
//


import SwiftUI

struct ReportScreen: View {
    
    @ObservedObject var vm: RequestsVM
    @EnvironmentObject var appRouter: AppRouter
    
    @State private var showDiseaseSheet = false
    @State private var showServiceSheet = false
    @State private var showTotal = false
    @FocusState private var isDrugsFocused: Bool


    var body: some View {
        ScrollView{
            drugsView
            notesView
            diseaseButton
            servicesButton
            submit
        }
        .task {
            await vm.fetchReportByPatientId(id: vm.currentRequest?.patientId ?? "")
            await vm.fetchDiseases()
            await vm.fetchServices()
        }
        .onTapGesture {
            isDrugsFocused = false
        }
        .alert("Total", isPresented: $showTotal) {
            Button("Cancel", role: .cancel) {
                appRouter.popToRoot()
            }
        } message: {
            Text(String(format: "total_requests".localized(), vm.totalRequest))
        }
        .appNavigationBar(title: "Add Report")
    }
}

extension ReportScreen{
    var drugsView: some View {
        VStack(alignment: .leading, spacing : 10){
            Text("Drugs")
                .font(.body)
            
            TextEditor(text: $vm.drugs)
                .focused($isDrugsFocused)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
        .padding()
    }
    
    var diseaseButton: some View {
            Button {
                showDiseaseSheet = true
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    if vm.selectedDiseases.isEmpty {
                        Text("Select Diseases")
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(vm.selectedDiseases) { disease in
                                    HStack(spacing: 4) {
                                        Text(disease.name ?? "")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.8))
                                            .onTapGesture {
                                                vm.selectedDiseases.removeAll { $0.id == disease.id }
                                            }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(Color.appPrimary))
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(AppButton(kind: .border))
        .padding()
        .sheet(isPresented: $showDiseaseSheet) {
            DiseaseMultiSelectSheet(
                allDiseases: vm.allDiseases,
                selectedDiseases: $vm.selectedDiseases
            )
            .presentationDetents([.medium, .fraction(0.7), .large])
        }
    }
    
    var servicesButton: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                showServiceSheet = true
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    if vm.selectedServices.isEmpty {
                        Text("Select Services")
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(vm.selectedServices, id: \.id) { service in
                                    HStack(spacing: 4) {
                                        Text(service.name ?? "")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.white.opacity(0.8))
                                            .onTapGesture {
                                                vm.selectedServices.removeAll { $0.id == service.id }
                                            }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Capsule().fill(Color.appPrimary))
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(AppButton(kind: .border))
            .padding()
            .sheet(isPresented: $showServiceSheet) {
                ServiceMultiSelectSheet(
                    allServices: vm.allServices,
                    selectedServices: $vm.selectedServices
                )
                .presentationDetents([.medium, .fraction(0.7), .large])
            }
        }
    }

    var notesView: some View {
        VStack(alignment: .leading, spacing : 10){
            Text("Notes")
                .font(.body)
        
            TextEditor(text: $vm.notes)
                .focused($isDrugsFocused)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
        .padding()
    }
    
    var submit: some View {
        Button("Submit") {
            Task{
                await  vm.addOrUpdateReport{ data in
                    if data {
                        showTotal.toggle()
                        showToast("Report Added successfully", appearance: .success)
                    }
                }
            }
        }
        .buttonStyle(AppButton(kind: .solid, width: 300))
        .padding()
    }
    
}





#Preview {
    NavigationView {
        let vm = RequestsVM()
        vm.allDiseases = Disease.mockDiseases
        return ReportScreen(vm: vm)
    }
}
