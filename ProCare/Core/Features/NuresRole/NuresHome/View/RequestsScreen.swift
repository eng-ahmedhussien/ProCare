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
        @EnvironmentObject var nurseProfileVM: NuresProfileVM
        @EnvironmentObject var authManager: AuthManager
        @EnvironmentObject var appManager: AppManager
        @EnvironmentObject var appRouter: AppRouter
        @State var segmentationSelection : ProfileSection = .CurrentRequest
        @State private var isRefreshingLocation = false
        init(){
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
                .padding()
                
                if segmentationSelection == .CurrentRequest {
                    currentRequestCellView(vm: vm)
                } else {
                    ZStack {
                        RequestsListView(vm: vm)
                    }
                }
                Spacer()
            }.onAppear {
                Task{
                    await nurseProfileVM.fetchNurseProfile{
                                authManager.logout()
                        }
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
    extension RequestsScreen{
        var header: some View {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Image(.profile)
                            .padding(.trailing)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("hello".localized() + " \(authManager.userDataLogin?.firstName ?? "")")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    HStack {
                        Image(.location)
                        if LocationManager.shared.address == ""{
                            Image(systemName: isRefreshingLocation ? "location.circle.fill" : "arrow.clockwise")
                                .onTapGesture {
                                    isRefreshingLocation = true
                                    LocationManager.shared.refreshLocation()
                                }
                        }else{
                            Text("\(LocationManager.shared.address)")
                                .lineLimit(2)
                        }
                       
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                }
                Spacer()
            }
            .padding()
            .background(.appPrimary)
            .onTapGesture{
                appRouter.pushView(NuresProfileScreen())
            }
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
        return RequestsScreen().environmentObject( AuthManager())
    }
