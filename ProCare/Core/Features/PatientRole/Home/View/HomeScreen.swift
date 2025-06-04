//
//  HomeScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 18/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject  var viewModel = HomeVM()
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack{
            header
            content
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.loadingState {
        case .idle:
            Color.clear.onAppear {
                viewModel.fetchCategories {
                    authManager.logout()
                    print("Unauthorized access")
                }
            }
            
        case .loading:
            VStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                Spacer()
            }
            
        case .loaded:
            categoriesList
            
        case .failed(let message):
            VStack(spacing: 16) {
                Text(message)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Try Again") {
                    viewModel.fetchCategories {
                        authManager.logout()
                        print("Unauthorized access")
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.categories, id: \.id) { category in
                    CategoryCard(category: category) {
                        switch category.id {
                        case 2:
                            let nursingView = NursingServicesPage(id: category.id ?? 0)
                                .environmentObject(viewModel)
                            appRouter.pushView(nursingView)
                        case 3:
                            debugPrint("ambulance")
                        case 4:
                            debugPrint("doctor")
                        case 5:
                            debugPrint("pharmacy")
                        default:
                            debugPrint("Unhandled category ID: \(category.id ?? 0 )")
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            viewModel.fetchCategories {
                authManager.logout()
                print("Unauthorized access")
            }
        }
    }
}
extension HomeView{
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Image(.profile)
                        .padding(.trailing)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("hello".localized() + "\(authManager.userDataLogin?.firstName ?? "")")
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

struct CategoryCard: View {
    let category: Category
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(spacing: 8) {
                AppImage(
                    urlString: category.imageUrl ?? "",
                    width: 50,
                    height: 50
                 
                )
                .foregroundStyle(.appPrimary)
                
                Text(category.name ?? "Unknown Category")
                    .font(.headline)
                    .foregroundStyle(.appPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.service)
                    .shadow(radius: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthManager())
            .environmentObject(AppRouter())
            .environmentObject(LocationManager())
    }
}
#endif 

enum SubCategories: Int {
    case nursing = 2
    case ambulance = 3
    case doctor = 4
    case pharmacy = 5
}
