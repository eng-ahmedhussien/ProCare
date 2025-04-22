//
//  HomePage.swift
//  ProCare
//
//  Created by ahmed hussien on 18/04/2025.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var authManager = AuthManager.shared
    @StateObject var vm = HomeVM()
    @State private var isLoading = true
    @State private var refreshTask: Task<Void, Never>? // for refreshable problem
    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                services
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .task {
            refreshTask?.cancel() // Cancel any previous
            refreshTask = Task {
                await loadData()
            }
        }
        .refreshable {
            refreshTask?.cancel()
            refreshTask = Task {
                await loadData()
            }
        }
        
    }

   private func loadData() async {
       guard authManager.isLoggedIn else {
           debugPrint("⚠️ User not logged in — skipping .task")
           return
       }
         await vm.getCategories()
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
                    
                    Text("hello \(authManager.userData?.firstName ?? "")")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(.location)
                    Text("cairo 114")
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
        VStack(alignment: .trailing, spacing: 20){
            Text("services")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.trailing)
            
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(vm.categories, id: \.id) { category in
                            ServiceIconView(title: category.name ?? "", icon: category.imageUrl ?? "")
                                .onTapGesture {
                                    switch category.id {
                                    case 2:
                                        appRouter.pushView(NursingServicesPage(vm: vm, id: category.id ?? 0))
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
    HomePage()
}

enum SubCategories: Int {
    case nursing = 2
    case ambulance = 3
    case doctor = 4
    case pharmacy = 5
}
