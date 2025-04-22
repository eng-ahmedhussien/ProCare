//
//  NursingServicesPage.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import SwiftUI

struct NursingServicesPage: View {
    @ObservedObject var vm : HomeVM
    @State private var isLoading = true
    @State private var refreshTask: Task<Void, Never>? // for refreshable problem
    var id  = 0

    var body: some View {
        ScrollView {
            ForEach(vm.subCategories, id: \.id){ nursingServices in
                HStack(alignment: .center){
                    AsyncImage(url: URL(string: nursingServices.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Text(nursingServices.name ?? "")
                        .font(.subheadline)
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                .cardBackground(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
            }
            .padding()
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
        
       .appNavigationBar(title: "Nursing")
    }
    
    
    private func loadData() async {
        await vm.getSubCategories(id: id)
        isLoading = false
    }
    
}

#Preview {
    NursingServicesPage(vm: HomeVM( ))
}
