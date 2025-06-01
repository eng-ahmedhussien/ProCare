//
//  UpdateAddressView.swift
//  ProCare
//
//  Created by ahmed hussien on 04/05/2025.
//


import SwiftUI

struct UpdateAddressView: View {
    
    @EnvironmentObject var vm: ProfileVM
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var appPopUp: AppPopUp
  
    @Environment(\.openURL) var openURL
    @State private var showLocationAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            DropdownListView(
                selectedId: $vm.selectedGovernorate,
                options: vm.governorates
            )
            
            
            DropdownListView(
                selectedId: $vm.selectedCity,
                options:  vm.citys
            )
            
            addressDetails
            
            Spacer()
            
           // LocationButton
            saveButton
        }
        .padding(.vertical)
        .appNavigationBar(title: "update_location".localized())
        .onFirstAppear {
            Task {
                await vm.fetchGovernorates()
            }
        }
        .onChange(of: vm.selectedGovernorate ?? 0) { id in
            Task {
                await vm.fetchCityByGovernorateId(id: id)
            }
        }
        .alert("location_required".localized(), isPresented: $showLocationAlert) {
            Button("open_settings".localized()) {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    openURL(appSettings)
                }
            }
            Button("cancel".localized(), role: .cancel) {}
        } message: {
            Text("location_permission_message".localized())
        }
    }
}

extension UpdateAddressView {
    
    var addressDetails: some View {
        VStack(alignment: .leading, spacing : 10){
            Text("detailed_address")
                .font(.body)
            TextEditor(text: $vm.addressInDetails)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
        .padding()
    }
    
    var saveButton: some View {
        Button("save") {
            if locationManager.isPermissionDenied {
                showLocationAlert.toggle()
            }else{
                Task{
                    guard let location = locationManager.location else { return }
                    let lat = String(location.coordinate.latitude)
                    let lon = String(location.coordinate.longitude)
                    await vm.updateProfile(updateKind: .location, latitude: lat, longitude: lon)
                    appRouter.pop()
                }
            }
        }
        .buttonStyle(AppButton(kind: .solid))
        .padding(.horizontal)
    }
}


#Preview{
    NavigationStack{
        UpdateAddressView().environmentObject(ProfileVM())
    }
}
