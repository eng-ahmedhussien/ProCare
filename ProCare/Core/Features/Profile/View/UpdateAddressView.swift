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
        .appNavigationBar(title: "update location".localized())
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
        .alert("Location Required", isPresented: $showLocationAlert) {
            Button("Open Settings") {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    openURL(appSettings)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("To complete this request, we need access to your location. Please enable location permissions in Settings.")
        }
    }
}

extension UpdateAddressView {
    
    var addressDetails: some View {
        VStack(alignment: .leading, spacing : 10){
            Text("Detailed address")
                .font(.body)
            TextEditor(text: $vm.addressInDetails)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        }
        .padding()
    }
    
//    var LocationButton: some View {
//        Button(action: {
//            if locationManager.isPermissionDenied {
//                showLocationAlert.toggle()
//            }
//        }) {
//            HStack {
//                Image(.location)
//                Text("get my location".localized())
//            }
//        }
//        .buttonStyle(AppButton(kind: .border,width: 300))
//    }
    
    var saveButton: some View {
        Button(action: {
            if locationManager.isPermissionDenied {
                showLocationAlert.toggle()
            }else{
                Task{
                    guard let location = locationManager.location else { return }
                    let lat = String(location.coordinate.latitude)
                    let lon = String(location.coordinate.longitude)
                    await vm.updateProfile(latitude: lat, longitude: lon)
                    appRouter.pop()
                }
            }
        }) {
            Text("save".localized())
        }
        .buttonStyle(AppButton(kind: .solid,width: 300))
    
    }
}


#Preview{
    NavigationStack{
        UpdateAddressView().environmentObject(ProfileVM())
    }
}
