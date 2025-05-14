//
//  RequestVM.swift
//  ProCare
//
//  Created by ahmed hussien on 12/05/2025.
//

import SwiftUI
import Combine

class RequestVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var servicesIds: [ServiceItem] = []
    
    private let apiClient: RequestApiClientProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: RequestApiClientProtocol = RequestApiClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func submitRequest(Parameters: [String : Any],completion: @escaping () -> Void) async {
        do {
            let response = try await apiClient.submitRequest(Parameters: Parameters)
            switch response.status {
            case .Success:
                showAppMessage("request crated", appearance: .success, position: .top)
                completion()
            case .Error:
                showAppMessage(response.message, appearance: .error, position: .top)
            case .AuthFailure:
                showAppMessage(response.message, appearance: .error, position: .top)
            case .Conflict:
                showAppMessage(response.message, appearance: .error, position: .top)
            }
           
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}
