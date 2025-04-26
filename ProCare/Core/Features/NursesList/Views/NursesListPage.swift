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
            ScrollView {
                LazyVStack(spacing: 0) {
                    if vm.viewState == .empty {
                        emptyView
                    } else {
                        ForEach(vm.nurseList, id: \.id) { nurse in
                            NurseCellView(nurse: nurse)
                                .onAppear {
                                    if nurse.id == vm.nurseList.last?.id {
                                        Task {
                                            await vm.fetchNurses()
                                        }
                                    }
                                }
                        }
                        .redacted(reason: vm.viewState == .loading ? .placeholder : [])

                        if vm.viewState == .loading && !vm.nurseList.isEmpty {
                            ProgressView()
                                .appProgressStyle(color: .appPrimary)
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                if vm.nurseList.isEmpty {
                    Task {
                        await vm.fetchNurses()
                    }
                }
            }
            .refreshable {
                Task {
                    await vm.fetchNurses()
                }
            }

            if vm.viewState == .loading && vm.nurseList.isEmpty {
                ProgressView()
                    .appProgressStyle(color: .appPrimary)
            }
        }
        .appNavigationBar(title: "")
    }
}

extension NursesListPage {
    
    var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclam")
                .font(.largeTitle)
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


