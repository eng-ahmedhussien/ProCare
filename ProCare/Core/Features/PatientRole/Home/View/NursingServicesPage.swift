//
//  NursingServicesPage.swift
//  ProCare
//
//  Created by ahmed hussien on 21/04/2025.
//

import SwiftUI

struct NursingServicesPage: View {
    @EnvironmentObject var vm : HomeVM
    @EnvironmentObject var ordersVM: OrdersVM
    @EnvironmentObject var appRouter: AppRouter
    @State private var isLoading = true
    var id  = 0
    
    @State var isSelected = false
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
                            Text(nursingServices.name ?? "no_title".localized())
                                .font(.headline)
                                .bold()
                            
                            Text(nursingServices.description ?? "no_description".localized())
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                    .backgroundCard(color: .white, cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
                    .onTapGesture {
                        if nursingServices.fromCallCenter ?? false{
                            debugPrint(nursingServices.name ?? "")
                        }else {
                            switch nursingServices.id {
                            case 1 :
                                if let order =  ordersVM.currentOrder{
                                    showToast("you have currently request with id \(order.id ?? "")", appearance: .error)
                                }else{
                                    appRouter.pushView(
                                        ServiceListPage(id: nursingServices.id ?? 0)
                                            .environmentObject(vm)
                                    )
                                }
                            case 2 :
                                appRouter.pushView(
                                    ReservationScreen()
                                        .environmentObject(vm)
                                )
                                debugPrint(nursingServices.name ?? "")
                            default:
                                debugPrint(" not supported")
                            }
                        }
                    }
                }
                 .padding(.horizontal)
                 
            }
            .padding(.top)
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
                Task {
                    await loadData()
                    await ordersVM.fetchCurrentOrder()
                }
        }
        .refreshable {
            Task {
                await loadData()
            }
        }
        
       .appNavigationBar(title: "nursing_services")
    }
    
    
    private func loadData() async {
        vm.fetchSubCategories(for: id)
        isLoading = false
    }
}


#Preview {
    let mockVM = HomeVM()
    mockVM.subCategories = NursingServices.mockList
    return NursingServicesPage( id: 2).environmentObject(mockVM)
}
