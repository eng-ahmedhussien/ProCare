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
            AppProgressView()
        case .pagingLoading, .refreshing, .loaded:
            requestsList
        case .empty:
            AppEmptyView(message: "no_requests".localized())
        
        case .error(let message):
            RetryView(message: "Error: \(message)") {
                Task {
                    await vm.fetchRequests(loadType: .initial)
                }
            }
        }
    }
    
    var requestsList: some View {
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
                    AppProgressView()
                }
            }
        }
    }

}

#Preview {
    let vm = RequestsVM()
    vm.viewState = .loaded
    vm.requestList =  Request.mocklist

    return NavigationStack {
        RequestsListView(vm: vm) // ✅ use the actual instance you configured
    }
}

