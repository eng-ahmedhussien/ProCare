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
        setupTapViewAppearance()
    }
    
    var body: some View {
        TabView (selection:$selectTap){
            ForEach(TapViewEnum.allCases){ tab in
                let tabItem = tab.tabItem
                tab
                    .tabItem {
                        Group{
                            Image(tabItem.image)
                                .renderingMode(.template)
                            
                            Text(tabItem.title.localized())
                        }
                    }
                    .tag(tab)
            }
        }
        .accentColor(.appPrimary)
    }
    
    private func setupTapViewAppearance() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 5),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.05).cgColor
            ]
        )
        let appearance = UITabBarAppearance()
        //appearance.configureWithTransparentBackground()
        appearance.shadowImage = image
        
        // 🛠 Customize title font here (UIKit level)
        let normalTapTitle = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        let selectedTapTitle = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalTapTitle
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTapTitle
        
        // 👇 Adjust vertical spacing between image and title
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        //MARK: -  change icon color
       /// appearance.stackedLayoutAppearance.normal.iconColor = .black
        ///appearance.stackedLayoutAppearance.selected.iconColor = .red
        
        //MARK: - Adjust spacing between image and title
/// appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
/// appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
    }
}

#Preview {
    TapBarView()
}
