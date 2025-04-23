//
//  ProCareApp.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI

@main
struct ProCareApp: App {
    @StateObject var authManager = AuthManager.shared
    @StateObject var appRouter: AppRouter = AppRouter()
    @StateObject var appPopUpManger: AppPopUpManger = AppPopUpManger()
    
    var body: some Scene {
        WindowGroup {
           RouterView()
                .environmentObject(authManager)
                .environmentObject(appRouter)
                .implementPopupView(using: appPopUpManger)
                .id(authManager.isLoggedIn)
        }
    }
}
