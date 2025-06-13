//
//  NursingServicesPage.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import SwiftUI

struct NursingServicesPage: View {
    @EnvironmentObject var vm : HomeVM
    @EnvironmentObject var ordersVM: OrdersVM
    @EnvironmentObject var appRouter: AppRouter
    @State private var isLoading = true
    var id  = 0
    
    @State var isSelected = false
    var body: some View {
        
        content
            .background(.appBackground)
            .appNavigationBar(title: "nursing_services")
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(vm.subCategories, id: \.id){ nursingServices in
                    NursingServiceCell(nursingServices: nursingServices){
                        handleNursingServiceTap(nursingServices)
                    }
                }
                 .padding(.horizontal)
                 
            }
            .padding(.top)
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
                Task {
                    await loadData()
                    await ordersVM.fetchCurrentOrder()
                }
        }
        .refreshable {
            Task {
                await loadData()
            }
        }
        
    }
    
    private func handleNursingServiceTap(_ nursingServices: NursingServices) {
        if nursingServices.fromCallCenter ?? false {
            debugPrint(nursingServices.name ?? "")
        } else {
            switch nursingServices.id {
            case 1:
                if let order = ordersVM.currentOrder {
                    showToast("you have currently request with id \(order.id ?? "")", appearance: .error)
                } else {
                    appRouter.pushView(
                        ServiceListPage(id: nursingServices.id ?? 0)
                            .environmentObject(vm)
                    )
                }
            case 2:
                appRouter.pushView(
                    ReservationScreen()
                        .environmentObject(vm)
                )
                debugPrint(nursingServices.name ?? "")
            default:
                debugPrint(" not supported")
            }
        }
    }
    
    
    private func loadData() async {
        vm.fetchSubCategories(for: id)
        isLoading = false
    }
}


#Preview {
    let mockVM = HomeVM()
    mockVM.subCategories = NursingServices.mockList
    return NursingServicesPage( id: 2).environmentObject(mockVM).environmentObject(OrdersVM())
}
