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
    
    var id: Self { return self }
}

enum SheetView: Identifiable, Hashable {
    case detailTask
    
    var id: Self { return self }
}

enum FullScreen: Identifiable, Hashable {
    case addHabit

    var id: Self { return self }
}

extension FullScreen {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .addHabit:
            hasher.combine("addHabit")
        }
    }
    
    // Conform to Equatable
    static func == (lhs: FullScreen, rhs: FullScreen) -> Bool {
        switch (lhs, rhs) {
        case (.addHabit, .addHabit):
            return true
        }
    }
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
