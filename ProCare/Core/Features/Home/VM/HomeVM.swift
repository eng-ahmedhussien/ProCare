//
//  HomeVM.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Combine

@MainActor
class HomeVM: ObservableObject {
    // MARK: - Published Properties
    @Published var viewState: ViewState = .empty
    @Published var categories: [Category] = []
    
    private let homeApiClint: HomeApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(homeApiClint: HomeApiClintProtocol = HomeApiClint()) {
        self.homeApiClint = homeApiClint
    }
    
    // MARK: - API Methods
    func getCategories() async {
        viewState = .loading
        do {
            let response = try await homeApiClint.categories()
            if let _ = response.data {
                viewState = .loaded
                self.categories = response.data ?? []
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}
