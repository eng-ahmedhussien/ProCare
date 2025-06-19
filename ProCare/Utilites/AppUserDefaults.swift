//
//  AppUserDefaults.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import Foundation

class AppUserDefaults {
    private let defaults = UserDefaults.standard

    static let shared = AppUserDefaults()

    private init() {}

    func set<T>(_ value: T, forKey key: AppUserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func get<T>(forKey key: AppUserDefaultsKey) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }

    func remove(forKey key: AppUserDefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }

    func setCodable<T: Codable>(_ value: T, forKey key: AppUserDefaultsKey) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key.rawValue)
        }
    }

    func getCodable<T: Codable>(_ type: T.Type, forKey key: AppUserDefaultsKey) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension AppUserDefaults{
    enum AppUserDefaultsKey: String {
       // case authToken = "auth_token"
        case userData = "user_data"
        case profileData = "profile_data"
        case appLanguage = "app_language"
    }
}


