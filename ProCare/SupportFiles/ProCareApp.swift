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
    @StateObject var toastManager = ToastManager.shared
    @State private var isLoading = true
    @Environment(\.colorScheme) var colorScheme

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
                        .toastView(toast: $toastManager.toast)
                }
            }           
            .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color.clear)
            .task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                isLoading = false
            }
        }
    }
}


