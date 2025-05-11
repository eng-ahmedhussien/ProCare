//
//  ProCareApp.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI

@main
struct ProCareApp: App {
    @StateObject var authManager = AuthManager()
    @StateObject var appRouter: AppRouter = AppRouter()
    @StateObject var appPopUpManger: AppPopUp = AppPopUp()
    @StateObject var locationManager = LocationManager()
    @StateObject var profileVM = ProfileVM()
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    LoadingPage()
                } else {
                    RouterView()
                        .environmentObject(authManager)
                        .environmentObject(appRouter)
                        .environmentObject(locationManager)
                        .implementPopupView(using: appPopUpManger)
                        .id(authManager.isLoggedIn)
                        .environmentObject(profileVM)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }
    }
}


