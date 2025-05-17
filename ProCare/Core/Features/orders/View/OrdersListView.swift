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
        .appNavigationBar(title: "")
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
            ProgressView()
                .appProgressStyle(color: .appPrimary)
                .padding()
            
        case .pagingLoading, .refreshing, .loaded:
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
        
        case .empty:
            emptyView
        
        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                Text("Error: \(message)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Button("Retry") {
                    Task {
                        await vm.fetchOrders(loadType: .initial)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclam")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("لا توجد ممرضات حالياً")
                .foregroundColor(.gray)
        }
        .padding()
    }
    
}
