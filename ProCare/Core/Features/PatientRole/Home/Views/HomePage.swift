//
//  HomePage.swift
//  ProCare
//
//  Created by ahmed hussien on 18/04/2025.
//

import SwiftUI

struct HomePage: View {
    
    @StateObject var vm: HomeVM
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var locationManager: LocationManager
    
    
    @State  var isLoading = true

    var body: some View {
        VStack(spacing: 0) {
            header
            
            ScrollView {
                services
            }
        }
 
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear{
            Task {
                await loadData()
            }
        }
        .refreshable {
           Task {
                await loadData()
            }
        }
        
    }

   private func loadData() async {
       guard authManager.isLoggedIn else {
           debugPrint("⚠️ User not logged in — skipping .task")
           return
       }
       await vm.getCategories {
           authManager.logout()
       }
        isLoading = false
    }

}

extension HomePage{
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
                    }
                    .buttonStyle(AppButton(kind: .plain))
                }
                
                HStack {
                    if  let location: Profile = AppUserDefaults.shared.getCodable(Profile.self, forKey: .profileData) {
                        Image(.location)
                        Text("\(location.governorate ?? ""), \(location.city ?? "")")
                            .lineLimit(2)
                    } else {
                        Image(.location)
                        Text("unknown location")
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
    }
    
    var services: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("services")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.horizontal)
            
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(vm.categories, id: \.id) { category in
                            ServiceIconView(title: category.name ?? "", icon: category.imageUrl ?? "")
                                .onTapGesture {
                                    switch category.id {
                                    case 2:
                                        appRouter.pushView(NursingServicesPage(id: category.id ?? 0).environmentObject(vm))
                                    case 3:
                                        debugPrint("ambulance")
                                    case 4:
                                        debugPrint("doctor")
                                    case 5:
                                        debugPrint("pharmacy")
                                    case .none:
                                        debugPrint("none")
                                    case .some(_):
                                        debugPrint("some")
                                    }
                                }
                        }
                        .padding(.horizontal)
                    }
                }
        }
    }
}

#Preview {
    let vm = HomeVM()
    vm.categories = Category.mockCategories
    return HomePage(vm: vm, isLoading: false)
        .environmentObject(AuthManager())
        .environmentObject(AppRouter())
        .environmentObject(LocationManager())
}

enum SubCategories: Int {
    case nursing = 2
    case ambulance = 3
    case doctor = 4
    case pharmacy = 5
}
