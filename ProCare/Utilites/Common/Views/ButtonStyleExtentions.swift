//
//  ButtonStyleExtentions.swift
//  CustomButton
//
//  Created by ahmed hussien on 27/01/2025.
//

import SwiftUI

//MARK: SolidButton
struct SolidButtonStyle: ViewModifier {
    
    let width: CGFloat
    let isDisabled: Bool
    
    init(width: CGFloat, isDisabled: Bool) {
        self.width = width
        self.isDisabled = isDisabled
    }
    
    func body(content: Content) -> some View {
            content
            .frame(width: width)
            .font(.body)
            .foregroundColor(.white )
            .padding()
            .background(backgroundView())
            .cornerRadius(10)
            .disabled(isDisabled)
    }
    
    @ViewBuilder private func backgroundView() -> some View {
        Capsule()
            .strokeBorder( isDisabled ? .gray :  .clear , lineWidth: 1 )
            .background( isDisabled ? .gray : .appPrimary  )
    }
    
}
//MARK: BorderButton
struct BorderButtonStyle: ViewModifier {
    
    let width: CGFloat
    let isDisabled: Bool
    
    init(width: CGFloat, isDisabled: Bool) {
        self.width = width
        self.isDisabled = isDisabled
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: width)
            .font(.body)
            .foregroundColor(isDisabled ? .gray.opacity(0.8) : .appPrimary  )
            .padding()
            .background(backgroundView())
    }
    
    @ViewBuilder private func backgroundView() -> some View {
        Capsule()
            .strokeBorder( isDisabled ? .gray.opacity(0.8) : Color("Mainbutton") , lineWidth: 1 )
    }
    
}
//MARK: PlainButton
struct PlainButtonStyle: ViewModifier {
    let isDisabled: Bool
    
    init( isDisabled: Bool) {
        self.isDisabled = isDisabled
    }
    
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(isDisabled ? .gray.opacity(0.8) : .black )
            .padding()
    }
}

extension View {
    func solid(width: CGFloat = 100,isDisabled: Bool = false) -> some View {
        modifier(SolidButtonStyle(width: width, isDisabled: isDisabled))
    }
    
    func border(width: CGFloat = 100,isDisabled: Bool = false) -> some View {
        modifier(BorderButtonStyle(width: width, isDisabled: isDisabled))
    }
    
    func plain(isDisabled: Bool = false) -> some View {
        modifier(PlainButtonStyle(isDisabled: isDisabled))
    }
}
