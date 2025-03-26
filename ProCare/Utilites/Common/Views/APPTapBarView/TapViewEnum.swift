//
//  TapViewEnum.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 10/03/2025.
//

import SwiftUI


enum TapViewEnum : Identifiable, CaseIterable, View {
    
    case shop, offers, home, Services, cart
    var id: Self { self }
    
    var tabItem : TabItem {
        switch self {
        case .shop:
                .init(image: "shopsIcon", title: "shop")
        case .offers:
                .init(image: "discountIcon", title: "offersTapBar")
        case .home:
                .init(image: "homeIcon", title: "home")
        case .Services:
                .init(image: "location", title: "servicesTapBar")
        case .cart:
                .init(image: "profileIcon", title: "cartTapBar")
        }
    }
    
    var body: some View {
        switch self {
        case .shop:
            VStack{
                Text("shopTapBar")
                Button("Change Language".localized()) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        case .offers:
            Text("OffersView")
        case .home:
            Text("OffersView")
        case .Services:
            Text("MainServicesView")
        case .cart:
            Text("CartPageView")
        }
    }
}

     

#Preview {
    TapViewEnum.home.body
}

