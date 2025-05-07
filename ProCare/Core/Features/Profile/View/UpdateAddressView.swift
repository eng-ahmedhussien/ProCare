//
//  UpdateAddressView.swift
//  ProCare
//
//  Created by ahmed hussien on 04/05/2025.
//


import SwiftUI

struct UpdateAddressView: View {
    
    @ObservedObject var vm: ProfileVM
    @EnvironmentObject var locationManager: LocationManager
    
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
            
            LocationButton
            saveButton
        }
        .padding(.vertical)
        .appNavigationBar(title: "update location".localized())
        .onFirstAppear {
            Task {
                await vm.fetchGovernorates()
            }
        }
//        .onChange(of: vm.selectedGovernorate ?? 0) { oldValue, newValue in
//            vm.fetchCityByGovernorateId(id: newValue)
//        }
        .onChange(of: vm.selectedGovernorate ?? 0) { id in
            Task {
                await vm.fetchCityByGovernorateId(id: id)
            }
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
    
    var LocationButton: some View {
        Button(action: {
//            locationManager.shouldShowLocationDeniedPopup{
//                
//            }
        }) {
            HStack {
                Image(.location)
                Text("get my location".localized())
            }
        }
        .buttonStyle(.border, width: 300)
    }
    
    var saveButton: some View {
        Button(action: {
            Task{
                await vm.updateProfile()
            }
        }) {
            Text("save".localized())
        }.buttonStyle(.solid, width: 300)
    
    }
    
//    private func getGovernorates(for governorate: [Governorates]) -> [String] {
//        return governorate.map { $0.name ?? "" }
//    }
//    
//    private func getCites(for cites: [City]) -> [String] {
//        return cites.map { $0.nameEn ?? "" }
//    }
    
}


#Preview{
    NavigationStack{
        UpdateAddressView(vm: ProfileVM())
    }
}

