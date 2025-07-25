//
//  ServiceListPage.swift
//  ProCare
//
//  Created by ahmed hussien on 28/04/2025.
//

import SwiftUI

struct ServiceListPage: View {
    
    @EnvironmentObject var vm: HomeVM
    @EnvironmentObject var appRouter : AppRouter
    @EnvironmentObject var profileVM: ProfileVM
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
                    async let servicesTask: () = vm.fetchServices(id: id, loadType: .initial)
                    async let priceTask: () = vm.getVisitServicePrice()
                    _ = await (servicesTask, priceTask) // Explicitly ignore the result
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
            AppProgressView()
        case .pagingLoading, .refreshing, .loaded:
            serviceListView
        case .empty:
            AppEmptyView(message: "no_services_available")
        case .error(let message):
            RetryView(message: "error".localized() + ": \(message)") {
                Task {
                    await vm.fetchServices(id: id, loadType: .initial)
                }
            }
        }
    }
    
    var serviceListView: some View {
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
                        AppProgressView()
                    }
                }
                .padding(.vertical)
            }
        
   
                totalView
                   
        }
    
    }

}

extension ServiceListPage{
    private var totalView: some View {
        let total = vm.totalPrice + (vm.visitServicePrice ?? 0)
        return VStack {
            Text("50_discount")
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
                    let ProfileLocation =  KeychainHelper.shared.getData(
                        Profile.self,
                        forKey: .profileData
                    )
                    if LocationManager.shared.isPermissionDenied || ProfileLocation?.city == nil {
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
}

#Preview {
    let mockVM = HomeVM()
    mockVM.paginationViewState = .loaded
    mockVM.serviceItem = ServiceItem.mockServices
    return ServiceListPage().environmentObject(mockVM)
}
