//
//  SignUpVMTests.swift
//  ProCare
//
//  Created by ahmed hussien on 17/06/2025.
//

import XCTest
@testable import ProCare


final class SignUpApiClint: ApiClient<SignUpEndpoints>, SignUpApiClintProtocol {
    func signUp(parameters: [String: String]) async throws -> APIResponse<String>{
        return try await request(SignUpEndpoints.signUp(parameters: parameters))
    }
}

final class SignUpApiIntegrationTests: XCTestCase {

    func testRealSignUpAPI() async throws {
        // Arrange
        let client = SignUpApiClint()

        let parameters = [
            "firstName": "Test",
            "lastName": "User",
            "phoneNumber": "+201553855459",
            "password": "Test@1234",
            "confirmPassword": "Test@1234"
        ]

        do {
            let response = try await client.signUp(parameters: parameters)

            if response.status == .Success {
                XCTAssertNotNil(response.data)
                print("✅ API Success: \(response)")
            } else {
                XCTFail("❌ API responded with status \(response.status?.rawValue ?? -1): \(response.message ?? "")")
            }
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Key '\(key)' not found:", context.debugDescription)
            XCTFail()
        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ Type '\(type)' mismatch:", context.debugDescription)
            XCTFail()
        } catch let DecodingError.valueNotFound(value, context) {
            print("❌ Value '\(value)' not found:", context.debugDescription)
            XCTFail()
        } catch {
            XCTFail("❌ API call threw error: \(error)")
        }
    }
}
