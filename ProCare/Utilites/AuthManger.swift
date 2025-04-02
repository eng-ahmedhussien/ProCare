//
//  AuthManger.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation
import Security
import SwiftUI

class AuthManger: ObservableObject {
    static let shared = AuthManger()

    @AppStorage("auth_token") private var token: String?

    private init() {}

    func saveToken(_ token: String) {
        self.token = token
    }

    func getToken() -> String? {
        return token
    }

    func deleteToken() {
        token = nil
    }

    var isLoggedIn: Bool {
        return token != nil
    }

    func logout() {
        deleteToken()
    }
}

//class KeychainHelper {
//    static let shared = KeychainHelper()
//    
//    private init() {}
//
//    func saveToken(_ token: String, forKey key: String) {
//        let data = Data(token.utf8)
//        
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecValueData as String: data
//        ]
//        
//        SecItemDelete(query as CFDictionary) // Delete existing item if it exists
//        SecItemAdd(query as CFDictionary, nil)
//    }
//
//    func getToken(forKey key: String) -> String? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecReturnData as String: true,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//        
//        var dataTypeRef: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//        
//        if status == errSecSuccess, let data = dataTypeRef as? Data {
//            return String(data: data, encoding: .utf8)
//        }
//        return nil
//    }
//
//    func deleteToken(forKey key: String) {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key
//        ]
//        
//        SecItemDelete(query as CFDictionary)
//    }
//}

