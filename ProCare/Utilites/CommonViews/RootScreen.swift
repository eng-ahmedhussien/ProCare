//
//  RootView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI

struct RootScreen: View {
    @EnvironmentObject var authManager : AuthManager
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                    TapBarView()
            } else {
                LoginScreen()
            }
        }
    }
}


#Preview {
    RootScreen()
}
