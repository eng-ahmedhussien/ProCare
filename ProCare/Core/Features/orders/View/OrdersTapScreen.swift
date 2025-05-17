//
//  OrdersView.swift
//  ProCare
//
//  Created by ahmed hussien on 15/05/2025.
//


import SwiftUI
import CoreLocation

struct OrdersTapScreen: View {
    
    @StateObject var vm = OrdersVM()
    @EnvironmentObject var locationManger: LocationManager
    @State var segmentationSelection : ProfileSection = .CurrentRequest
    @State private var etaMinutes: Int? = nil
    init(){configSegmentedControl()}
    
    var body: some View {
        VStack{

            Picker("", selection: $segmentationSelection) {
                ForEach(ProfileSection.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
                if segmentationSelection == .CurrentRequest {
                    currentRequestCard
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
        //.background(Color(.systemGray6))
        .appNavigationBar(title: "Orders".localized())
    }
    
    enum ProfileSection : String, CaseIterable {
        case PreviousRequests = "PreviousRequests"
        case CurrentRequest = "CurrentRequest"
    }
}

//MARK: view
extension OrdersTapScreen{
    var currentRequestCard: some View {
        guard let currentOrder = vm.currentOrder else { return Text("No requests".localized()) }
        return VStack {
            HStack(alignment: .top, spacing: 20){
                
                AppImage(
                    urlString: currentOrder.nursePicture,
                    width: 80,
                    height: 80,
                    contentMode: .fill,
                    shape: RoundedRectangle(cornerRadius: 10)
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text(currentOrder.nurseName ?? "")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.black)
                    
                    Text(currentOrder.speciality ?? "")
                        .font(.callout)
                       // .foregroundColor(.gray)
                        .foregroundStyle(.black)
                    
                   
                        
                        if let minutes = currentOrder.estimatedTimeMinutes {
                            HStack{
                                Image(systemName: "clock")
                                    .foregroundColor(.gray)
                                Text(String(format: "within_minutes".localized(), minutes))
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                        
                       /* if let distance = currentOrder.distance {
                            let km = distance / 1000
                        Image(systemName: "gauge.open.with.lines.needle.67percent.and.arrowtriangle.and.car")
                            .foregroundColor(.gray)
                                Text(String(format: "Distance:%.1f km".localized(), km))
                               
                                   
                        }*/
                   
                }
                
                Spacer()
            }
            
            Button {
                // TODO: Handle nurse call
                if let url = URL(string: "tel://\(vm.currentOrder?.phoneNumber ?? "")"),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
            } label: {
                HStack{
                    Image(systemName: "phone.fill")
                    Text("call the nurse".localized())
                }
            }
            .buttonStyle(AppButton(kind: .solid,width: 300))
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .appGray)
        .padding()
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
          
        UISegmentedControl.appearance().selectedSegmentTintColor = .appPrimary // Background of selected segment
          UISegmentedControl.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
          UISegmentedControl.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}


//#Preview {
//    NavigationStack{
//        OrdersView()
//    }
//}
