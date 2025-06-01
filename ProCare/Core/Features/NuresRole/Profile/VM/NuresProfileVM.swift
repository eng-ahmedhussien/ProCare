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
                showAppMessage("Location updated successfully!", appearance: .success)

            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            showAppMessage("Unexpected error: \(error.localizedDescription)", appearance: .error)
        }
    }
    
    func changeStatus(isBusy: Bool) async {
        do {
            let response = try await apiClient.changeStatus(isBusy: isBusy)
            if let _ = response.data {
               
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            showAppMessage("Unexpected error: \(error.localizedDescription)", appearance: .error)
        }
    }
}
