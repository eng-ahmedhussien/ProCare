//
//  SupportButton.swift
//  ProCare
//
//  Created by ahmed hussien on 12/07/2025.
//

import SwiftUI

struct SupportButton:  View {
    @EnvironmentObject var appRouter: AppRouter
    var color : Color = Color.white 
    var body: some View {
        Button(action: {
            appRouter.push(.InformationScreen)
        }) {
            Image(systemName: "questionmark.circle")
                .foregroundStyle(color)
        }.padding(.horizontal)
    }
}

#Preview {
    ZStack{
        Color.red
        SupportButton()
    }
}

