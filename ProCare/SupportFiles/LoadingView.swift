//
//  LoadingView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//
import SwiftUI

struct LoadingPage: View {
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        ZStack {
            Color.appPrimary.ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text("ProCare")
                    .font(.system(size: 50))
                    .bold()
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            opacity = 1.0
                        }
                        withAnimation(.easeOut(duration: 1.2).delay(0.5)) {
                            scale = 1.0
                        }
                    }

                Text("Your nurses are by your side at any time")
                    .font(.system(size: 15))
                    .bold()
                    .foregroundStyle(.white)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0).delay(0.5)) {
                            opacity = 1.0
                        }
                    }
            }
            .onAppear {
                // Trigger animations for both text elements
                withAnimation(.easeIn(duration: 1.0)) {
                    opacity = 1.0
                }
                withAnimation(.easeOut(duration: 1.2).delay(0.5)) {
                    scale = 1.0
                }
            }
        }
    }
}

#Preview{
    LoadingPage()
}
