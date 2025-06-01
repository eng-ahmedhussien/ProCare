//
//  NursesListScreen.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import SwiftUI
import CoreLocation

struct NursesListScreen: View {
    @StateObject var vm: NursesVM = NursesVM()
    @EnvironmentObject var locationManger: LocationManager
    @EnvironmentObject var appRouter: AppRouter
    var servicesIds: [ServiceItem] = []
    
    private var sortedNurses: [Nurse] {
        guard let userLocation = locationManger.location else {
            return vm.nurseList
        }

        let sorted = vm.nurseList.sorted {
            guard let loc1 = $0.coordinate else { return false }
            guard let loc2 = $1.coordinate else { return true }
            return loc1.distance(from: userLocation) < loc2.distance(from: userLocation)
        }

        // Print distances once
//        for nurse in sorted {
//            if let nurseLoc = nurse.coordinate {
//                let distance = nurseLoc.distance(from: userLocation) / 1000
//                print("Distance to \(nurse.fullName ?? "N/A"): \(distance) km")
//            }
//        }

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
        switch vm.viewState {
        case .initialLoading:
            ProgressView()
                .appProgressStyle(color: .appPrimary)
                .padding()
            
        case .pagingLoading, .refreshing, .loaded:
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sortedNurses, id: \.id) { nurse in
                        NurseCellView(nurse: nurse)
                            .onAppear {
                                if nurse.id == vm.nurseList.last?.id, vm.hasNextPage {
                                    Task {
                                        await vm.fetchNurses(loadType: .paging)
                                    }
                                }
                            }
                            .onTapGesture {
                                appRouter.pushView(NurseDetailsScreen(servicesIds: servicesIds, nurse: nurse))
                            }
                    }
                    .redacted(reason: vm.viewState == .pagingLoading ? .placeholder : [])
                    
                    if vm.viewState == .pagingLoading {
                        ProgressView()
                            .appProgressStyle(color: .appPrimary)
                            .padding()
                    }
                }
            }
        
        case .empty:
            emptyView
        
        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                Text("error".localized() + ": \(message)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Button("retry".localized()) {
                    Task {
                        await vm.fetchNurses(loadType: .initial)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclam")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("no_nurses_available")
                .foregroundColor(.gray)
        }
        .padding()
    }
    
//    func sortNursesByDistance(nurses: [Nurse]) -> [Nurse] {
//        guard let userLocation = locationManger.location else {
//            return nurses // fallback: show unsorted list
//        }
//        
//        return nurses.sorted {
//            guard let loc1 = $0.coordinate else { return false }
//            guard let loc2 = $1.coordinate else { return true }
//            return loc1.distance(from: userLocation) < loc2.distance(from: userLocation)
//        }
//    }
//    
    func sortNursesByDistance(nurses: [Nurse]) -> [Nurse] {
        guard let userLocation = locationManger.location else {
            return nurses
        }

        return nurses.sorted {
            guard let loc1 = $0.coordinate else { return false }
            guard let loc2 = $1.coordinate else { return true }
            
            let dist1 = loc1.distance(from: userLocation)
            let dist2 = loc2.distance(from: userLocation)

            print("Distance to \($0.fullName ?? "Nurse 1"): \(dist1 / 1000) km")
            print("Distance to \($1.fullName ?? "Nurse 2"): \(dist2 / 1000) km")

            return dist1 < dist2
        }
        
    }
}


//#Preview {
//    let mockVM = NursesVM()
//    mockVM.nurseList = MockManger.shared.NursesListMockModel
//    return NursesListScreen(vm: mockVM)
//}


