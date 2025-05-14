//
//  ToastManager.swift
//  ProCare
//
//  Created by ahmed hussien on 14/05/2025.
//


import SwiftUI

final class ToastManager: ObservableObject {
    static let shared = ToastManager()

    @Published var toast: Toast?

    private init() {}

    func show(_ toast: Toast) {
        DispatchQueue.main.async { [weak self] in
            self?.toast = toast

            if toast.duration > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                    if self?.toast == toast {
                        self?.dismiss()
                    }
                }
            }
        }
    }


    func dismiss() {
        withAnimation {
            self.toast = nil
        }
    }
}
