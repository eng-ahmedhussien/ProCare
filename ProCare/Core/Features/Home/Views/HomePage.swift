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
    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                services
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .task {
            await loadData()
        }
        .refreshable {
            await loadData()
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
