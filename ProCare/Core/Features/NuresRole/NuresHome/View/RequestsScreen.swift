//
//  OrdersTapScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 20/05/2025.
//


import SwiftUI
import CoreLocation

struct RequestsScreen: View {
    
    @StateObject var vm = RequestsVM()
    @EnvironmentObject var locationManger: LocationManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    @State var segmentationSelection : ProfileSection = .CurrentRequest
 
    init(){
        configSegmentedControl()
    }
    
    var body: some View {
        VStack{
            header
            
            Picker("", selection: $segmentationSelection) {
                ForEach(ProfileSection.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if segmentationSelection == .CurrentRequest {
                currentRequestCellView(vm: vm)
            } else {
                ZStack {
                    RequestsListView(vm: vm)
                }
            }
            Spacer()
        }
      
        .onAppear{
            Task{
                await vm.fetchCurrentRequest(){
                    authManager.logout()
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchCurrentRequest()
            }
        }
        .background(Color(.systemGray6))
    }
    
    enum ProfileSection : String, CaseIterable {
        case PreviousRequests = "PreviousRequests"
        case CurrentRequest = "CurrentRequest"
    }
}

//MARK: view
extension RequestsScreen{
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Image(.profile)
                        .padding(.trailing)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("hello \(authManager.userDataLogin?.firstName ?? "")")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    appRouter.pushView(logout())
                }
                
                HStack {
                    Image(.location)
                    Text("\(locationManger.address)")
                        .lineLimit(2)
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            }
            Spacer()
        }
        .padding()
        .background(.appPrimary)
    }
}

//MARK: helper
extension RequestsScreen{
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


#Preview {
    return RequestsScreen()
}


struct logout: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        Text("Logout")
            .onTapGesture {
                authManager.logout()
            }
    }
}
