    //
    //  HomeScreen.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 18/04/2025.
    //

import SwiftUI

struct HomeScreen: View {
    @StateObject var vm = HomeVM()
    @StateObject var reviewVM = ReviewVM()
    @StateObject var pharmaciesVM = PharmaciesVM()
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var profileVM: ProfileVM
    
    @State private var isRefreshingLocation = false
    @State private var showReviewSheet: Bool = false
    
    var body: some View {
        VStack{
            header
            content
        }.onFirstAppear {
            Task{
                await reviewVM.getLastRequestIdNotReviewed { requestId in
                    Task{
                        await  vm.getRequestById(requestId: requestId)
                    }
                    showReviewSheet.toggle()
                }
            }
        }
        .sheet(isPresented: $showReviewSheet) {
            if let order =  vm.lastOrder  {
                ReviewPromptSheet(
                    showSheet: $showReviewSheet,
                    order: order
                )
                .environmentObject(reviewVM)
            }
        }
        
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.loadingState {
        case .idle:
            Color.clear.onAppear {
                fetchHomeData()
            }
            
        case .loading:
            categoriesList
                .redacted(reason: .placeholder)
            
        case .loaded:
            categoriesList
            
        case .failed(let message):
            VStack {
                Spacer()
                RetryView(message: message){
                    fetchHomeData()
                }
                Spacer()
            }
        }
    }
    
    fileprivate func fetchHomeData()  {
        Task {
            async let fetchCategories: () = vm.fetchCategories {
                Task {
                    await MainActor.run {
                        authManager.logout()
                        debugPrint("Unauthorized access")
                    }
                }
            }
            async let fetchProfile: () = profileVM.fetchProfile()
            _ = await (fetchCategories, fetchProfile)
        }
    }
    
    
    
    fileprivate func handleCategoryTap(_ id: Int) {
        switch id {
        case 2:
            let nursingView = NursingServicesPage(id: 2)
                .environmentObject(vm)
            appRouter.pushView(nursingView)
        case 3,4:
                //3 ambulance
                //4 doctor
            showAlert(
                title: "alert".localized(),
                message: "this_feature_coming_soon".localized()
            )
        case 5:
            let PharmaciesScreen = PharmaciesScreen(vm: pharmaciesVM)
            appRouter.pushView(PharmaciesScreen)
        default:
            debugPrint("Unhandled category ID: \(id )")
        }
    }
    
    var categoriesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.categories, id: \.id) { category in
                    CategoryCard(category: category) {
                        guard let id = category.id else { return  debugPrint("error no category id")}
                        handleCategoryTap(id)
                    }
                }
            }
            .padding()
        }
        .refreshable {
            fetchHomeData()
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

