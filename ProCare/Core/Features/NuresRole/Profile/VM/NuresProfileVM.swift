//
//  NuresProfileVM.swift
//  ProCare
//
//  Created by ahmed hussien on 30/05/2025.
//

import SwiftUI
import Combine

@MainActor
class NuresProfileVM: ObservableObject {
    
    // MARK: - Published Properties
    private let apiClient: NurseApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: NurseApiClintProtocol = NurseApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func updateLocation(lat : Double, lon : Double) async {
        
        let parameters: [String: Any] = [
            "latitude": lat,
            "longitude": lon
        ]
        
        do {
            let response = try await apiClient.updateLocation(parameters: parameters)
            if let _ = response.data {
                showToast("\(response.message ?? "Success")", appearance: .success)
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
            handleApiResponse(response, onSuccess: onSuccess)
        } catch {
            showToast("Unexpected error: \(error.localizedDescription)", appearance: .error)
        }
    }
    
    private func handleApiResponse<T: Codable>(_ response: APIResponse<T>, onSuccess: ((Bool) -> Void)? = nil) {
            switch response.status {
            case .Success:
                if let responseData = response.data {
                    switch responseData as! Bool {
                    case true:
                        showToast("\(response.message ?? "")", appearance: .success)
                        onSuccess?(true)
                    case false:
                        showToast(" \(response.message ?? "")", appearance: .error)
                        onSuccess?(false)
                    }
                } else {
                    debugPrint("Response received but no user data")
                }
            case .Error, .AuthFailure, .Conflict:
                showToast(
                    response.message ?? "network error",
                    appearance: .error
                )
            case .none:
                break
            }
        }
}
