//
//  ServiceListPage.swift
//  ProCare
//
//  Created by ahmed hussien on 28/04/2025.
//

import SwiftUI

struct ServiceListPage: View {
    
    @EnvironmentObject var vm: HomeVM
    @EnvironmentObject var locationManger: LocationManager
    @EnvironmentObject var appRouter : AppRouter
    @State var showAddressAlert = false
    var id = 1
    
    var body: some View {
        ZStack {
            content
        }
        .padding(.bottom, 5)
        .edgesIgnoringSafeArea(.bottom)
        .appNavigationBar(title: "service".localized())
        .onAppear {
            if vm.serviceItem.isEmpty {
                Task {
                    async let servicesTask = vm.fetchServices(id: id, loadType: .initial)
                    async let priceTask = vm.getVisitServicePrice()
                    // Wait for both tasks to complete as we need both for proper total calculation
                    await (servicesTask, priceTask)
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchServices(id: id, loadType: .refresh)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.paginationViewState {
        case .initialLoading:
            ProgressView()
                .appProgressStyle(color: .appPrimary)
                .padding()
            
        case .pagingLoading, .refreshing, .loaded:
            VStack(spacing: 0){
                ScrollView(showsIndicators: false){
                    LazyVStack(spacing: 20) {
                        ForEach(vm.serviceItem, id: \.id) { item in
                            ServiceCellView(service: item, selectedServices: $vm.selectedServices)
                                .onAppear {
                                    if item.id == vm.serviceItem.last?.id, vm.hasNextPage {
                                        Task {
                                            await vm.fetchServices(id: id, loadType: .paging)
                                        }
                                    }
                                }
                        }
                        if vm.paginationViewState == .pagingLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.vertical)
                }
            
       
                    totalView
                       
            }
        
        case .empty:
            emptyView
        
        case .error(let message):
            createErrorView(message)
        }
    }
    

}

extension ServiceListPage{
    private var totalView: some View {
        let total = vm.totalPrice + (vm.visitServicePrice ?? 0)
        return VStack {
            Text("visit_fee_message")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 5){
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text("services".localized() + ":")
                        Spacer()
                        Text(vm.totalPrice.asEGPCurrency())
                    }
                    HStack{
                        Text("visit_Fee".localized() + ":")
                        Spacer()
                        Text(vm.visitServicePrice?.asEGPCurrency() ?? "")
                    }
                    Divider()
                    HStack {
                        Text("total".localized() + ":")
                            .font(.headline)
                            .foregroundStyle(.appPrimary)
                        Spacer()
                        Text(total.asEGPCurrency())
                            .font(.headline)
                            .foregroundStyle(.appPrimary)
                    }
                }

                Button {
                    if locationManger.isPermissionDenied {
                        showAddressAlert.toggle()
                    }else{
                        appRouter.pushView(
                            NursesListScreen(
                                servicesIds: vm.selectedServices,
                                total: total
                            ).environmentObject(vm)
                        )
                    }
                } label: {
                    Text("continue")
                        .font(.title3)
                }
                .buttonStyle(AppButton(kind: .solid, disabled: vm.selectedServices.isEmpty))
            }
            .padding()
            .background(
                Color(.systemBackground)
                    .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 0)
            )
        }
        .alert("location_required".localized(), isPresented: $showAddressAlert) {
            Button("add_address".localized()) {
                appRouter.pushView(UpdateAddressView())
            }
            Button("cancel".localized(), role: .cancel) {}
        } message: {
            Text("address_permission_message")
        }
    }
    private var emptyView: some View {
        VStack {
            Text("no_services_available")
                .foregroundColor(.gray)
                .padding()
        }
    }
    private func createErrorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text("error" + "\(message)")
                .multilineTextAlignment(.center)
                
            Button("retry".localized()) {
                Task {
                    await vm.fetchServices(id: id, loadType: .initial)
                }
            }
            .foregroundStyle(.appPrimary)
        }
        .padding()
    }
}

#Preview {
    let mockVM = HomeVM()
    mockVM.paginationViewState = .loaded
    mockVM.serviceItem = ServiceItem.mockServices
    return ServiceListPage().environmentObject(mockVM)
}
