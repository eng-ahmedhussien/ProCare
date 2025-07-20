//
//  PopupManager.swift
//  ProCare
//
//  Created by ahmed hussien on 01/06/2025.
//
import SwiftUI

@MainActor
final class PopupManager: ObservableObject {
    static let shared = PopupManager()

    @Published var alert: AlertData?
    @Published var toast: ToastData?
    @Published var customPopup: CustomPopupData?

    private init() {}

    func showAlert(title: String, message: String, button: String = "OK", action: (() -> Void)? = nil) {
        alert = AlertData(title: title, message: message, button: button, action: action)
    }

    func showToast(message: String, style: ToastStyle, duration: TimeInterval = 3.0, position: ToastPosition = .top) {
        toast = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.toast = ToastData(style: style, message: message, duration: duration, position: position)
        }
    }

//    func showCustomPopup<Content: View>(@ViewBuilder content: () -> Content) {
//        customPopup = CustomPopupData(content: AnyView(content()))
//    }
    
    func showCustomPopup<Content: View>(dismissOnTapOutside: Bool = false, @ViewBuilder content: () -> Content) {
            customPopup = CustomPopupData(content: AnyView(content()), dismissOnTapOutside: dismissOnTapOutside)
        }

    func dismissCustomPopup() {
        customPopup = nil
    }
    
    func dismissToast() {
        toast = nil
    }
    
    func dismissAlert() {
        alert = nil
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
    let dismissOnTapOutside: Bool

    static func ==(lhs: CustomPopupData, rhs: CustomPopupData) -> Bool {
        lhs.id == rhs.id && lhs.dismissOnTapOutside == rhs.dismissOnTapOutside
    }
}

struct ToastData: Identifiable, Equatable {
    let id = UUID()
    var style: ToastStyle
    var message: String
    var duration: TimeInterval = 3
    var width: CGFloat = .infinity
    var position: ToastPosition = .top
    
    static func ==(lhs: ToastData, rhs: ToastData) -> Bool {
           lhs.id == rhs.id &&
           lhs.style == rhs.style &&
           lhs.message == rhs.message &&
           lhs.duration == rhs.duration &&
           lhs.width == rhs.width &&
           lhs.position == rhs.position
       }
}
