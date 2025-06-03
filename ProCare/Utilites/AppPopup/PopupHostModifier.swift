//
//  PopupHostModifier.swift
//  ProCare
//
//  Created by ahmed hussien on 01/06/2025.
//


import SwiftUI

struct PopupHostModifier: ViewModifier {
    @ObservedObject private var popupManager = PopupManager.shared
    @State private var showToast: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast = popupManager.toast, showToast {
                PopToastView(toast: toast) {
                    withAnimation {
                        showToast = false
                        popupManager.toast = nil
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                        withAnimation {
                            showToast = false
                            popupManager.toast = nil
                        }
                    }
                }
            }


            if let popup = popupManager.customPopup {
                popup.content
                    .zIndex(200)
            }
        }
        .onChange(of: popupManager.toast) { newToast in
            if newToast != nil {
                withAnimation { showToast = true }
            }
        }
        .alert(
            popupManager.alert?.title ?? "",
            isPresented: Binding(
                get: { popupManager.alert != nil },
                set: { if !$0 { popupManager.alert = nil } }
            )
        ) {
            Button(popupManager.alert?.button ?? "OK") {
                popupManager.alert?.action?()
                popupManager.alert = nil
            }
        } message: {
            Text(popupManager.alert?.message ?? "")
        }
    }
}

extension View {
    func popupHost() -> some View {
        modifier(PopupHostModifier())
    }
}


// MARK: - Global function for showing a toast
func showToast(_ message: String, appearance: ToastStyle, position: ToastPosition = .top) {
    PopupManager.shared.showToast(message: message, style: appearance, position: position)
}

func showPopup<Content: View>(@ViewBuilder content: () -> Content) {
    PopupManager.shared.showCustomPopup {
            AnyView(content())
    }
}

