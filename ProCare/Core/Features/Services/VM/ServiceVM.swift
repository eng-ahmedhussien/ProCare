//
//  ServiceVM.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//

import SwiftUI
import Combine

@MainActor
class ServiceVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var services: ServiceData?
    @Published var serviceItem: [ServiceItem] = []
    @Published var selectedServices: [ServiceItem] = [] {
        didSet {
            totalPrice = selectedServices.reduce(0) { $0 + ($1.price ?? 0) }
        }
    }
    @Published var paginationViewState: PaginationViewState = .initialLoading
    @Published var isLoading = false
    @Published var hasNextPage = true
    @Published var pageNumber = 1
    @Published var totalPrice: Int = 0
    
    private let pageSize = 5
    private let apiClient: ServiceApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ServiceApiClintProtocol = ServiceApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func fetchServices(id: Int, loadType: LoadType) async {
           switch loadType {
           case .initial:
               resetPaging()
               paginationViewState = .initialLoading
           case .paging:
               guard hasNextPage else { return }
               paginationViewState = .pagingLoading
           case .refresh:
               resetPaging()
               paginationViewState = .refreshing
           }
           
           let parameters = [
               "pageNumber": "\(pageNumber)",
               "pageSize": "\(pageSize)",
               "searchKey": ""
           ]
           
           do {
               let response = try await apiClient.GetServices(parameters: parameters, id: id)
               if let data = response.data {
                   let items = data.pagedResult?.items ?? []
                   
                   if pageNumber == 1 {
                       serviceItem = items
                   } else {
                       serviceItem.append(contentsOf: items)
                   }
                   
                   hasNextPage = data.pagedResult?.hasNextPage ?? false
                   pageNumber += 1
                   paginationViewState = serviceItem.isEmpty ? .empty : .loaded
               } else {
                   paginationViewState = serviceItem.isEmpty ? .empty : .loaded
               }
           } catch {
               paginationViewState = .error(error.localizedDescription)
               debugPrint("Unexpected error: \(error.localizedDescription)")
           }
       }
    
    func resetPaging() {
        pageNumber = 1
        serviceItem = []
        hasNextPage = true
        paginationViewState = .loaded
    }
}
