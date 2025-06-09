//
//  HomeVM.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Combine
import Foundation


// MARK: - Home View Model
@MainActor
class HomeVM: ObservableObject {

    @Published private(set) var loadingState: LoadingState = .idle
    @Published var categories: [Category] = []
    @Published var subCategories: [NursingServices] = []
    
    //MARK: services
    @Published var visitServicePrice: Int?
    @Published var serviceItem: [ServiceItem] = []
    @Published var selectedServices: [ServiceItem] = [] {
        didSet {
            totalPrice = selectedServices.reduce(0) { $0 + ($1.price ?? 0) }
        }
    }
    @Published var paginationViewState: PaginationViewState = .initialLoading
    @Published var hasNextPage = true
    @Published var pageNumber = 1
    @Published var totalPrice: Int = 0
    private let pageSize = 5
    
    private let apiClient: HomeApiClintProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: HomeApiClintProtocol = HomeApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    /// Fetches all available categories
    /// - Parameter onUnauthorized: Callback to handle unauthorized access
    func fetchCategories(onUnauthorized: @escaping () -> Void) {
        Task {
            do {
                loadingState = .loading
                let response = try await apiClient.categories()
                
                guard let data = response.data else {
                    loadingState = .failed("No categories available")
                    return
                }
                
                categories = data
                loadingState = .loaded
                
            } catch let error as APIResponseError where error.status == 401 {
                handleUnauthorizedError(onUnauthorized)
            } catch {
                handleError(error)
            }
        }
    }
    
    /// Fetches sub-categories for a specific category
    /// - Parameter id: Category identifier
    func fetchSubCategories(for id: Int) {
        Task {
            do {
                loadingState = .loading
                let response = try await apiClient.subCategories(id: id)
                
                guard let data = response.data else {
                    loadingState = .failed("No sub-categories available")
                    return
                }
                
                subCategories = data
                loadingState = .loaded
                
            } catch {
                handleError(error)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleUnauthorizedError(_ onUnauthorized: () -> Void) {
        loadingState = .failed("Unauthorized access")
        onUnauthorized()
    }
    
    private func handleError(_ error: Error) {
        loadingState = .failed(error.localizedDescription)
    }
    
    /// Resets the view model state
    func reset() {
        loadingState = .idle
        categories.removeAll()
        subCategories.removeAll()
    }
}

//MARK: sevices
extension HomeVM {
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
            let response = try await apiClient.getServices(parameters: parameters, id: id)
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
    
    func getVisitServicePrice() async {
        do {
            let response = try await apiClient.getVisitService()
            if let data = response.data, let price = data.price {
                visitServicePrice = price
            } else {
                debugPrint("Response received but no service data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func resetPaging() {
        pageNumber = 1
        serviceItem = []
        hasNextPage = true
        paginationViewState = .loaded
    }
    
    
}

// MARK: - Preview Helpers
#if DEBUG
extension HomeVM {
    static var preview: HomeVM {
        let vm = HomeVM()
        vm.categories = Category.mockCategories
        vm.loadingState = .loaded
        return vm
    }
}
#endif


