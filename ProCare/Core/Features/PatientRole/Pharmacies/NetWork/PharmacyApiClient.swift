import Foundation
import Combine

protocol PharmacyApiClientProtocol {
    func getPharmacies(parameters: [String: String]) async throws -> APIResponse<PharmacyPagedResult>
}

class PharmacyApiClient:ApiClient<PharmacyEndpoints>,PharmacyApiClientProtocol {
    func getPharmacies(parameters: [String: String]) async throws -> APIResponse<PharmacyPagedResult> {
        return try await request(PharmacyEndpoints.getPharmacies(parameters: parameters))
    }
} 
