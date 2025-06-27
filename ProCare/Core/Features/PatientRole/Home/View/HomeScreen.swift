//
//  HomeScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 18/04/2025.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var vm = HomeVM()
    @StateObject var pharmaciesVM = PharmaciesVM()
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack{
            header
            content
        }
       // .background(.appBackground)
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.loadingState {
        case .idle:
            Color.clear.onAppear {
                vm.fetchCategories {
                    authManager.logout()
                    debugPrint("Unauthorized access")
                }
            }
            
        case .loading:
            categoriesList
                .redacted(reason: .placeholder)
            
        case .loaded:
            categoriesList
            
        case .failed(let message):
            VStack(spacing: 16) {
                Text(message)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Try Again") {
                    vm.fetchCategories {
                        authManager.logout()
                        debugPrint("Unauthorized access")
                    }
                }.foregroundStyle(.appPrimary)
                
            }
        }
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.categories, id: \.id) { category in
                    CategoryCard(category: category) {
                        switch category.id {
                        case 2:
                            let nursingView = NursingServicesPage(id: category.id ?? 0)
                                .environmentObject(vm)
                            appRouter.pushView(nursingView)
                        case 3:
                            debugPrint("ambulance")
                        case 4:
                            debugPrint("doctor")
                        case 5:
                            let PharmaciesScreen = PharmaciesScreen(vm: pharmaciesVM)
                            appRouter.pushView(PharmaciesScreen)
                        default:
                            debugPrint("Unhandled category ID: \(category.id ?? 0 )")
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            vm.fetchCategories {
                authManager.logout()
                debugPrint("Unauthorized access")
            }
        }
    }
}
extension HomeScreen{
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
                    
                    Spacer()
                }
                
                HStack {
                    if  let location: Profile = AppUserDefaults.shared.getCodable(Profile.self, forKey: .profileData) {
                        Image(.location)
                        Text("\(location.governorate ?? ""), \(location.city ?? "")")
                            .lineLimit(2)
                    } else {
                        Image(.location)
                        Text("unknown_location")
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
}



#if DEBUG
#Preview {
    HomeScreen(vm: HomeVM.preview)
        .environmentObject(AuthManager())
        .environmentObject(AppRouter())
       // .environmentObject(LocationManager())
    
}
#endif

enum SubCategories: Int {
    case nursing = 2
    case ambulance = 3
    case doctor = 4
    case pharmacy = 5
}

