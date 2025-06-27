//
//  appNavigationBar.swift
//  ProCare
//
//  Created by ahmed hussien on 11/04/2025.
//

import SwiftUI

//MARK: view
struct Privewer_AppNavigationBarStyle: View {
    var body: some View {
        NavigationStack {
            Text("tsext")
                .appNavigationBar(title: "test screen")
        }
    }
}
//MARK: ViewModifier
struct AppNavigationBarStyle : ViewModifier {
    var title: String = ""
    
    func body(content: Content) -> some View {
            content
            .navigationTitle(title.localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.appPrimary)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
//MARK: extension
extension View {
    func appNavigationBar(title: String) -> some View {
        self
            .modifier(AppNavigationBarStyle(title: title))
    }
}
//MARK: Preview
#Preview {
    Privewer_AppNavigationBarStyle()
}

