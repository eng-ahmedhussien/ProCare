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
    
    var body: some View {
        ZStack {
            content
        }
        .onAppear {
            if vm.requestList.isEmpty {
                Task {
                    await vm.fetchRequests(loadType: .initial)
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
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                Text("Error: \(message)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Button("Retry") {
                    Task {
                        await vm.fetchRequests(loadType: .initial)
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
            longitude: "30.033333",
            latitude: "31.233334",
            nurseLongitude: "30.033334",
            nurseLatitude: "31.233335",
            createdAt: "2024-01-01T10:00:00Z",
            totalPrice: 250
        ),
        Order(
            id: "2",
            nurseName: "Ahmed Ali",
            nursePicture: nil,
            phoneNumber: "01123456789",
            nurseId: "102",
            status: "pending",
            speciality: "Emergency Nurse",
            longitude: "30.044420",
            latitude: "31.235712",
            nurseLongitude: "30.044421",
            nurseLatitude: "31.235713",
            createdAt: "2024-01-02T14:30:00Z",
            totalPrice: 200
        )
    ]

    return NavigationStack {
        OrdersListView(vm: vm) // ✅ use the actual instance you configured
    }
}
