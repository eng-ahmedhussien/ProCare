    //
    //  NuresProfileScreen.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 30/05/2025.
    //

import SwiftUI

struct NuresProfileScreen: View {
    
    @StateObject var vm = NuresProfileVM()
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    
    @State private var isBusy = false // false means Online
    let width =  UIScreen.main.bounds.width * 0.85
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
                // Online / Offline Switch
            HStack {
                    // In your Toggle:
                Toggle(isOn: Binding(
                    get: { !isBusy },
                    set: { isOnline in
                        isBusy = !isOnline
                        Task {
                            await vm.changeStatus(isBusy: isBusy){ result in
                                if result {
                                    
                                }else{
                                    isBusy = false // revert the toggle state if the change fails
                                    
                                }
                                
                            }
                        }
                    }
                )) {
                    Text(!isBusy ? "online".localized() : "offline".localized())
                        .foregroundColor(!isBusy ? .green : .red)
                        .bold()
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .padding()
            .backgroundCard(cornerRadius:30 , shadowRadius: 0.5, shadowColor: .black)
            .padding(.horizontal)
            .animation(.easeInOut, value: isBusy)
            
                // Change Location
            Button(
                action: {
                    guard let location = LocationManager.shared.location else {
                        return
                    }
                    let lat = location.coordinate.latitude
                    let lon = location.coordinate.longitude
                    Task {
                        await vm.updateLocation(lat: lat, lon: lon)
                    }
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("update_my_location")
                            .bold()
                    }
                }
                .buttonStyle(AppButton(kind: .border))
                .padding(.horizontal)
            
                // Logout Button
            Button(action: {
                appRouter.popToRoot()
                authManager.logout()
            }) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                    Text("logout")
                        .bold()
                }
            }
            .buttonStyle(AppButton(kind: .solid))
            .padding(.horizontal)
            
            Spacer()
        }
        .appNavigationBar(title: "profile".localized())
        
        
    }
}


#Preview {
    NavigationStack{
        NuresProfileScreen()
            .appNavigationBar(title: "Profile".localized())
            .environment(\.locale, .init(identifier: "ar")) // "ar" for Arabic, "fr" for French, etc.
        
    }
    
}
