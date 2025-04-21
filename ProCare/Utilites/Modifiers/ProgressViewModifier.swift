//
//  ProgressViewModifier.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import SwiftUI


struct ProgressViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
    }
}

extension  View {
    func appProgressStyle() -> some View {
        modifier(ProgressViewStyle())
    }
}
