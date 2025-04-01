//
//  ButtonStyleExtentions.swift
//  CustomButton
//
//  Created by ahmed hussien on 27/01/2025.
//

import SwiftUI

//MARK: SolidButton
struct SolidButtonStyle: ButtonStyle {
    
    let width: CGFloat
    let isDisabled: Bool
    
    init(width: CGFloat, isDisabled: Bool) {
        self.width = width
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width)
            .font(.body)
            .foregroundColor(isDisabled ? .gray.opacity(0.8) : .white )
            .padding()
           
            .background(backgroundView(configuration))
            .cornerRadius(10)
            .disabled(isDisabled)
        
    }
    
    @ViewBuilder private func backgroundView( _ configuration: Configuration) -> some View {
        Capsule()
            .strokeBorder( isDisabled ? .gray :  .clear , lineWidth: 1 )
            .background( isDisabled ? Color("bgDisabledButton") : .theme.appPrimary  )
    }
    
}
//MARK: BorderButton
struct BorderButtonStyle: ButtonStyle {
    
    let width: CGFloat
    let isDisabled: Bool
    
    init(width: CGFloat, isDisabled: Bool) {
        self.width = width
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width)
            .font(.body)
            .foregroundColor(isDisabled ? .gray.opacity(0.8) : .theme.appPrimary  )
            .padding()
            .background(backgroundView(configuration))
    }
    
    @ViewBuilder private func backgroundView( _ configuration: Configuration) -> some View {
        Capsule()
            .strokeBorder( isDisabled ? .gray.opacity(0.8) : Color("Mainbutton") , lineWidth: 1 )
    }
    
}
//MARK: PlainButton
struct PlainButtonStyle: ButtonStyle {
    
    let isDisabled: Bool
    
    init( isDisabled: Bool) {
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(isDisabled ? .gray.opacity(0.8) : .black )
            .padding()
    }
}

extension View {
    
    func solid(width: CGFloat = 100,isDisabled: Bool = false) -> some View {
        buttonStyle(SolidButtonStyle(width: width, isDisabled: isDisabled))
    }
    
    func border(width: CGFloat = 100,isDisabled: Bool = false) -> some View {
        buttonStyle(BorderButtonStyle(width: width, isDisabled: isDisabled))
    }
    
    func plain(isDisabled: Bool = false) -> some View {
        buttonStyle(PlainButtonStyle(isDisabled: isDisabled))
    }
}

//struct GradientStyle: ButtonStyle {
//  @Environment(\.isEnabled) private var isEnabled
//  private let colors: [Color]
//
//  init(colors: [Color] = [.mint.opacity(0.6), .mint, .mint.opacity(0.6), .mint]) {
//    self.colors = colors
//  }
//
//  func makeBody(configuration: Configuration) -> some View {
//    HStack {
//      configuration.label
//    }
//    .font(.body.bold())
//    .foregroundColor(isEnabled ? .white : .black)
//    .padding()
//    .frame(height: 44)
//    .background(backgroundView(configuration: configuration))
//    .cornerRadius(10)
//  }
//
//  @ViewBuilder private func backgroundView(configuration: Configuration) -> some View {
//    if !isEnabled {
//      disabledBackground
//    }
//    else if configuration.isPressed {
//      pressedBackground
//    } else {
//      enabledBackground
//    }
//  }
//
//  private var enabledBackground: some View {
//    LinearGradient(
//      colors: colors,
//      startPoint: .topLeading,
//      endPoint: .bottomTrailing)
//  }
//
//  private var disabledBackground: some View {
//    LinearGradient(
//      colors: [.gray],
//      startPoint: .topLeading,
//      endPoint: .bottomTrailing)
//  }
//
//  private var pressedBackground: some View {
//    LinearGradient(
//      colors: colors,
//      startPoint: .topLeading,
//      endPoint: .bottomTrailing)
//    .opacity(0.4)
//  }
//}
//
//extension ButtonStyle where Self == GradientStyle {
//  static var gradient: GradientStyle { .init() }
//}
