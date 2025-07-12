//
//  HomeVM.swift
//  ProCare
//
//  Created by ahmed hussien on 14/04/2025.
//

import Combine
import Foundation
import CoreLocation


// MARK: - Home View Model
@MainActor
class HomeVM: ObservableObject {

    @Published private(set) var loadingState: ViewState = .idle
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
    private let pageSize = 10
    //MARK: - reservation
    @Published  var date: Date = Date()
    @Published  var time: Date = Date()
    @Published  var note: String = ""
    //MARK: - Nurses
    @Published var nurseList: [Nurse] = []
    
    private let apiClient: HomeApiClintProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: HomeApiClintProtocol = HomeApiClint()) {
        self.apiClient = apiClient
    }
    
 
}
//MARK: - Categories
extension HomeVM{
    // MARK: - Public Methods
    
    /// Fetches all available categories
    /// - Parameter onUnauthorized: Callback to handle unauthorized access
    func fetchCategories(onUnauthorized: @escaping () -> Void) async {
        loadingState = .loading
            do {
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
        showToast(error.localizedDescription, appearance: .error)
        loadingState = .failed(error.localizedDescription)
    }
    
    /// Resets the view model state
    func reset() {
        loadingState = .idle
        categories.removeAll()
        subCategories.removeAll()
    }
}
//MARK: - services
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
//MARK: - reservation
extension HomeVM{
    func submitReservation(onSuccess: @escaping () -> Void) async {
        let patientData = KeychainHelper.shared.getData(Profile.self, forKey: .profileData)
        let parameters: [String : Any] = [
            "date": "\(date.toAPIDateString())",
            "time": "\(time.toAPITimeString())",
              "note": note,
            "patientId": patientData?.id ?? "",
            "addressId": patientData?.addressId ?? 0
        ]
        
        do {
            let response = try await apiClient.reservation(parameters: parameters)
            if let data = response.data {
                if data {
                    showToast(response.message ?? "", appearance: .success)
                    onSuccess()
                }else{
                    showToast(response.message ?? "", appearance: .error)
                }
            } else {
                debugPrint("Response received but no service data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
        
    }
}
//MARK: - Nurses
extension HomeVM {
    // MARK: - API Methods
    func fetchNurses(loadType: LoadType) async {
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
        
        let location = LocationManager.shared.location ?? CLLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let parameters: [String:Any] = [
            "pageNumber": "\(pageNumber)",
            "pageSize": "\(pageSize)",
            "searchKey": "",
            "cityId": "0",
            "latitude": lat,
            "longitude": lon
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
                paginationViewState = nurseList.isEmpty ? .empty : .loaded
            } else {
                paginationViewState = nurseList.isEmpty ? .empty : .loaded
            }
        } catch {
            paginationViewState = .error(error.localizedDescription)
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}
//MARK: - Request
extension HomeVM{
    // MARK: - API Methods
    func submitRequest(Parameters: [String : Any],completion: @escaping () -> Void) async {
        do {
            let response = try await apiClient.submitRequest(Parameters: Parameters)
            switch response.status {
            case .Success:
                showToast(response.message ?? "لقد استلمنا طلبك بنجاح.",appearance: .success)
                completion()
            case .Error , .AuthFailure, .Conflict:
                showToast(response.message ?? "", appearance: .error)
            case .none:
                return
            }
           
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
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


