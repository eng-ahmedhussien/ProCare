//
//  NuresApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 30/05/2025.
//

import Foundation

protocol NurseApiClintProtocol{
    func updateLocation(parameters: [String: Any]) async throws -> APIResponse<NurseProfile>
    func changeStatus(isBusy: Bool) async throws -> APIResponse<Bool>
}

class NurseApiClint : ApiClient<NuresProfileEndPoints>, NurseApiClintProtocol {
    
    func updateLocation(parameters: [String: Any]) async throws -> APIResponse<NurseProfile> {
        return try await request(.updateLocation(parameters: parameters))
    }
    
    func changeStatus(isBusy: Bool) async throws -> APIResponse<Bool> {
        return try await request(.changeStatus(isBusy: isBusy))
    }
}

