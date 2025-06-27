//
//  OrdersVM.swift
//  ProCare
//
//  Created by ahmed hussien on 15/05/2025.
//
import SwiftUI

@MainActor
class OrdersVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var ordersList: [Order] = []
    @Published var currentOrder: Order?
    @Published var viewState: PaginationViewState = .initialLoading
    
    var hasNextPage = true
    private var pageNumber = 1
    private let pageSize = 10
    private let apiClient: OrdersApiClintProtocol

    init(apiClient: OrdersApiClintProtocol = OrdersApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    @MainActor
    func fetchCurrentOrder() async {
        do {
            let response = try await apiClient.getCurrentOrder()
            if let data = response.data {
                currentOrder = data
            } else {
                currentOrder = nil
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func fetchOrders(loadType: LoadType) async {
        switch loadType {
        case .initial:
            resetPaging()
            viewState = .initialLoading
        case .paging:
            guard hasNextPage else { return }
            viewState = .pagingLoading
        case .refresh:
            resetPaging()
            viewState = .refreshing
        }
        
        let parameters = [
            "pageNumber": "\(pageNumber)",
            "pageSize": "\(pageSize)"
        ]
        
        do {
            let response = try await apiClient.getPreviousOrders(parameters: parameters)
            if let data = response.data {
                let newItems = data.items ?? []
                
                if pageNumber == 1 {
                    ordersList = newItems
                } else {
                    ordersList.append(contentsOf: newItems)
                }
                
                hasNextPage = data.hasNextPage ?? false
                pageNumber += 1
                viewState = ordersList.isEmpty ? .empty : .loaded
            } else {
                viewState = ordersList.isEmpty ? .empty : .loaded
            }
        } catch {
            viewState = .error(error.localizedDescription)
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func resetPaging() {
        pageNumber = 1
        hasNextPage = true
        ordersList = []
    }
    
    func cancelOrder(id: String) async {
        do {
            let response = try await apiClient.cancelOrder(id: id)
            handleApiResponse(response)
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func handleApiResponse<T: Codable>(_ response: APIResponse<T>) {
        switch response.status {
        case .Success:
            if let data = response.data {
                if data as! Bool {
                    Task{
                        await fetchCurrentOrder()
                    }
                }
            }else{
                debugPrint("Response received but no user data")
            }
        case .Error, .AuthFailure, .Conflict:
            showToast(
                response.message ?? "network error",
                appearance: .error
            )
        case .none:
            break
        }
    }
}
