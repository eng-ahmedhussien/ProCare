//
//  ToastPosition.swift
//  ProCare
//
//  Created by ahmed hussien on 14/05/2025.
//

import Foundation

enum ToastPosition {
    case top, center, bottom
}

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: CGFloat = .infinity
    var position: ToastPosition = .top // default position
}
