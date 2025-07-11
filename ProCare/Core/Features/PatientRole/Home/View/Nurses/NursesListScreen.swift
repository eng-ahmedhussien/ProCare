//
//  NursesListScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import SwiftUI
import CoreLocation

struct NursesListScreen: View {
    @EnvironmentObject var vm: HomeVM
    @EnvironmentObject var appRouter: AppRouter
    var servicesIds: [ServiceItem] = []
    var total: Int = 0 
    
    private var sortedNurses: [Nurse] {
        guard let userLocation = LocationManager.shared.location else {
            return vm.nurseList
        }

        let sorted = vm.nurseList.sorted {
            guard let loc1 = $0.coordinate else { return false }
            guard let loc2 = $1.coordinate else { return true }
            return loc1.distance(from: userLocation) < loc2.distance(from: userLocation)
        }

        return sorted
    }
    
    var body: some View {
        ZStack {
            content
        }
        .appNavigationBar(title: "nurses_list".localized())
        .onAppear {
            if vm.nurseList.isEmpty {
                Task {
                    await vm.fetchNurses(loadType: .initial)
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchNurses(loadType: .refresh)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.paginationViewState {
        case .initialLoading:
            AppProgressView()
        case .pagingLoading, .refreshing, .loaded:
            nurseList
                .redacted(reason: vm.paginationViewState == .pagingLoading ? .placeholder : [])
        case .empty:
            AppEmptyView(message: "no_nurses_available".localized())
        
        case .error(let message):
            RetryView(message: "error".localized() + ": \(message)") {
                    Task {
                        await vm.fetchNurses(loadType: .initial)
                    }
            }
        }
    }
    
    var nurseList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(vm.nurseList, id: \.id) { nurse in
                    NurseCellView(nurse: nurse, distance: getDistance(nurse))
                        .onAppear {
                            if nurse.id == vm.nurseList.last?.id, vm.hasNextPage {
                                Task {
                                    await vm.fetchNurses(loadType: .paging)
                                }
                            }
                        }
                        .onTapGesture {
                            handleTapOnNurse(nurse)
                        }
                }
               // .redacted(reason: vm.paginationViewState == .pagingLoading ? .placeholder : [])
                
                if vm.paginationViewState == .pagingLoading {
                    AppProgressView()
                }
            }
        }
    }
    
    private func handleTapOnNurse(_ nurse: Nurse) {
        if !(nurse.isBusy ?? false) {
            appRouter.pushView(
                NurseDetailsScreen(
                    servicesIds: servicesIds,
                    nurse: nurse,
                    total: total
                ).environmentObject(vm)
            )
        }else{
            showToast(
                "this_nurse_is_busy_now".localized(),
                appearance: .warning
            )
        }
    }
}

//MARK: helper
extension NursesListScreen {
    private func getDistance(_ nurse: Nurse) -> Double?{
        return {
            guard let userLocation = LocationManager.shared.location,
                  let nurseLocation = nurse.coordinate else { return nil }
            return userLocation.distance(from: nurseLocation)
        }()
    }
}


#Preview {
    let mockVM = HomeVM()
    mockVM.nurseList = NurseData.mock.items ?? []
    return NursesListScreen().environmentObject(mockVM)
}




// Print distances once
//        for nurse in sorted {
//            if let nurseLoc = nurse.coordinate {
//                let distance = nurseLoc.distance(from: userLocation) / 1000
//                print("Distance to \(nurse.fullName ?? "N/A"): \(distance) km")
//            }
//        }
