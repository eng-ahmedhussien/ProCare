//
//  PopupManager.swift
//  ProCare
//
//  Created by ahmed hussien on 01/06/2025.
//
import SwiftUI

final class PopupManager: ObservableObject {
    static let shared = PopupManager()

    @Published var alert: AlertData?
    @Published var toast: ToastData?
    @Published var customPopup: CustomPopupData?

    private init() {}

    func showAlert(title: String, message: String, button: String = "OK", action: (() -> Void)? = nil) {
        alert = AlertData(title: title, message: message, button: button, action: action)
    }

    func showToast(message: String, style: ToastStyle, duration: TimeInterval = 3.0,position: ToastPosition) {
        toast = ToastData(style: style, message: message, duration: duration,position: position)
    }

    func showCustomPopup<Content: View>(@ViewBuilder content: () -> Content) {
        customPopup = CustomPopupData(content: AnyView(content()))
    }

    func dismissCustomPopup() {
        customPopup = nil
    }
}

struct AlertData: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    let button: String
    let action: (() -> Void)?

    static func ==(lhs: AlertData, rhs: AlertData) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.message == rhs.message &&
        lhs.button == rhs.button
    }
}

struct CustomPopupData: Identifiable, Equatable {
    let id = UUID()
    let content: AnyView

    static func ==(lhs: CustomPopupData, rhs: CustomPopupData) -> Bool {
        lhs.id == rhs.id
    }
}

struct ToastData: Equatable {
    var style: ToastStyle
    var message: String
    var duration: TimeInterval = 3
    var width: CGFloat = .infinity
    var position: ToastPosition = .top
}
