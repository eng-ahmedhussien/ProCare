//
//  AppTapBarView.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 27/12/2023.
//

import SwiftUI

struct TapBarView: View {
    
    
    @State var selectTap : TapViewEnum = .home
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor =  UIColor(Color.primary)
        appearance.backgroundImage = UIImage()
        //appearance.shadowImage = image
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView (selection:$selectTap){
            ForEach(TapViewEnum.allCases){ tab in
                let tabItem = tab.tabItem
                tab
                    .tabItem { Label(tabItem.title.localized(), image: tabItem.image) }
                    .tag(tab)
            }
        }
        .accentColor(Color.gray)
        .environment(\.locale, .init(identifier: "ar"))
    }
}

#Preview {
    TapBarView()
}


