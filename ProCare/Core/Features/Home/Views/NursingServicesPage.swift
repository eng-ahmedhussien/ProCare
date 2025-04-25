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
            LazyVStack(spacing: 12) {
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
                        
                        VStack(alignment: .leading){
                            Text(nursingServices.name ?? "No Title")
                                .font(.headline)
                                .bold()
                            
                            Text(nursingServices.description ?? "No Description Available")
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                    .cardBackground(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
                }
                 .padding(.horizontal)
            }
            .padding(.top)
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
    let mockVM = HomeVM()
    let mockNursingServices: [NursingServices] = [
           NursingServices(
               fromCallCenter: true,
               categoryId: 1,
               id: 101,
               name: "Home Visit",
               description: "A nurse will visit your home for basic medical assistance.",
               imageUrl: "https://example.com/images/home_visit.jpg"
           ),
           NursingServices(
               fromCallCenter: false,
               categoryId: 2,
               id: 102,
               name: "Wound Dressing",
               description: "Professional wound care and dressing changes.",
               imageUrl: "https://example.com/images/wound_dressing.jpg"
           ),
           NursingServices(
               fromCallCenter: true,
               categoryId: 3,
               id: 103,
               name: "IV Therapy",
               description: "Administration of intravenous fluids or medications.",
               imageUrl: "https://example.com/images/iv_therapy.jpg"
           ),
           NursingServices(
               fromCallCenter: false,
               categoryId: 1,
               id: 104,
               name: "Postoperative Care",
               description: "Monitoring and assistance after surgery at home.",
               imageUrl: "https://example.com/images/post_op_care.jpg"
           ),
           NursingServices(
               fromCallCenter: true,
               categoryId: 4,
               id: 105,
               name: "Elderly Care",
               description: "Comprehensive care services for elderly patients.",
               imageUrl: "https://example.com/images/elderly_care.jpg"
           )
       ]
    mockVM.subCategories = mockNursingServices
    return NursingServicesPage(vm: mockVM, id: 2)
}
