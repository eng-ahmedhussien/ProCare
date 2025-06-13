//
//  AppointmentModel.swift
//  ProCare
//
//  Created by ahmed hussien on 12/06/2025.
//

import SwiftUI

struct ReservationScreen: View {
    
    @EnvironmentObject var vm: HomeVM
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 0){
                Text("date")
                    .font(.title3)
                    .foregroundStyle(.appText)
                    .padding(.horizontal)
                
                DatePicker(selection: $vm.date,displayedComponents: .date) {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
                .padding()
                .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .black)
                .padding()
            }
            
            VStack(alignment: .leading,spacing: 0){
                Text("time")
                    .font(.title3)
                    .foregroundStyle(.appText)
                    .padding(.horizontal)
                
                DatePicker(selection: $vm.time,displayedComponents:  .hourAndMinute) {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                .padding()
                .backgroundCard(cornerRadius: 10, shadowRadius: 1, shadowColor: .black)
                .padding()
            }
            
            VStack(alignment: .leading,spacing: 0){
                Text("note")
                    .font(.title3)
                    .foregroundStyle(.appText)
                    .padding(.horizontal)
                
                AppTextEditor(
                    text: $vm.note,
                    placeholder: "Enter your note",
                    height: 150,
                    isFocused: $isFocused
                )
                .padding()
            }
         
            
            Spacer().frame(height: 50)
            
            Button("Submit") {
                debugPrint("Date = \(vm.date.toAPIDateString())")
                debugPrint("Time = \(vm.time.toAPITimeString())")
            }
            .buttonStyle(AppButton())
            .padding()
        }
        .padding(.vertical, 20)
        .onTapGesture {
            isFocused = false
        }
        .background(.appBackground)
        .appNavigationBar(title: "new_appointment")
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
