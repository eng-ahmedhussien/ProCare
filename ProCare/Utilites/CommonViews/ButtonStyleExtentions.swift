//
//  ButtonStyleExtentions.swift
//  CustomButton
//
//  Created by ahmed hussien on 27/01/2025.
//

import SwiftUI

enum CustomButtonKind {
    case solid
    case border
    case plain
}

struct AppButton: ButtonStyle {
    let kind: CustomButtonKind
    let width: CGFloat?
    let height: CGFloat?
    let disabled: Bool
    let backgroundColor: Color
    
    // Default initializer with default values
       init(kind: CustomButtonKind = .solid, width: CGFloat? = nil, height: CGFloat? = nil, disabled: Bool = false,backgroundColor: Color = .appPrimary) {
           self.kind = kind
           self.width = width
           self.height = height
           self.disabled = disabled
           self.backgroundColor = backgroundColor
       }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        return configuration.label
            .frame(width: width, height: height)
            .padding()
            .foregroundColor(foregroundColor)
            .background(background(isPressed: isPressed, color: backgroundColor))
            .cornerRadius(10)
            .opacity(disabled ? 0.6 : 1.0)
    }

    private var foregroundColor: Color {
        switch kind {
        case .solid:
            return .white
        case .border:
            return disabled ? .gray.opacity(0.8) : .appPrimary
        case .plain:
            return disabled ? .gray.opacity(0.8) : .black
        }
    }

    @ViewBuilder
    private func background(isPressed: Bool,color: Color) -> some View {
        switch kind {
        case .solid:
            RoundedRectangle(cornerRadius: 10)
                .fill(disabled ? Color.gray : (isPressed ? color.opacity(0.7) : color))
        case .border:
            RoundedRectangle(cornerRadius: 10)
                .stroke(disabled ? .gray.opacity(0.8) : .appPrimary, lineWidth: 1)
        case .plain:
            Color.clear
        }
    }
}


//#Preview{
//    VStack{
//        Section{
//            Text("Solid")
//                .buttonStyle(CustomButton(kind: .solid, width: 300, height: 50, disabled: !isFormValid))
//                .disabled(!isFormValid)
//            Text("Solid")
//                .buttonStyle(.solid,hight: 5, disabled: true)
//        }
//
//        Text("Border")
//            .buttonStyle(.border, width: 120, disabled: false)
//        Text("Border")
//            .buttonStyle(.border, width: 120, disabled: true)
//
//        Text("Plain")
//            .buttonStyle(.plain, disabled: true)
//        Text("Plain")
//            .buttonStyle(.plain, disabled: false)
//    }
//}
