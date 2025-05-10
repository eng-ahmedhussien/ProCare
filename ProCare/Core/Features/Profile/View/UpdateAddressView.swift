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
    @EnvironmentObject var appRouter: AppRouter
    
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
        .buttonStyle(AppButton(kind: .border,width: 300))
    }
    
    var saveButton: some View {
        Button(action: {
            Task{
                await vm.updateProfile()
                appRouter.pop()
            }
        }) {
            Text("save".localized())
        }
        .buttonStyle(AppButton(kind: .solid,width: 300))
    
    }
}


#Preview{
    NavigationStack{
        UpdateAddressView(vm: ProfileVM())
    }
}
