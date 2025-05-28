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
            toastContent()
        }
    }

    @ViewBuilder
    private func toastContent() -> some View {
        if let toast = toast {
            VStack {
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width,
                    onCancelTapped: dismissToast
                )
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.spring(), value: toast)
            .onAppear { handleToastAppear(toast) }
        }
    }

    private func handleToastAppear(_ toast: Toast) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if toast.duration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                if self.toast == toast {
                    dismissToast()
                }
            }
        }
    }

    private func dismissToast() {
        withAnimation {
            self.toast = nil
        }
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

// MARK: - Global function for showing a toast
func showAppMessage(_ message: String, appearance: ToastStyle, position: ToastPosition = .top) {
    ToastManager.shared.show(
        Toast(style: appearance, message: message, duration: 3, position: position)
    )
}

struct ToastModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ToastStyle.allCases, id: \.self) { style in
                ForEach([ToastPosition.top, .center, .bottom], id: \.self) { position in
                    PreviewToastView(
                        toast: Toast(
                            style: style,
                            message: "\(style) toast at \(position)",
                            duration: 3,
                            position: position
                        )
                    )
                    .previewDisplayName("\(style) - \(position)")
                }
            }
        }
    }

    struct PreviewToastView: View {
        @State var toast: Toast?
        var body: some View {
            Color(.systemBackground)
                .ignoresSafeArea()
                .toastView(toast: $toast)
        }
    }
}

