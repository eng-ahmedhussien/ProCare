//
//  ReviewApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 14/07/2025.
//

import Foundation

protocol ReviewApiClintProtocol {
    func getLastRequestIdNotReviewed() async throws -> APIResponse<String>
    func AddReview(parameters: [String: Any])  async throws ->  APIResponse<Bool>
    func cancelReviewByRequestId(requestId: String) async throws ->  APIResponse<Bool>
}

class ReviewApiClint: ApiClient<ReviewEndPoints>, ReviewApiClintProtocol {
    func getLastRequestIdNotReviewed() async throws -> APIResponse<String>{
        try await request(ReviewEndPoints.getLastRequestIdNotReviewed)
    }
    func AddReview(parameters: [String: Any])  async throws ->  APIResponse<Bool>{
        try await request(ReviewEndPoints.AddReview(parameters: parameters))
    }
    func cancelReviewByRequestId(requestId: String) async throws ->  APIResponse<Bool>{
        try await request(ReviewEndPoints.cancelReviewByRequestId(requestId: requestId))
    }
}
