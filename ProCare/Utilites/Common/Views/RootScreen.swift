//
//  RootView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI

struct RootScreen: View {
    @EnvironmentObject var auth: AuthManger
    
    var body: some View {
        if auth.isLoggedIn {
            RouterView()
        } else {
            LoginScreen()
        }
    }
}


#Preview {
    RootScreen()
}
