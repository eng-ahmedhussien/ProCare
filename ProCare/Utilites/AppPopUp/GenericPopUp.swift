//
//  GenericPopUp.swift
//  ProCare
//
//  Created by ahmed hussien on 22/04/2025.
//

import SwiftUI

struct GenericPopUp<Content: View>: View {
    let content: Content
    let tapOutsideToDismiss: Bool
    @EnvironmentObject var popUpHelper: AppPopUp

    init(
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.tapOutsideToDismiss = dismissOnBackgroundTap
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .contentShape(Rectangle()) // make sure the entire area is tappable
                .onTapGesture {
                    if tapOutsideToDismiss {
                        popUpHelper.dismiss()
                    }
                }

            content
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding()
        }
    }
}

extension View {
    func implementPopupView(using appPopUpManger: AppPopUp) -> some View {
        ZStack {
            self
                .environmentObject(appPopUpManger)

            if appPopUpManger.showPopUp {
                GenericPopUp(dismissOnBackgroundTap: appPopUpManger.tapOutsideToDismiss) {
                    appPopUpManger.popUpContent
                }
                .environmentObject(appPopUpManger)
            }
        }
    }
}
