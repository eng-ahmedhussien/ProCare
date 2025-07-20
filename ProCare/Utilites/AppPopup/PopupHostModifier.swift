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
    @State private var toastTimer: Timer?

    func body(content: Content) -> some View {
        ZStack {
            content
                // Disable interaction when popup is shown
                .disabled(popupManager.customPopup != nil)
            
            // Semi-transparent overlay to block interaction and dim background
            if let popup = popupManager.customPopup {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .zIndex(199)
                    .onTapGesture {
                        if popup.dismissOnTapOutside {
                            popupManager.dismissCustomPopup()
                        }
                    }
            }

            if let toast = popupManager.toast, showToast {
                PopToastView(toast: toast) {
                    dismissToast()
                }
                .onAppear {
                    startToastTimer(duration: toast.duration)
                }
                .zIndex(201)
            }

            if let popup = popupManager.customPopup {
                popup.content
                    .zIndex(200)
            }
        }
        .onChange(of: popupManager.toast) { newValue in
            handleToastChange(newValue: newValue)
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
    
    private func handleToastChange(newValue: ToastData?) {
           toastTimer?.invalidate()
           
           if newValue != nil {
               withAnimation(.easeInOut(duration: 0.3)) {
                   showToast = true
               }
           } else {
               withAnimation(.easeInOut(duration: 0.3)) {
                   showToast = false
               }
           }
       }
    
    private func startToastTimer(duration: TimeInterval) {
           toastTimer?.invalidate()
           toastTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
               dismissToast()
           }
       }
    private func dismissToast() {
        toastTimer?.invalidate()
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            popupManager.toast = nil
        }
    }
}

extension View {
    func popupHost() -> some View {
        modifier(PopupHostModifier())
    }
}

// MARK: - Global function for showing a toast
@MainActor
func showToast(_ message: String, appearance: ToastStyle, position: ToastPosition = .top) {
    PopupManager.shared.showToast(message: message, style: appearance, position: position)
}

//@MainActor
//func showPopup<Content: View>(@ViewBuilder content: () -> Content) {
//    PopupManager.shared.showCustomPopup(content: content)
//}
@MainActor
func showPopup<Content: View>(dismissOnTapOutside: Bool = false, @ViewBuilder content: () -> Content) {
    PopupManager.shared.showCustomPopup(dismissOnTapOutside: dismissOnTapOutside, content: content)
}

@MainActor
func showAlert(title: String, message: String) {
    PopupManager.shared.showAlert(title: title, message: message)
}


// MARK: - Helper function to dismiss popup
//@MainActor
//func dismissPopup() {
//    PopupManager.shared.customPopup = nil
//}

@MainActor
func dismissPopup() {
    PopupManager.shared.dismissCustomPopup()
}

@MainActor
func dismissToast() {
    PopupManager.shared.dismissToast()
}

    // MARK: - Preview
 #Preview {
        VStack(spacing: 20) {
            Button("Show Success Toast") {
                showToast("Operation completed successfully!", appearance: .success)
            }
            
            Button("Show Error Toast") {
                showToast("Something went wrong!", appearance: .error)
            }
            
            Button("Show Center Toast") {
                showToast("Centered message", appearance: .info, position: .center)
            }
            
            Button("Show Alert") {
                showAlert(title: "Alert", message: "This is an alert message")
            }
            
            Button("Show Custom Popup") {
                showPopup {
                    VStack {
                        Text("Custom Popup")
                            .font(.title)
                        Button("Dismiss") {
                            dismissPopup()
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 300)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.regularMaterial))
                }
            }
            
            Button("Show Custom Popup outside dissmiss") {
                showPopup(dismissOnTapOutside: true) {
                    VStack {
                        Text("Custom Popup")
                            .font(.title)
                        Button("Dismiss") {
                            dismissPopup()
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 300)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.regularMaterial))
                }
            }
        }
        .popupHost()
    }
