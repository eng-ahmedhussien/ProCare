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

    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        VStack {
            ToastContent(
                style: style,
                message: message,
                width: width,
                dragOffset: dragOffset, // Use wrapped value here
                onCancelTapped: onCancelTapped
            )
            Spacer()
        }
    }
}

private struct ToastContent: View {
    var style: ToastStyle
    var message: String
    var width: CGFloat
    var dragOffset: CGSize // Use plain CGSize here
    var onCancelTapped: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .font(.body)
                .foregroundColor(.white)
                .lineLimit(nil)
                .padding(.vertical)
            Spacer()
        }
        .frame(maxWidth: width)
        .background(style.themeColor)
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onChanged { value in
                    // Optionally handle drag offset here if needed
                }
                .onEnded { value in
                    if value.translation.height < -30 {
                        onCancelTapped()
                    }
                }
        )
    }
}

#Preview {
    ToastView(style: .success, message: "message test", onCancelTapped: {})
}
