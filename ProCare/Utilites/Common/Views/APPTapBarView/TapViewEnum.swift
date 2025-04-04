//
//  TapViewEnum.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 10/03/2025.
//

import SwiftUI


enum TapViewEnum : Identifiable, CaseIterable, View {
    
    case profile, home, history
    var id: Self { self }
    
    var tabItem : TabItem {
        switch self {
        case .profile:
                .init(image: "discountIcon", title: "offersTapBar")
        case .home:
                .init(image: "homeIcon", title: "home")
        case .history:
                .init(image: "homeIcon", title: "home")
        }
    }
    
    var body: some View {
        switch self {
        case .profile:
            Text("OffersView")
        case .home:
            homeView()
        case .history:
            Text("MainServicesView")
        }
    }
}

     

#Preview {
    TapViewEnum.home.body
}



//VStack{
//    Text("shopTapBar")
//    Button("Change Language".localized()) {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(url)
//        }
//    }
//}


struct homeView : View {
    @EnvironmentObject var auth: AuthManger
    var body: some View {
        VStack{
            Button {
                auth.deleteToken()
            } label: {
                Text("create account".localized())
                    .font(.title3)
                    .underline()
            }
            .plain()
        }
    }
}
