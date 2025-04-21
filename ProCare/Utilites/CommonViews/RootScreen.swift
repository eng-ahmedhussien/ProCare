//
//  RootView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI

struct RootScreen: View {
    @StateObject var authManager = AuthManager.shared
    
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                // RouterView()
                TapBarView()
            } else {
                LoginScreen()
            }
        }
        .id(authManager.isLoggedIn)
    }
}


#Preview {
    RootScreen()
}
