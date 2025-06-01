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
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var isBusy = false // false means Online
    let width =  UIScreen.main.bounds.width * 0.85

    var body: some View {
        VStack(spacing: 30) {

            Spacer()

            // Online / Offline Switch
            HStack {
                Text("Status:")
                    .font(.title3.bold())
                Spacer()
                // In your Toggle:
                Toggle(isOn: Binding(
                    get: { !isBusy },
                    set: { isOnline in
                        isBusy = !isOnline
                        Task {
                            await vm.changeStatus(isBusy: isBusy)
                        }
                    }
                )) {
                    Text(!isBusy ? "Online" : "Offline")
                        .foregroundColor(!isBusy ? .green : .red)
                        .bold()
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .padding()
            .backgroundCard(cornerRadius: 10 , shadowRadius: 0.5, shadowColor: .black)
            .padding(.horizontal)
            .animation(.easeInOut, value: isBusy)

            // Change Location
            Button(action: {
                guard let location = locationManager.location else { return }
                let lat = String(location.coordinate.latitude)
                let lon = String(location.coordinate.longitude)
                Task {
                    await vm.updateLocation(lat: lat, lon: lon)
                }
            }) {
                HStack {
                    Image(systemName: "location.fill")
                    Text("update my location")
                        .bold()
                }
            }
            .buttonStyle(AppButton(kind: .border))

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

            Spacer()
        }
        .appNavigationBar(title: "Profile")
    }
}


#Preview {
    NavigationStack{
        NuresProfileScreen()
            .appNavigationBar(title: "Profile")
    }
        
}
