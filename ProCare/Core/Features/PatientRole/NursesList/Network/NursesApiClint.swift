//
//  NursesApiClint.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import Foundation

protocol NursesApiClintProtocol {
    func getAllNurses(parameters: [String: String]) async throws -> APIResponse<NurseList>
    
}

class NursesApiClint : ApiClient<NurseEndPoints>, NursesApiClintProtocol {
    
    func getAllNurses(parameters: [String: String]) async throws -> APIResponse<NurseList> {
        return try await request(NurseEndPoints.getAllNurses(parameters: parameters))
    }
}
