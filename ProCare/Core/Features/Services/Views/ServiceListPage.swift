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
    var id = 1
    
    var body: some View {
        ZStack {
            content
        }
        .appNavigationBar(title: "Service")
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
                Text("Total")
                    .font(.title2)
                Spacer()
                Text("\(vm.totalPrice) eg")
                    .font(.title3)
                    .foregroundStyle(.appPrimary)
            }
            .padding()

            Button {
                // Action here
            } label: {
                Text("Continue".localized())
                    .font(.title3)
            }
            .buttonStyle(AppButton(kind: .solid,width: 300, disabled: vm.selectedServices.isEmpty))
        }
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, y: -1)
    }
    private var emptyView: some View {
        VStack {
            Text("No Services Available")
                .foregroundColor(.gray)
                .padding()
        }
    }
    private func createErrorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text("Error: \(message)")
                .multilineTextAlignment(.center)
                
            Button("Retry") {
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
    mockVM.serviceItem = MockManger.shared.serviceListMockModel
    return ServiceListPage().environmentObject(ServiceVM())
}
