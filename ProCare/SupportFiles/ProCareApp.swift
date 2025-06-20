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
    @StateObject var locationManager = LocationManager()
    @StateObject var profileVM = ProfileVM()
    @StateObject var ordersVM =  OrdersVM()
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
                        .id(authManager.isLoggedIn)
                        .environmentObject(profileVM)
                        .environmentObject(ordersVM)
                        .popupHost()
      
                }
            }
            .task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                isLoading = false
            }
        }
    }
}


