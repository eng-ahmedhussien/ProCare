//
//  NuresProfileVM.swift
//  ProCare
//
//  Created by ahmed hussien on 30/05/2025.
//

import SwiftUI
import Combine


class NuresProfileVM: ObservableObject {
    
    // MARK: - Published Properties
    private let apiClient: NurseApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: NurseApiClintProtocol = NurseApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func updateLocation(lat : String, lon : String) async {
        
        let parameters: [String: Any] = [
            "latitude": lat,
            "longitude": lon
        ]
        
        do {
            let response = try await apiClient.updateLocation(parameters: parameters)
            if let _ = response.data {
                showToast("Location updated successfully!", appearance: .success)

            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            showToast("Unexpected error: \(error.localizedDescription)", appearance: .error)
        }
    }
    
    func changeStatus(isBusy: Bool, onSuccess: ((Bool) -> Void)? = nil) async {
        do {
            let response = try await apiClient.changeStatus(isBusy: isBusy)
            if let responseData = response.data {
                switch responseData {
                case true:
                    showToast("Status updated successfully!", appearance: .success)
                    onSuccess?(true)
                case false:
                    showToast(" \(response.message ?? "")", appearance: .error)
                    onSuccess?(false)
                }
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            showToast("Unexpected error: \(error.localizedDescription)", appearance: .error)
        }
    }
}
