//
//  RetryView.swift
//  ProCare
//
//  Created by ahmed hussien on 15/06/2025.
//


import SwiftUI

struct RetryView: View {
    let message: String
    let retryAction: () -> Void
    let buttonTitle: String

    init(message: String, buttonTitle: String = "Try Again", retryAction: @escaping () -> Void) {
        self.message = message
        self.buttonTitle = buttonTitle
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(message)
                .lineLimit(2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            Button(buttonTitle, action: retryAction)
                .foregroundStyle(.appPrimary)
        }
        .padding()
    }
}


#Preview {
    RetryView(message: "An error occurred. Please try again.", retryAction: {
        print("Retry action triggered")
    })
}


