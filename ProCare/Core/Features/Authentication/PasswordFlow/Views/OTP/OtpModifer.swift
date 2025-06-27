//
//  OtpModifer.swift
//  ProCare
//
//  Created by ahmed hussien on 11/04/2025.
//

import SwiftUI
import Combine

struct OtpModifer: ViewModifier {
    @Binding var pin : String
    @Binding var isFocused: Bool // Add a binding for focus state
    var textLimt = 1
    
    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 45, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        isFocused ? .appPrimary : .appSecode,
                        lineWidth: 2
                    ) // Change border color when focused
            )
    }
}

extension View {
    func otpModifer(pin: Binding<String>, isFocused: Binding<Bool>) -> some View {
        modifier(OtpModifer(pin: pin, isFocused: isFocused))
    }
}
