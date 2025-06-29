//
//  NursesListScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 17/05/2025.
//

import SwiftUI
import CoreLocation

struct OrdersListView: View {
    @ObservedObject var vm: OrdersVM
    
    var body: some View {
        ZStack {
            content
        }
        .onAppear {
            if vm.ordersList.isEmpty {
                Task {
                    await vm.fetchOrders(loadType: .initial)
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchOrders(loadType: .refresh)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.viewState {
        case .initialLoading:
            AppProgressView()
        case .pagingLoading, .refreshing, .loaded:
            orderListView
        case .empty:
            AppEmptyView(message: "no_orders_available".localized())
        case .error(let message):
            RetryView(message: "error".localized() + ": \(message)") {
                Task {
                    await vm.fetchOrders(loadType: .initial)
                }
            }
        }
    }
    
    var orderListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.ordersList, id: \.id) { order in
                    OrderCellView(order: order)
                        .onAppear {
                            if order.id == vm.ordersList.last?.id, vm.hasNextPage {
                                Task {
                                    await vm.fetchOrders(loadType: .paging)
                                }
                            }
                        }
                }
                .redacted(reason: vm.viewState == .pagingLoading ? .placeholder : [])
                
                if vm.viewState == .pagingLoading {
                    ProgressView()
                        .appProgressStyle(color: .appPrimary)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    let vm = OrdersVM()
    vm.viewState = .loaded
    vm.ordersList = [
        Order(
            id: "1",
            nurseName: "Sarah Johnson",
            nursePicture: nil,
            phoneNumber: "01012345678",
            nurseId: "101",
            status: "completed",
            speciality: "Pediatric Nurse",
            longitude: 30.033333,
            latitude: 31.233334,
            nurseLongitude: 30.033334,
            nurseLatitude: 31.233335,
            createdAt: "2024-01-01T10:00:00Z",
            totalPrice: 250, statusId: .Completed
        ),
        Order(
            id: "2",
            nurseName: "Ahmed Ali",
            nursePicture: nil,
            phoneNumber: "01123456789",
            nurseId: "102",
            status: "pending",
            speciality: "Emergency Nurse",
            longitude: 30.044420,
            latitude: 31.235712,
            nurseLongitude: 30.044421,
            nurseLatitude: 31.235713,
            createdAt: "2024-01-02T14:30:00Z",
            totalPrice: 200, statusId: .Cancelled
        )
    ]

    return NavigationStack {
        OrdersListView(vm: vm)
    }
}
