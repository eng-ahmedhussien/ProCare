//
//  AuthManger.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation
import Security
import SwiftUI

//final class AuthManager: ObservableObject {
//    static let shared = AuthManager()
//
//    @Published private(set) var token: String?
//    @Published private(set) var userData: UserDataLogin?
//
//    private init() {
//        self.token = UserDefaults.standard.string(forKey: "auth_token")
//
//        if let data = UserDefaults.standard.data(forKey: "user_data"),
//           let decoded = try? JSONDecoder().decode(UserDataLogin.self, from: data) {
//            self.userData = decoded
//        }
//    }
//
//    var isLoggedIn: Bool {
//        return token != nil
//    }
//
//    func saveToken(_ token: String) {
//        self.token = token
//        UserDefaults.standard.set(token, forKey: "auth_token")
//    }
//
//    func saveUserData(_ userData: UserDataLogin) {
//        self.userData = userData
//        if let encoded = try? JSONEncoder().encode(userData) {
//            UserDefaults.standard.set(encoded, forKey: "user_data")
//        }
//    }
//
//    func getToken() -> String? {
//        return token
//    }
//
//    func getUserData() -> UserDataLogin? {
//        return userData
//    }
//
//    func logout() {
//        token = nil
//        userData = nil
//        UserDefaults.standard.removeObject(forKey: "auth_token")
//        UserDefaults.standard.removeObject(forKey: "user_data")
//    }
//}

final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var token: String?
    @Published private(set) var userData: UserDataLogin?

    private init() {
        token = AppUserDefaults.shared.get(forKey: .authToken)
        userData = AppUserDefaults.shared.getCodable(UserDataLogin.self, forKey: .userData)
    }

    var isLoggedIn: Bool {
        return token != nil
    }

    func saveToken(_ token: String) {
        self.token = token
        AppUserDefaults.shared.set(token, forKey: .authToken)
    }

    func saveUserData(_ userData: UserDataLogin) {
        self.userData = userData
        AppUserDefaults.shared.setCodable(userData, forKey: .userData)
    }

    func getToken() -> String? {
        return token
    }

    func getUserData() -> UserDataLogin? {
        return userData
    }

    func logout() {
        token = nil
        userData = nil
        AppUserDefaults.shared.remove(forKey: .authToken)
        AppUserDefaults.shared.remove(forKey: .userData)
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

