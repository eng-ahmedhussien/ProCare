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
            await vm.fetchAllDataAndFillReport(patientId: vm.currentRequest?.patientId ?? "")
        }
        .onTapGesture {
            isDrugsFocused = false
        }
        .alert("total".localized(), isPresented: $showTotal) {
            Button("cancel".localized(), role: .cancel) {
                appRouter.popToRoot()
            }
        } message: {
            Text(String(format: "total_requests".localized(), vm.totalRequest))
        }
        .appNavigationBar(title: "add_report")
    }
}

extension ReportScreen{
    var drugsView: some View {
        AppTextEditor(
            text: $vm.drugs,
            placeholder: "drugs".localized(),
            height: 100,
            isFocused: $isDrugsFocused
        ).padding()
    }
    
    var notesView: some View {
        AppTextEditor(
            text: $vm.notes,
            placeholder: "notes".localized(),
            height: 100,
            isFocused: $isDrugsFocused
        ).padding()
    }
    
    var diseaseButton: some View {
            Button {
                showDiseaseSheet = true
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    if vm.selectedDiseases.isEmpty {
                        Text("select_diseases")
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
                        Text("select_services")
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

   
    
    var submit: some View {
        Button("submit") {
            Task{
                await  vm.addOrUpdateReport{ data in
                    if data {
                        showTotal.toggle()
                        showToast("report_added_successfully", appearance: .success)
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
