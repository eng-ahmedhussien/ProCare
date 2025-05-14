//
//  ToastView.swift
//  ProCare
//
//  Created by ahmed hussien on 14/05/2025.
//


import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var width: CGFloat = .infinity
    var onCancelTapped: () -> Void

    var body: some View {
        HStack {
            Text(message)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(nil)
                .padding(.vertical)

            Spacer()

            Button(action: onCancelTapped) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(style.themeColor)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}
