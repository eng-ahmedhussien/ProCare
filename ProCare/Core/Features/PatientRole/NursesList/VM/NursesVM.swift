//
//  NurseEndPoints.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import SwiftUI
import Combine

@MainActor
class NursesVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var nurseList: [Nurse] = []
    @Published var viewState: PaginationViewState = .initialLoading
    
    private var pageNumber = 1
    private let pageSize = 10
    var hasNextPage = true
    private let apiClient: NursesApiClintProtocol

    init(apiClient: NursesApiClintProtocol = NursesApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func fetchNurses(loadType: LoadType) async {
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
            let response = try await apiClient.getAllNurses(parameters: parameters)
            if let data = response.data {
                let newItems = data.items ?? []
                
                if pageNumber == 1 {
                    nurseList = newItems
                } else {
                    nurseList.append(contentsOf: newItems)
                }
                
                hasNextPage = data.hasNextPage ?? false
                pageNumber += 1
                viewState = nurseList.isEmpty ? .empty : .loaded
            } else {
                viewState = nurseList.isEmpty ? .empty : .loaded
            }
        } catch {
            viewState = .error(error.localizedDescription)
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func resetPaging() {
        pageNumber = 1
        hasNextPage = true
        nurseList = []
    }
}
