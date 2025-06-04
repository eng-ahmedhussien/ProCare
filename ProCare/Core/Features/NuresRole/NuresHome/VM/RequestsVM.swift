//
//  RequestsVM.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import SwiftUI

@MainActor
class RequestsVM: ObservableObject {
    // MARK: -  Request Properties
    @Published var requestList: [Request] = []
    @Published var currentRequest: Request?
    @Published var viewState: PaginationViewState = .initialLoading
    @Published var isApprovedRequest: Bool = false
    //MARK: - Report Properties
    @Published var report: Report?
    @Published var allDiseases: [Disease] = [] // Fill from API
    @Published var allServices: [ServiceItem] = [] // Fill from API
    @Published var drugs: String = ""
    @Published var notes: String = ""
    @Published var selectedDiseases: [Disease] = []
    @Published var selectedServices: [ServiceItem] = []
    @Published var totalRequest: Int = 0

    // MARK: - Pagination
    var hasNextPage = true
    private var pageNumber = 1
    private let pageSize = 10
    
    private let apiClient: PatientRequestApiClintProtocol
    
    init(apiClient: PatientRequestApiClintProtocol = PatientRequestApiClint()) {
        self.apiClient = apiClient
    }
}
// MARK: - Request API Methods
extension RequestsVM{
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
                   await fetchCurrentRequest()
               }
           }
       } catch {
           debugPrint("Unexpected error: \(error.localizedDescription)")
       }
   }
}
// MARK: - Report API Methods
extension RequestsVM {
    func fetchReportByPatientId(id: String) async {
        do {
            let response = try await apiClient.getReportByPatientId(id: id)
            if let data = response.data {
                report = data
            } else {
                debugPrint("Response received but no report data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    func addOrUpdateReport(completion: @escaping (Bool) -> Void) async {
        let parameters: [String : Any] = [
            "requestId": currentRequest?.id ?? "",
            "drugs": drugs,
            "notes": notes,
            "diseasesIds": selectedDiseases.map { $0.id },
            "serviceIds": selectedServices.map { $0.id }
        ]

        do {
            let response = try await apiClient.addOrUpdateReport(parameters: parameters)
            if let data = response.data {
                totalRequest = data
                completion(true)
            } else {
                debugPrint("Response received but no report data")
                completion(false)
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchDiseases() async {
        let parameters: [String: Any] = [
            "pageNumber": "0",
            "pageSize": "0" //
        ]
        do {
            let response = try await apiClient.getDeceases(parameters: parameters)
            if let data = response.data {
                allDiseases = data.items ?? []
            } else {
                debugPrint("Response received but no diseases data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }

    func fetchServices() async {
        let parameters: [String: Any] = [
            "pageNumber": "0",
            "pageSize": "0"
        ]
        do {
            let response = try await apiClient.getServices(parameters: parameters)
            if let data = response.data {
                allServices = data.pagedResult?.items ?? []
            } else {
                debugPrint("Response received but no services data")
            }
        } catch {
            if let apiError = error as? APIResponseError, apiError.status == 404 {
                // No report found, this is not a critical error
                debugPrint("No report found for this patient/request.")
                report = nil
            } else {
                debugPrint("Unexpected error: \(error.localizedDescription)")
            }
        }
    }

    func fetchAllDataAndFillReport(patientId: String) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchReportByPatientId(id: patientId) }
            group.addTask { await self.fetchDiseases() }
            group.addTask { await self.fetchServices() }
        }
        fillReportData()
    }
    
}
   
   //MARK: - Helpers
extension RequestsVM {
    func fillReportData() {
        guard let report = report else { return }
            
        drugs = report.drugs ?? ""
        notes = report.notes ?? ""
        selectedDiseases = report.diseases?.compactMap { disease in
            allDiseases.first(where: { $0.id == disease.id })
        } ?? []
        
        selectedServices = report.serviceIds?.compactMap { id in
            allServices.first(where: { $0.id == id })
        } ?? []
    }
}
