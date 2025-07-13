//
//  SupportButton.swift
//  ProCare
//
//  Created by ahmed hussien on 12/07/2025.
//

import SwiftUI

struct SupportButton:  View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: "questionmark.circle")
                .foregroundStyle(.white)
        }.padding(.horizontal)
    }
}

#Preview {
    ZStack{
        Color.red
        SupportButton()
    }
}

