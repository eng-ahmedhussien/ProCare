//
//  ToastStyle.swift
//  ProCare
//
//  Created by ahmed hussien on 14/05/2025.
//


import SwiftUI

enum ToastStyle: CaseIterable {
    case success, error, warning, info

    var themeColor: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}
