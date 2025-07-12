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
    @State private var showContactOptions = false
    var id  = 0
    
    @State var isSelected = false
    var body: some View {
        content
            .appNavigationBar(title: "nursing_services")
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.subCategories, id: \.id){ nursingServices in
                    NursingServiceCell(nursingServices: nursingServices){
                        handleNursingServiceTap(nursingServices)
                    }
                }
                .padding(.horizontal)
                
            }
            .padding(.top,12)
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
        .confirmationDialog(
            "contact_options".localized(),
            isPresented: $showContactOptions,
            titleVisibility: .visible
        ) {
            Button("call".localized()) {
                if let url = URL(string: "tel://01097478188"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            Button("WhatsApp") {
                let phone = "01097478188"
                if let url = URL(string: "https://wa.me/\(phone)") {
                    UIApplication.shared.open(url)
                    
                }
            }
            Button("cancel".localized(), role: .cancel) { }
        }
        
  
        
    }
    private func handleNursingServiceTap(_ nursingServices: NursingServices) {
        if nursingServices.fromCallCenter ?? false {
            debugPrint(nursingServices.name ?? "")
            showContactOptions.toggle()
        } else {
            switch nursingServices.id {
            case 1:
                if let _ = ordersVM.currentOrder {
                    showToast(
                        "request_limit_message".localized(),
                        appearance: .error
                    )
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
