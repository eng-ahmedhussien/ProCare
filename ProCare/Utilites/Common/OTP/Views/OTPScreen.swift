//
//  OTPScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI
import Combine

struct OTPScreen: View {
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    
    var phonNumber: String = ""
    @StateObject var vm = OTPVM()
    
    var body: some View {
            VStack {
    
                VStack(alignment: .leading){
                    Text("please".localized())
                    Text("enter otp!".localized())
                }
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                pinView
            
                Button {
                    let parameter = [
                        "phoneNumber": phonNumber,
                        "code": pinOne + pinTwo + pinThree + pinFour
                    ]
                    Task {
                        await vm.confirmCode(parameter: parameter)
                    }
                   
                } label: {
                    Text("Verify".localized())
                        .font(.title3)
                }
                .solid(width: 300,isDisabled: pinOne.isEmpty || pinTwo.isEmpty || pinThree.isEmpty || pinFour.isEmpty)
            }
        
    }
}

extension OTPScreen {
    var pinView: some View {
        HStack(spacing:15) {
            TextField("", text: $pinOne)
                .otpModifer(pin: $pinOne, isFocused: .constant(pinFocusState == .pinOne))
                .onChange(of: pinOne) { newVal in
                    if newVal.count == 1 { pinFocusState = .pinTwo }
                }
                .focused($pinFocusState, equals: .pinOne)
            
            TextField("", text: $pinTwo)
                .otpModifer(pin: $pinTwo, isFocused: .constant(pinFocusState == .pinTwo))
                .onChange(of: pinTwo) { newVal in
                    if newVal.count == 1 {
                        pinFocusState = .pinThree
                    } else if newVal.count == 0 {
                        pinFocusState = .pinOne
                    }
                    
                }
                .focused($pinFocusState, equals: .pinTwo)
            
            TextField("", text: $pinThree)
                .otpModifer(pin: $pinThree, isFocused: .constant(pinFocusState == .pinThree))
                .onChange(of: pinThree) { newVal in
                    if newVal.count == 1 {
                        pinFocusState = .pinFour
                    } else if newVal.count == 0 {
                        pinFocusState = .pinTwo
                    }
                }
                .focused($pinFocusState, equals: .pinThree)
            
            TextField("", text: $pinFour)
                .otpModifer(pin: $pinFour, isFocused: .constant(pinFocusState == .pinFour))
                .onChange(of: pinFour) { newVal in
                    if newVal.count == 0 {
                        pinFocusState = .pinThree
                    }
                }
                .focused($pinFocusState, equals: .pinFour)
        }
        .padding(.vertical)
        .onAppear {
            pinFocusState = .pinOne
        }
    }
}


#Preview {
    OTPScreen()
}

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
                    .stroke(isFocused ? Color.red : Color.gray, lineWidth: 2) // Change border color when focused
            )
    }
}

extension View {
    func otpModifer(pin: Binding<String>, isFocused: Binding<Bool>) -> some View {
        modifier(OtpModifer(pin: pin, isFocused: isFocused))
    }
}

