    //
    //  NuresProfileScreen.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 30/05/2025.
    //

import SwiftUI

struct NuresProfileScreen: View {
    @EnvironmentObject var vm: NuresProfileVM
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var appRouter: AppRouter
    @State private var showAlertLogout = false
    @State private var isBusy: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                profileImageSection
                VStack(spacing: 20) {
                    statusToggle
                    updateLocationButton
                    logoutButton
                }
                .padding()
                .backgroundCard(cornerRadius: 24, shadowRadius: 1)
            }
            .padding()
        }
        .safeAreaInset(edge: .top) {
            header
                .background(.regularMaterial)
        }
        .onAppear {
            isBusy = vm.nurseProfile?.isBusy ?? false
        }
        .refreshable {
            Task{
                await vm.fetchNurseProfile()
            }
        }
        .onChange(of: vm.nurseProfile?.isBusy) { newValue in
            isBusy = newValue ?? false
        }
        .alert("logout".localized(), isPresented: $showAlertLogout) {
            Button("cancel".localized(), role: .cancel) { }
            Button("logout".localized(), role: .destructive) {
                Task{
                    await appManager.logout(){
                        appRouter.popToRoot()
                        authManager.logout()
                    }
                }
            }
        } message: {
            Text("are_you_sure_logout".localized())
        }
    }
    
    private  var header: some View {
              HStack {
                  SupportButton()
                  
                  Spacer()
                  
                  Text("profile")
                      .padding(5)
                      .font(.title)
                      .foregroundStyle(.white)
                  
                  Spacer()
                  
                  Button(action: {
                      if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                          if UIApplication.shared.canOpenURL(appSettings) {
                              UIApplication.shared.open(appSettings)
                          }
                      }
                  }) {
                      Image(systemName: "globe")
                          .foregroundStyle(.white)
                  }.padding(.horizontal)
                  
              }
              .background(.appPrimary)
          }

    private var profileImageSection: some View {
        VStack(spacing: 12) {
            AppImage(
                urlString: vm.nurseProfile?.imageUrl,
                width: 120,
                height: 120,
                contentMode: .fill,
                shape: Circle()
            )
            .accessibilityLabel("Profile Image")
            .padding(.top, 16)

            Text("\(vm.nurseProfile?.firstName ?? "") \(vm.nurseProfile?.lastName ?? "")")
                .font(.title2)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .backgroundCard(cornerRadius: 24, shadowRadius: 1)
        .padding(.bottom, 8)
    }

    private var statusToggle: some View {
           return Toggle(isOn: Binding(
               get: { !isBusy },
               set: { isOnline in
                   isBusy = !isOnline
                   Task {
                       await vm.changeStatus(isBusy: isBusy){ result in
                           if !result {
                               isBusy = !isBusy// revert the toggle state if the change fails
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
           .padding(.vertical, 8)
           .accessibilityLabel("Status Toggle")
       }
    
    private var updateLocationButton: some View {
        Button(action: {
            guard let location = LocationManager.shared.location else { return }
            Task {
                await vm.updateLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
        }) {
            HStack {
                Image(systemName: "location.fill")
                Text("update_my_location".localized())
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(AppButton(kind: .border))
        .accessibilityLabel("Update My Location")
    }

    private var logoutButton: some View {
        Button(action: {
            showAlertLogout.toggle()
        }) {
            HStack {
                Image(systemName: "arrowshape.turn.up.left.fill")
                Text("logout".localized())
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(AppButton(kind: .solid))
        .accessibilityLabel("Logout")
    }
}

#Preview {
    let vm = NuresProfileVM()
    vm.nurseProfile = NurseProfile.mockNurseProfile
    return
         NuresProfileScreen()
            .environmentObject(vm)

            .environment(\.locale, .init(identifier: "ar")) // "ar" for Arabic, "fr" for French, etc.

    
}
