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
        content
    }
}

extension RootScreen{
    @ViewBuilder
    var content: some View {
        if authManager.isLoggedIn {
            switch authManager.userDataLogin?.role {
            case .Patient:
                TapBarView()
            case .Nurse:
                RequestsScreen()
            default:
                TapBarView()
            }
        } else {
            LoginScreen()
        }
    }
}


#Preview {
    RootScreen()
}
