    //
    //  ReviewVM.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 14/07/2025.
    //

import Foundation
import SwiftUI
import Combine

@MainActor
class ReviewVM: ObservableObject {
        // MARK: - Published Properties
    @Published var requestId: String?
    
    private let apiClient: ReviewApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ReviewApiClintProtocol = ReviewApiClint()) {
        self.apiClient = apiClient
    }
    
        // MARK: - API Methods
    func getLastRequestIdNotReviewed(completion: @escaping (String) -> Void) async {
        do {
            let response = try await apiClient.getLastRequestIdNotReviewed()
            if let data = response.data {
                requestId = data
                completion(data)
            } else {
                debugPrint("Response received but no user data")
            }
        }catch let error as APIResponseError where error.status == 401 {
           
        }catch {
            showToast("\(error.localizedDescription)", appearance: .error)
            debugPrint("\(error.localizedDescription)")
        }
    }
    
    func AddReview(rating: Int, comment: String,completion: @escaping () -> Void) async {
        let parameters: [String:Any] = [
            "rating": rating,
            "comment": comment,
            "requestId": requestId ?? ""
        ]
        
        do {
            let response = try await apiClient.AddReview(parameters: parameters)
            if let data = response.data, data {
                completion()
            } else {
                showToast(response.message ?? "", appearance: .error)
            }
        } catch {
            showToast("\(error.localizedDescription)", appearance: .error)
            debugPrint("\(error.localizedDescription)")
        }
    }
    
    func cancelReviewByRequestId() async {
        guard let requestId = requestId else { return }
        do {
            let response = try await apiClient.cancelReviewByRequestId(requestId: requestId)
            if let data = response.data, data {
         
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
}
