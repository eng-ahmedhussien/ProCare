//
//  RequestsVM.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import SwiftUI

@MainActor
class RequestsVM: ObservableObject {
    // MARK: - Published Properties
    @Published var requestList: [Request] = []
    @Published var currentRequest: Request?
    @Published var viewState: PaginationViewState = .initialLoading
    
    var hasNextPage = true
    private var pageNumber = 1
    private let pageSize = 10
    private let apiClient: PatientRequestApiClintProtocol

    init(apiClient: PatientRequestApiClintProtocol = PatientRequestApiClint()) {
        self.apiClient = apiClient
    }
}
// MARK: - API Methods
extension RequestsVM{
   
    @MainActor
    func fetchCurrentRequest(onUnauthorized: @escaping () -> Void = {}) async {
        do {
            let response = try await apiClient.getCurrentRequest()
            if let data = response.data {
                currentRequest = data
            } else {
                currentRequest = nil
                debugPrint("Response received but no user data")
            }
        } catch {
            if let apiError = error as? APIResponseError, apiError.status == 401 {
                debugPrint("HomeVM: Unauthorized error detected")
                onUnauthorized()
            } else {
                debugPrint("HomeVM: Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRequests(loadType: LoadType,onUnauthorized: @escaping () -> Void = {}) async {
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
        
        //try? await Task.sleep(nanoseconds: 600_000_000) // 0.3s
        
        do {
            let response = try await apiClient.getPreviousRequests(parameters: parameters)
            if let data = response.data {
                let newItems = data.items ?? []
                
                if pageNumber == 1 {
                    requestList = newItems
                } else {
                    requestList.append(contentsOf: newItems)
                }
                
                hasNextPage = data.hasNextPage ?? false
                pageNumber += 1
                viewState = requestList.isEmpty ? .empty : .loaded
            } else {
                viewState = requestList.isEmpty ? .empty : .loaded
            }
        } catch {
            viewState = .error(error.localizedDescription)
            if let apiError = error as? APIResponseError, apiError.status == 401 {
                debugPrint("HomeVM: Unauthorized error detected")
                onUnauthorized()
            } else {
                debugPrint("HomeVM: Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    
    private func resetPaging() {
        pageNumber = 1
        hasNextPage = true
        requestList = []
    }
    
    func rejectRequest(id: String) async {
        do {
            let response = try await apiClient.cancelRequest(id: id)
            if let data = response.data {
                if data {
                    Task{
                        await fetchCurrentRequest()
                    }
                }
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
   func approveRequest(id: String) async {
       do {
           let response = try await apiClient.approveRequest(id: id)
           if let data = response.data {
               if data {
                   Task{
                     //  await fetchCurrentRequest()
                   }
               }
           }
       } catch {
           debugPrint("Unexpected error: \(error.localizedDescription)")
       }
   }
}

