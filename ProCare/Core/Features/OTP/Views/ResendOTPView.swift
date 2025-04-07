//
//  ResendOTPView.swift
//  ProCare
//
//  Created by ahmed hussien on 06/04/2025.
//

import SwiftUI
import Combine


struct ResendOTPView: View {
    @State private var timeRemaining = 10
    @State private var timerSubscription: AnyCancellable?
    @ObservedObject var vm : OTPVM
    var phonNumber: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                resendOTP()
            }) {
                Text(timeRemaining > 0 ? "Resend OTP in \(timeRemaining)s" : "Resend OTP")
                    .foregroundColor(timeRemaining > 0 ? .gray : .appPrimary)
            }
            .disabled(timeRemaining > 0)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
    }
    
    private func startTimer() {
        timerSubscription?.cancel()
        timeRemaining = 10
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink {  _ in
               
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerSubscription?.cancel()
                }
            }
    }
    
    private func resendOTP() {
        startTimer()
        Task {
            let parameter = ["phoneNumber": phonNumber]
           await vm.resendCode(parameter: parameter)
        }
    }
}


#Preview {
    ResendOTPView(vm: OTPVM())
}
