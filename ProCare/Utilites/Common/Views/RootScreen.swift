//
//  RootView.swift
//  ProCare
//
//  Created by ahmed hussien on 01/04/2025.
//

import SwiftUI

struct RootScreen: View {
    
    @State var loggedIn: Bool = false
    
    var body: some View {
        if loggedIn {
            TapBarView()
        } else {
            SiginUPScreen()
        }
    }
}


#Preview {
    RootScreen()
}
