//
//  ProCareApp.swift
//  ProCare
//
//  Created by ahmed hussien on 21/03/2025.
//

import SwiftUI

@main
struct ProCareApp: App {
    var body: some Scene {
        WindowGroup {
           // RootScreen()
//            NavigationStack{
//                PhoneScreen()
//            }
           RouterView()
                .environmentObject(AuthManger.shared)
        }
    }
}
