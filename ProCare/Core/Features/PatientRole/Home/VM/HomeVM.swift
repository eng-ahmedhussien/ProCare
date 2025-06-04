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


