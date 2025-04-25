//
//  NurseEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import SwiftUI
import Combine

class NursesVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var nurseList: [Nurse] = []
    @Published var viewState: ViewState = .loading
    @Published var isLoading = false
    @Published var hasNextPage = true
    @Published var pageNumber = 1
    
    private let pageSize = 10
    private var cancellables: Set<AnyCancellable> = []
    private let apiClient: NursesApiClintProtocol
    
    init(apiClient: NursesApiClintProtocol = NursesApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    @MainActor
    func fetchNurses() async {
        guard  hasNextPage else { return }
        viewState = .loading
       // try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        let parameters = [
            "pageNumber": "\(pageNumber)",
            "pageSize": "\(pageSize)",
            "searchKey": "",
            "cityId": "\(0)"
        ]
        
        do {
            let response = try await apiClient.getAllNurses(parameters: parameters)
            if let data = response.data {
                nurseList.append(contentsOf: data.items ?? [])
                hasNextPage = data.hasNextPage ?? false
                pageNumber += 1
                viewState = .loaded
            }
            else if nurseList.isEmpty {
                viewState = .empty
            }else {
                viewState = .loaded
                debugPrint("Response received but no user data")
            }
        } catch {
            viewState = .empty
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func reset() {
        pageNumber = 1
        nurseList = []
        hasNextPage = true
        viewState = .loaded
    }
}
