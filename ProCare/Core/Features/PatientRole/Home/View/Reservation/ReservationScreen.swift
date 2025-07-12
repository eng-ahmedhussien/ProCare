//
//  AppointmentModel.swift
//  ProCare
//
//  Created by ahmed hussien on 12/06/2025.
//

import SwiftUI


struct ReservationScreen: View {
    
    @EnvironmentObject var vm: HomeVM
    @EnvironmentObject var appRoute: AppRouter
    @FocusState private var isFocused: Bool
    
    private var minSelectableTime: Date {
        let calendar = Calendar.current
        if calendar.isDateInToday(vm.date) {
            return max(vm.date, Date())
        } else {
            return calendar.startOfDay(for: vm.date)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                dateSection
                timeSection
                noteSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
        .safeAreaInset(edge: .bottom) {
            submitButton
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(.regularMaterial)
        }
        .onTapGesture {
            isFocused = false
        }
        .appNavigationBar(title: "new_appointment")
    }
}

extension ReservationScreen {
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "date", icon: "calendar")
            
            DatePicker(
                selection: $vm.date,
                in: Date()...,
                displayedComponents: .date
            ) {
                EmptyView()
            }
            .datePickerStyle(.compact)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "time", icon: "clock")
            
            DatePicker(
                selection: $vm.time,
                in: minSelectableTime...,
                displayedComponents: .hourAndMinute
            ) {
                EmptyView()
            }
            .datePickerStyle(.compact)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "note", icon: "note.text")
            
            AppTextEditor(
                text: $vm.note,
                placeholder: "enter_your_note".localized(),
                height: 120,
                isFocused: $isFocused
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Text(title.localized())
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
    
    private var submitButton: some View {
        Button {
            Task {
                await vm.submitReservation {
                    appRoute.popToRoot()
                }
            }
        } label: {
            Text("submit".localized())
        }
        .buttonStyle(AppButton())
    }
}

#if DEBUG
#Preview {
    NavigationView{
        ReservationScreen()
            .environmentObject(HomeVM())
            .environment(\.locale, .init(identifier: "ar"))
            .environment(\.layoutDirection, .rightToLeft)
    }
}
#endif

