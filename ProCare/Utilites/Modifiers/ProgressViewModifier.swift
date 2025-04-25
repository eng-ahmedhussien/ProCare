//
//  ProgressViewModifier.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import SwiftUI


struct ProgressViewStyle: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(1.5)
    }
}

extension  View {
    func appProgressStyle(color: Color = .white) -> some View {
        modifier(ProgressViewStyle(color: color))
    }
}
