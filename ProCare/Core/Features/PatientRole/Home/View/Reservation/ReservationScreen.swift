//
//  AppointmentModel.swift
//  ProCare
//
//  Created by ahmed hussien on 12/06/2025.
//

import SwiftUI

struct ReservationScreen: View {
    
    @EnvironmentObject var vm: HomeVM
    
    var body: some View {
        VStack{
            Form {
                DatePicker("Date", selection: $vm.date, displayedComponents: .date)
                
                DatePicker("Time", selection: $vm.time, displayedComponents: .hourAndMinute)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $vm.note)
                        .padding(4)
                    if vm.note.isEmpty {
                        Text("Enter your note...")
                            .foregroundColor(.gray)
                            .padding(8)
                    }
                }
                .frame(height: 120)
            }
            Spacer()
            Button("Submit") {
                debugPrint("Date = \(vm.date.toAPIDateString())")
                debugPrint("Time = \(vm.time.toAPITimeString())")
            }.buttonStyle(AppButton())
        }
        .navigationTitle("New Appointment")
    }
}

#if DEBUG
#Preview {
    NavigationView{
        ReservationScreen()
            .environmentObject(HomeVM())
    }
}
#endif
