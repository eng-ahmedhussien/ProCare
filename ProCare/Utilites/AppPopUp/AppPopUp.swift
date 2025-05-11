//
//  AppPopUpManger.swift
//  ProCare
//
//  Created by ahmed hussien on 22/04/2025.
//

import SwiftUI

struct ViewWithPopUp: View {
    @StateObject var popUpControl: AppPopUp = AppPopUp()
    var body: some View {
        ZStack {
            Group {
                ZStack{
                    Color.gray
                    
                    Button("show pop up") {
                        popUpControl.show(
                            VStack(spacing: 20) {
                                Text("This is a custom popup!")
                                Button("Close") {
                                    popUpControl.dismiss()
                                }
                            }
                            .frame(maxWidth: 300)
                        )
                    }
                }
            }.environmentObject(popUpControl)
            
            if popUpControl.showPopUp {
                GenericPopUp(dismissOnBackgroundTap: popUpControl.tapOutsideToDismiss) {
                    popUpControl.popUpContent
                }
                .environmentObject(popUpControl)
            }
        }
    }
}


#Preview {
    ViewWithPopUp()
}

class AppPopUp: ObservableObject {
    @Published var showPopUp: Bool = false
    var popUpContent: AnyView = AnyView(EmptyView())
    var tapOutsideToDismiss: Bool = true

    func show<Content: View>(_ view: Content, dismissOnBackgroundTap: Bool = true) {
        self.popUpContent = AnyView(view)
        self.tapOutsideToDismiss = dismissOnBackgroundTap
        self.showPopUp = true
    }

    func dismiss() {
        self.showPopUp = false
    }
}

