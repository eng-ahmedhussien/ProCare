//
//  AuthManger.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation
import Security
import SwiftUI

@MainActor
class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userDataLogin: UserDataLogin? = nil
    @Published var profileData: Profile? = nil

   // private let defaults = AppUserDefaults.shared
    private let keychainHelper = KeychainHelper.shared

    init() {
        loadUserData()
        loadProfileData()
    }
    
    
    private func loadUserData() {
        if let savedUserData = keychainHelper.getData(UserDataLogin.self, forKey: .userData),
           let token = savedUserData.token, !token.isEmpty {
            self.userDataLogin = savedUserData
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func loadProfileData() {
        guard let savedProfileData = keychainHelper.getData( Profile.self,forKey: .profileData) else {return}
        self.profileData = savedProfileData
    }
    
    func login(userDataLogin: UserDataLogin) {
        self.userDataLogin = userDataLogin
        self.isLoggedIn = userDataLogin.token?.isEmpty == false
        keychainHelper.set(userDataLogin, forKey: .userData)
        keychainHelper.set(userDataLogin.token ?? "", forKey: .authToken)
    }
    
    func logout() {
        keychainHelper.delete(forKey: .authToken)
        keychainHelper.delete(forKey: .userData)
        keychainHelper.delete(forKey: .profileData)
        self.userDataLogin = nil
        self.profileData = nil
        self.isLoggedIn = false
    }
}

