//
//  OrdersView.swift
//  ProCare
//
//  Created by ahmed hussien on 15/05/2025.
//

import SwiftUI
import CoreLocation

struct OrdersTapScreen: View {
    
    @EnvironmentObject var vm: OrdersVM
    @EnvironmentObject var locationManger: LocationManager
    @State var segmentationSelection : ProfileSection = .CurrentRequest
    @State private var etaMinutes: Int? = nil
 
    init() {
        configSegmentedControl()
    }
    
    var body: some View {
        VStack{
            header
            Picker("", selection: $segmentationSelection) {
                ForEach(ProfileSection.allCases, id: \.self) { option in
                    Text(option.localized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if segmentationSelection == .CurrentRequest {
                currentOrderCellView(vm: vm)
            } else {
                ZStack {
                    OrdersListView(vm: vm)
                }
            }
            Spacer()
        }
        .onAppear{
            Task{
                await vm.fetchCurrentOrder()
            }
        }
        .refreshable {
            Task {
                await vm.fetchCurrentOrder()
            }
        }
    }
    
    enum ProfileSection : String, CaseIterable {
        case PreviousRequests = "previous_requests"
        case CurrentRequest = "current_request"
        
        var localized: String {
            self.rawValue.localized()
        }
    }
}

//MARK: view
extension OrdersTapScreen{
    var header: some View {
        HStack {
            Spacer()
            Text("orders".localized())
                .font(.title)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.vertical)
        .background(.appPrimary)
    }
}

//MARK: helper
extension OrdersTapScreen{
    func configSegmentedControl() {
        let selectedAttributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: UIColor.white
          ]
          let normalAttributes: [NSAttributedString.Key: Any] = [
              .foregroundColor: UIColor.gray
          ]
          
        UISegmentedControl.appearance().selectedSegmentTintColor = .appPrimary
        UISegmentedControl.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

//#Preview {
//    let vm = OrdersVM()
//    vm.currentOrder = Order(id: "1", nurseName: "ahmed", nursePicture: "", phoneNumber: "012345678", nurseId: "1", status: "", speciality: "nures", longitude: "", latitude: "", nurseLongitude: "", nurseLatitude: "", createdAt: "1/2/2030", totalPrice: 20)
//    NavigationStack{
//        OrdersTapScreen(vm: vm).environmentObject(LocationManager())
//    }
//}
