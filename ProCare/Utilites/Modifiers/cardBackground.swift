//
//  cardBackground.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import SwiftUI

struct cardBackground: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }.padding()
            .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .gray)
//            .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 5, shadowColor: .black.opacity(5),shadowX:10,shadowY:10)
    }
}

#Preview {
    cardBackground()
}

extension View {
    func backgroundCard(color: Color = Color.white,
                        cornerRadius: CGFloat = 10,
                        shadowRadius: CGFloat = 2,
                        shadowColor: Color = Color(.systemGray4),
                        shadowX: CGFloat = 0,
                        shadowY: CGFloat = 0) -> some View {
        modifier(CardBackground(color: color,
                                cornerRadius: cornerRadius,
                                shadowRadius: shadowRadius,
                                shadowColor: shadowColor,
                                shadowX: shadowX,
                                shadowY: shadowY))
    }
}

struct CardBackground: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowColor: Color
    let shadowX : CGFloat
    let shadowY : CGFloat

    init(color: Color = Color.white,
         cornerRadius: CGFloat = 10,
         shadowRadius: CGFloat = 0,
         shadowColor: Color = Color.clear,
         shadowX: CGFloat = 0,
         shadowY: CGFloat = 0) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowX = shadowX
        self.shadowY = shadowY
    }
    

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .shadow(color: shadowColor, radius: shadowRadius,x:shadowX ,y: shadowY)
            }
            
    }
}
