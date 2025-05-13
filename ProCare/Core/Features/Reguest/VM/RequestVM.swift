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
    func submitRequest(Parameters: [String : Any]) async {
        do {
            let response = try await apiClient.submitRequest(Parameters: Parameters)
            if let _ = response.data {
                
                
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}
