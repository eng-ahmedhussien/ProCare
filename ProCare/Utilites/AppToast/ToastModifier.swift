//
//  ToastModifier.swift
//  ProCare
//
//  Created by ahmed hussien on 14/05/2025.
//


import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast = toast {
                VStack {
                    if toast.position == .top {
                        toastView
                        Spacer()
                    } else if toast.position == .center {
                        Spacer()
                        toastView
                        Spacer()
                    } else if toast.position == .bottom {
                        Spacer()
                        toastView
                            .padding(.bottom, 30)
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: toast)
                .onAppear {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if toast.duration > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                            if self.toast == toast {
                                withAnimation {
                                    self.toast = nil
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private var toastView: some View {
        ToastView(
            style: toast?.style ?? .info,
            message: toast?.message ?? "",
            width: toast?.width ?? .infinity,
            onCancelTapped: {
                withAnimation {
                    self.toast = nil
                }
            }
        )
    }
}


extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}



func showAppMessage(_ message: String, appearance: ToastStyle, position: ToastPosition = .top) {
    ToastManager.shared.show(
        Toast(style: appearance, message: message, duration: 3, position: position)
    )
}
