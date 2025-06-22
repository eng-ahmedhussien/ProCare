//
//  RequestsListView.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//



import SwiftUI
import CoreLocation

struct RequestsListView: View {
    
    @ObservedObject var vm: RequestsVM
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            content
        }
        .onAppear {
            if vm.requestList.isEmpty {
                Task {
                    await vm.fetchRequests(loadType: .initial){
                        authManager.logout()
                    }
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchRequests(loadType: .refresh)
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
                    ForEach(vm.requestList, id: \.id) { request in
                        RequestCellView(request: request)
                            .onAppear {
                                if request.id == vm.requestList.last?.id, vm.hasNextPage {
                                    Task {
                                        await vm.fetchRequests(loadType: .paging)
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
            RetryView(message: "Error: \(message)") {
                Task {
                    await vm.fetchRequests(loadType: .initial)
                }
            }
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

#Preview {
    let vm = OrdersVM()
    vm.viewState = .loaded
    vm.ordersList =  Order.mocklist

    return NavigationStack {
        OrdersListView(vm: vm) // ✅ use the actual instance you configured
    }
}
