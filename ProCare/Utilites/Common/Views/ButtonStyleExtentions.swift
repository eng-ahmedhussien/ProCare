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

struct CustomButtonStyle: ViewModifier {
    
    let kind: CustomButtonKind
    let width: CGFloat?
    let disabled: Bool
    
    init(kind: CustomButtonKind = .solid, width: CGFloat? = nil, disabled: Bool = false) {
        self.kind = kind
        self.width = width
        self.disabled = disabled
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: width)
            .font(.body)
            .foregroundColor(foregroundColor)
            .padding()
            .background(backgroundView())
            .cornerRadius(kind == .solid ? 10 : 0)
            .disabled(disabled)
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
    
    @ViewBuilder private func backgroundView() -> some View {
        switch kind {
        case .solid:
            Capsule()
                .strokeBorder(disabled ? .gray : .clear, lineWidth: 1)
                .background(disabled ? Color.gray : Color.appPrimary)
        case .border:
            Capsule()
                .strokeBorder(disabled ? .gray.opacity(0.8) : Color("Mainbutton"), lineWidth: 1)
        case .plain:
            EmptyView()
        }
    }
}

extension View {
    func buttonStyle(_ kind: CustomButtonKind, width: CGFloat? = nil, disabled: Bool = false) -> some View {
        modifier(CustomButtonStyle(kind: kind, width: width, disabled: disabled))
    }
}

#Preview{
    VStack{
        Section{
            Text("Solid")
                .buttonStyle(.solid, width: 120, disabled: false)
            Text("Solid")
                .buttonStyle(.solid, width: 120, disabled: true)
        }

        Text("Border")
            .buttonStyle(.border, width: 120, disabled: false)
        Text("Border")
            .buttonStyle(.border, width: 120, disabled: true)

        Text("Plain")
            .buttonStyle(.plain, disabled: true)
        Text("Plain")
            .buttonStyle(.plain, disabled: false)
    }
}
