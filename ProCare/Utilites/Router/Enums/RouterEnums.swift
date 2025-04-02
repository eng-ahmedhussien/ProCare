//
//  RouterEnums.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 19/03/2025.
//

import Foundation
import SwiftUI

enum Screen: Identifiable, Hashable {
    case tapbar
    case RootScreen

    
    var id: Self { return self }
}

enum SheetView: Identifiable, Hashable {
    case detailTask
    
    var id: Self { return self }
}

enum FullScreen: Identifiable, Hashable {
    case otpScreen
    case tapbarFullScreen

    var id: Self {  self }
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
