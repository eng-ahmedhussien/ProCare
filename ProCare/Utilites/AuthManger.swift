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
@MainActor
class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userDataLogin: UserDataLogin? = nil

    private let defaults = AppUserDefaults.shared
    private let keychainHelper = KeychainHelper.shared

    init() {
        loadUserData()
    }
    
    private func loadUserData() {
        if let savedUserData = defaults.getCodable(UserDataLogin.self, forKey: .userData) {
            self.userDataLogin = savedUserData
            self.isLoggedIn = (savedUserData.token?.isEmpty == false)
        } else {
            self.isLoggedIn = false
        }
    }
    
    func login(userDataLogin: UserDataLogin) {
        self.userDataLogin = userDataLogin
        self.isLoggedIn = userDataLogin.token?.isEmpty == false
        defaults.setCodable(userDataLogin, forKey: .userData)
       // defaults.set(userDataLogin.token ?? "", forKey: .authToken)
        keychainHelper.set(userDataLogin.token ?? "", forKey: .authToken)
    }
    
    func logout() {
        defaults.remove(forKey: .userData)
       // defaults.remove(forKey: .authToken)
        defaults.remove(forKey: .profileData)
        keychainHelper.delete(forKey: .authToken)
        self.userDataLogin = nil
        self.isLoggedIn = false
    }
}

