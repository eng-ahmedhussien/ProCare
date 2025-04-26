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
    @Published var subCategories: [NursingServices] = []
    
    private let homeApiClint: HomeApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(homeApiClint: HomeApiClintProtocol = HomeApiClint()) {
        self.homeApiClint = homeApiClint
    }
    
    // MARK: - API Methods
    func getCategories(onUnauthorized: @escaping () -> Void) async {
        viewState = .loading
        do {
            let response = try await homeApiClint.categories()
            if let data = response.data {
                viewState = .loaded
                self.categories = data
            } else {
                debugPrint("HomeVM: Response received but no user data")
            }
        }
        catch {
            if let apiError = error as? APIResponseError, apiError.status == 401 {
                debugPrint("HomeVM: Unauthorized error detected")
                onUnauthorized()
            } else {
                debugPrint("HomeVM: Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    
    func getSubCategories(id: Int) async {
        viewState = .loading
        do {
            let response = try await homeApiClint.subCategories(id: id)
            if let data = response.data {
                viewState = .loaded
                self.subCategories = data
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
}
