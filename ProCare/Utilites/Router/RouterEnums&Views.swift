//
//  RouterEnums.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 19/03/2025.
//

import Foundation
import SwiftUI


extension AppRouter {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case.tapBar:
            TapBarView()
        case .RootScreen:
            RootScreen()
        case.otpScreen:
            OTPScreen()
        case.EmailScreen:
            EmailScreen()
        case .NewPasswordScreen(let phone, let resetToken):
            NewPasswordScreen(phone: phone, resetToken: resetToken)
        case .ChangePasswordScreen:
            ChangePasswordScreen()

        }
    }
    
    @ViewBuilder
    func build(_ sheet: SheetView) -> some View {
        switch sheet {
        case .detailTask:
           Text("empty sheet")
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreen) -> some View {
        switch fullScreenCover {
        case .otpScreen:
            OTPScreen()
        case.tapBarFullScreen:
            TapBarView()
        case .signUp:
            SignUPScreen()
        case .login:
            LoginScreen()
        case .NewPasswordScreen:
            NewPasswordScreen()
        }
    }

}

enum Screen: Identifiable, Hashable {
    case tapBar
    case RootScreen
    case otpScreen
    case EmailScreen
    case NewPasswordScreen(phone: String, resetToken: String)
    case ChangePasswordScreen

    var id: Self { return self }
}

enum SheetView: Identifiable, Hashable {
    case detailTask
    
    var id: Self { return self }
}

enum FullScreen: Identifiable, Hashable {
    case otpScreen
    case tapBarFullScreen
    case signUp
    case login
    case NewPasswordScreen

    var id: Self {  self }
}

// Wrapper for Any View Navigation
struct AnyViewContainer: Identifiable, Hashable {
    let id = UUID()
    let view: AnyView
    
    static func == (lhs: AnyViewContainer, rhs: AnyViewContainer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


//extension FullScreen {
//    // Conform to Hashable
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .otpScreen:
//            hasher.combine("otpScreen")
//        case .tapbar:
//            hasher.combine("tapbar")
//        }
//    }
//
//    // Conform to Equatable
//    static func == (lhs: FullScreen, rhs: FullScreen) -> Bool {
//        switch (lhs, rhs) {
//        case (.otpScreen, .otpScreen):
//            return true
//        case (.tapbar, .tapbar):
//            return true
//        case (.tapbar, .otpScreen):
//            <#code#>
//        case (.otpScreen, .tapbar):
//            <#code#>
//        }
//    }
//}
