//
//  NursesListView.swift
//  ProCare
//
//  Created by ahmed hussien on 24/04/2025.
//

import SwiftUI


struct NursesListPage: View {
    @StateObject var vm: NursesVM = NursesVM()
    
    var body: some View {
        ZStack {
            content
        }
        .appNavigationBar(title: "")
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
                    ForEach(vm.nurseList, id: \.id) { nurse in
                        NurseCellView(nurse: nurse)
                            .onAppear {
                                if nurse.id == vm.nurseList.last?.id, vm.hasNextPage {
                                    Task {
                                        await vm.fetchNurses(loadType: .paging)
                                    }
                                }
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
                
                Text("Error: \(message)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Button("Retry") {
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
            Text("لا توجد ممرضات حالياً")
                .foregroundColor(.gray)
        }
        .padding()
    }
}


#Preview {
    let mockVM = NursesVM()
    mockVM.nurseList = MockManger.shared.NursesListMockModel
    return NursesListPage(vm: mockVM)
}


