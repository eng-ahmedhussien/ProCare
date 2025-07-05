//
//  PharmacyVM.swift
//  ProCare
//
//  Created by ahmed hussien on 09/06/2025.
//
import SwiftUI
import Combine

@MainActor
class PharmaciesVM: ObservableObject {
    
    @Published var pharmacies: [PharmacyItem] = []
    @Published var viewState: PaginationViewState = .initialLoading
    
    private var pageNumber = 1
    private let pageSize = 10
    var hasNextPage = true
    
    private let apiClient: PharmacyApiClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: PharmacyApiClientProtocol = PharmacyApiClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func fetchPharmacies(loadType: LoadType) async {
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
            "pageSize": "\(pageSize)",
            "searchKey": "",
            "cityId": "0"
        ]
        
        //try? await Task.sleep(nanoseconds: 600_000_000) // 0.3s
        
        do {
            let response = try await apiClient.getPharmacies(parameters: parameters)
            if let data = response.data {
                let newItems = data.items
                
                if pageNumber == 1 {
                    pharmacies = newItems
                } else {
                    pharmacies.append(contentsOf: newItems)
                }
                
                hasNextPage = data.hasNextPage
                pageNumber += 1
                viewState = pharmacies.isEmpty ? .empty : .loaded
            } else {
                viewState = pharmacies.isEmpty ? .empty : .loaded
            }
        } catch {
            viewState = .error(error.localizedDescription)
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func resetPaging() {
        pageNumber = 1
        hasNextPage = true
        pharmacies = []
    }
}
