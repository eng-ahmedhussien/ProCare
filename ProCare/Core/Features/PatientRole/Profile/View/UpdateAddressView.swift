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
  
    @Environment(\.openURL) var openURL
    @FocusState private var isFocused: Bool
    @State private var showLocationAlert = false
    
    var body: some View {
        content
            .padding(.vertical)
            //.background(.appBackground)
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
            .onTapGesture {
                isFocused = false
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
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 20) {
            
            DropdownListView(
                selectedId: $vm.selectedGovernorate,
                placeholder: "governorate",
                options: vm.governorates
            ).padding(.vertical)
            
            
            DropdownListView(
                selectedId: $vm.selectedCity,
                placeholder: "city",
                options:  vm.citys
            ).padding(.vertical)
            
            addressDetails
            
            Spacer()
            
            saveButton
        }
    }
}

extension UpdateAddressView {
    
    var addressDetails: some View {
        VStack(alignment: .leading, spacing : 10){
//            Text("detailed_address")
//                .font(.body)
//                .foregroundStyle(.appText)
            
            AppTextEditor(
                text:  $vm.addressInDetails,
                placeholder: "add_address".localized(),
                isFocused:$isFocused
            )
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

                    showToast("update location successfuly", appearance: .success,position: .center)
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
        var vm = ProfileVM()
        vm.governorates = Governorates.mockList
        vm.citys = City.mockList
      return  UpdateAddressView().environmentObject(vm)
    }
}
