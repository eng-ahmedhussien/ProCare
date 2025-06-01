//
//  ServiceListPage.swift
//  ProCare
//
//  Created by ahmed hussien on 28/04/2025.
//

import SwiftUI

struct ServiceListPage: View {
    
    @EnvironmentObject var vm: ServiceVM
    @EnvironmentObject var locationManger: LocationManager
    @EnvironmentObject var appRouter : AppRouter
    @State var showAddressAlert = false
    var id = 1
    
    var body: some View {
        ZStack {
            content
        }
        .appNavigationBar(title: "service".localized())
        .onAppear {
            if vm.serviceItem.isEmpty {
                Task {
                    await vm.fetchServices(id: id, loadType: .initial)
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
        VStack {
            HStack {
                Text("total")
                    .font(.title2)
                Spacer()
                Text("\(vm.totalPrice) EGP")
                    .font(.title3)
                    .foregroundStyle(.appPrimary)
            }
            .padding()

            Button {
                if locationManger.isPermissionDenied {
                    showAddressAlert.toggle()
                }else{
                    appRouter.pushView(NursesListScreen(servicesIds: vm.selectedServices))
                }
            } label: {
                Text("continue")
                    .font(.title3)
            }
            .buttonStyle(AppButton(kind: .solid, disabled: vm.selectedServices.isEmpty))
            .padding(.horizontal)
        }
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, y: -1)
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
    let mockVM = ServiceVM()
    mockVM.paginationViewState = .loaded
    mockVM.serviceItem = ServiceItem.mockServices
    return ServiceListPage().environmentObject(mockVM)
}
