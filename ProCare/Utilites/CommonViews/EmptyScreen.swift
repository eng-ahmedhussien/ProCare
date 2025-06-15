//
//  EmptyView.swift
//  ProCare
//
//  Created by ahmed hussien on 15/06/2025.
//
import SwiftUI

struct EmptyScreen: View {
    let message: String

    init(message: String) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.exclam")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text(message)
                .lineLimit(2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}


#Preview {
    RetryView(message: "An error occurred. Please try again.", retryAction: {
        print("Retry action triggered")
    })
}
