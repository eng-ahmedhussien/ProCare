//
//  ProfilePage.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject var vm: ProfileVM
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    
    @State private var isEditingUserInfo: Bool = false
    @State private var isEditingLocation: Bool = false
    @State private var uploadImage: Bool = false
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    private var isFormValid: Bool {
        ValidationRule.isEmpty.validate(vm.firstName) == nil &&
        ValidationRule.isEmpty.validate(vm.lastName) == nil
    }
    var body: some View {
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .center, spacing: 20) {
                profileImage
                userInfo
            }
            .padding()
            .backgroundCard(cornerRadius: 10, shadowRadius: 4, shadowColor: .secondary, shadowX: 2, shadowY: 2)
            .padding()
            
            locationView
            
            buttons

        }
        .background(.gray.opacity(0.1))
        .onAppear {
            Task{
               await  vm.getProfile()
            }
        }
    }
}


extension ProfilePage{
    var profileImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 180, height: 180)
                .foregroundColor(.appPrimary)
            
            Button(action: {
                // Handle image edit
            }) {
                Image(systemName: "person.crop.square.badge.camera.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var userInfo: some View {
        VStack(spacing: 15){
            HStack {
                Text("User Info")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isEditingUserInfo.toggle()
                }) {
                    Image(systemName: isEditingUserInfo ? "xmark" : "pencil.and.ellipsis.rectangle")
                        .foregroundStyle(.appPrimary)
                }
            }
            .foregroundStyle(.appPrimary)
            
            HStack {
                Text("First Name:")
                Spacer()
                TextField("", text: $vm.firstName)
                    .foregroundStyle(isEditingUserInfo ? .secondary : Color.black)
                    .multilineTextAlignment(.trailing)
                    .disabled(!isEditingUserInfo)
            }
           
            HStack {
                Text("Last Name:")
                Spacer()
                TextField("", text: $vm.lastName)
                    .foregroundStyle(isEditingUserInfo ? .secondary : Color.black)
                    .multilineTextAlignment(.trailing)
                    .disabled(!isEditingUserInfo)
            }
            
            HStack {
                if isEditingUserInfo {
                    Picker("Gender", selection: $vm.gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.displayName).tag(gender)
                        }
                    }
                    .pickerStyle(.menu)
                    
                } else {
                    if let gender = vm.gender, gender != .notSpecified {
                        Text(gender.displayName)
                    } else {
                        Text("No selected")
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
          
                if isEditingUserInfo {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { vm.dateOfBirth ?? vm.minimumDate },
                            set: { vm.dateOfBirth = $0 }
                        ),
                        in: ...vm.minimumDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                } else {
                    if let dob = vm.dateOfBirth {
                        Text(dob.formatted(date: .abbreviated, time: .omitted))
                    } else {
                        Text("No selected")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    var locationView: some View {
        VStack(spacing: 15){
            HStack {
                Text("User location")
                    .font(.headline)
                Spacer()
                
                Button(action: {
                    appRouter.pushView(UpdateAddressView())
                }) {
                    Image(systemName: "pencil.and.ellipsis.rectangle")
                        .foregroundStyle(.appPrimary)
                }
            }.foregroundStyle(.appPrimary)
            
            if let location = vm.location {
                Text("\(location)")
                    .font(.body)
            }else{
                Text("No selected")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 3, shadowColor: .secondary, shadowX: 2, shadowY: 2)
        .padding()
    }
    
    @ViewBuilder
    var buttons: some View {
        if isEditingUserInfo {
            Button("Update Profile") {
                withAnimation {
                    isEditingUserInfo = false
                }
                Task{
                    await vm.updateProfile()
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .buttonStyle(AppButton(kind: .solid,width: 300,disabled: !isFormValid))
            .disabled(!isFormValid)
            .padding()
        }else {
            VStack() {
                
                HStack{
                    Button("change Password".localized()) {

                    }
                    .foregroundStyle(.appPrimary)
                    .buttonStyle(AppButton(kind: .border,width: screenWidth / 2.7))
                    
                    Button("Logout".localized()) {
                        appRouter.popToRoot()
                        authManager.logout()
                    }
                    .buttonStyle(AppButton(kind: .solid,width: screenWidth / 2.7))
                }
                
                Button("Delete Account".localized()) {
                    Task{
                        await vm.deleteProfile(){
                            appRouter.popToRoot()
                            authManager.logout()
                        }
                    }
                }
                .padding()
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        
    }
}


#Preview {
    NavigationView{
        ProfilePage()
    }
}
