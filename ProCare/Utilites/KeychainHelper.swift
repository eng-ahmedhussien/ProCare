//
//  KeychainHelper.swift
//  ProCare
//
//  Created by ahmed hussien on 18/06/2025.
//
import SwiftUI
import KeychainSwift

class KeychainHelper {
    static let shared = KeychainHelper()
    let keychain = KeychainSwift()
    
    private init() {}

    //MARK: Low level Handling
     func set(_ token: String, forKey key: KeychainKey) {
         keychain.set(token, forKey: key.rawValue)
    }
    
    func set<T: Codable>(_ value: T, forKey key: KeychainKey) {
        if let data = try? JSONEncoder().encode(value) {
            keychain.set(data, forKey: key.rawValue)
        }
    }
    
    func get(forKey key: KeychainKey) -> String? {
        keychain.get(key.rawValue)
    }
    
    func getData<T: Codable>(_ type: T.Type, forKey key: KeychainKey) -> T? {
        guard let data = keychain.getData(key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
     func delete(forKey key: KeychainKey) {
         keychain.delete(key.rawValue)
    }

}

extension KeychainHelper{
    enum KeychainKey: String {
        case authToken = "auth_token"
        case deviceToken = "device_token"
        case userData = "user_data"
        case profileData = "profile_data"
    }
}
