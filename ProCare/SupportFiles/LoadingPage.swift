//
//  LoadingView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/05/2025.
//
import SwiftUI

struct LoadingPage: View {
    
    @EnvironmentObject var appManager : AppManager
    
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(alignment: .center) {
                
                Image(.splashLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
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
            }

        }.onAppear{
            Task {
                await  appManager.checkVersion()
            }
           // showAlert(title: "update", message: "this forc update test")
        }
    }
}

#Preview{
    LoadingPage()
}
