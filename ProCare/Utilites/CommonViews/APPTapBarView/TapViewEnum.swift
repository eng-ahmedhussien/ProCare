//
//  TapViewEnum.swift
//  AllinOnApp
//
//  Created by ahmed hussien on 10/03/2025.
//

import SwiftUI


enum TapViewEnum : Identifiable, CaseIterable, View {
    
    case  home, orders, profile
    var id: Self { self }
    
    var tabItem : TabItem {
        switch self {
        case .home:
                .init(image: "homeTap", title: "home")
        case .orders:
                .init(image: "ordersTap", title: "orders")
        case .profile:
                .init(image: "profileTap", title: "profile")
        }
    }
    
    var body: some View {
        switch self {
        case .home:
            HomePage(vm: HomeVM())
        case .orders:
            homeView()
        case .profile:
            ProfilePage()
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
   // @EnvironmentObject var auth: AuthManger
    @EnvironmentObject var authManager: AuthManager

    @EnvironmentObject var appRouter: AppRouter
    var body: some View {
        VStack{
            Button {
                appRouter.push(.homeView2)
            } label: {
                Text("logOut".localized())
                    .font(.title3)
                    .underline()
            }
            .buttonStyle(.plain)
        }
    }
}

struct homeView2 : View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        VStack{
            Button {
                appRouter.popToRoot()
                authManager.logout()
            } label: {
                Text("logOut".localized())
                    .font(.title3)
                    .underline()
            }
            .buttonStyle(.plain)
        }
    }
}
