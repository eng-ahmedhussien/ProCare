//
//  ProfileApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import Foundation

protocol ProfileApiClintProtocol {
    func getProfile() async throws -> APIResponse<Profile>
    func deleteProfile() async throws -> APIResponse<Bool>
}

class ProfileApiClint : ApiClient<ProfileEndPoints>, ProfileApiClintProtocol {
    
    func getProfile() async throws -> APIResponse<Profile> {
        return try await request(ProfileEndPoints.getProfile)
    }
    
    func deleteProfile() async throws -> APIResponse<Bool>{
        return try await request(ProfileEndPoints.deleteProfile)
    }
}
