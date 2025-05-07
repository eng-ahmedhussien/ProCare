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
    func updateProfile(parameters: [String: Any]) async throws -> APIResponse<Profile>
    
    //MARK: Governorates & city
    func getGovernorates() async throws -> APIResponse<[Governorates]>
    func getCityByGovernorateId(id: Int) async throws -> APIResponse<[City]>
}

class ProfileApiClint : ApiClient<ProfileEndPoints>, ProfileApiClintProtocol {
    
    func getProfile() async throws -> APIResponse<Profile> {
        return try await request(ProfileEndPoints.getProfile)
    }
    
    func deleteProfile() async throws -> APIResponse<Bool>{
        return try await request(ProfileEndPoints.deleteProfile)
    }
    
    func updateProfile(parameters: [String: Any]) async throws -> APIResponse<Profile> {
        return try await request(ProfileEndPoints.updateProfile(params: parameters))
    }
    
    func getGovernorates() async throws -> APIResponse<[Governorates]> {
        return try await request(ProfileEndPoints.getGovernorates)
    }
    
    func getCityByGovernorateId(id: Int) async throws -> APIResponse<[City]> {
        return try await request(ProfileEndPoints.getCityByGovernorateId(id: id))
    }
}
