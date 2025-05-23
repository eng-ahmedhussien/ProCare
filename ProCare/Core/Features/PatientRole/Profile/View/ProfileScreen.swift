//
//  ProfilePage.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import SwiftUI
import PhotosUI

struct ProfileTapScreen: View {
    @EnvironmentObject var vm: ProfileVM
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var isEditingUserInfo: Bool = false
    @State private var isEditingLocation: Bool = false
    @State private var openPhotoLibrary: Bool = false
    @State private var showAlertDeleteProfile = false
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    private var isFormValid: Bool {
        ValidationRule.isEmpty.validate(vm.firstName) == nil &&
        ValidationRule.isEmpty.validate(vm.lastName) == nil
    }
    var body: some View {
        VStack{
            header
            ScrollView(showsIndicators: false){
                
                VStack(alignment: .center, spacing: 20) {
                    profileImage
                    userInfo
                }
                .padding()
                .backgroundCard(cornerRadius: 10, shadowRadius: 4, shadowColor: .gray, shadowX: 2, shadowY: 2)
                .padding()
                
                locationView
                
                buttons
                
            }
        }
        .background(.gray.opacity(0.1))
        .onAppear {
            Task{
                await  vm.getProfile()
            }
        }
        .photosPicker(isPresented: $openPhotoLibrary, selection: $vm.selectedImage, matching: .images)
        .alert("Upload Image", isPresented: $vm.showUploadImageAlert) {
            Button("Cancel", role: .destructive) { }
            Button("Upload", role: .cancel) {
                Task{
                    await vm.updateProfile(updateKind: .image)
                }
            }
        }
        .alert("Delete Profile",isPresented: $showAlertDeleteProfile) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await vm.deleteProfile(){
                        appRouter.popToRoot()
                        authManager.logout()
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete your profile? This action cannot be undone.")
        }

    }
}


extension ProfileTapScreen{
    var header: some View {
        HStack {
            Spacer()
            Text("Profile")
                .padding(5)
                .font(.title)
                .foregroundStyle(.white)
            Spacer()
        }
        .background(.appPrimary)
    }
    var profileImage: some View {
        ZStack {
            AppImage(
                urlString: vm.profileImage,
                width:180 ,
                height: 180,
                contentMode: .fill,
                shape: Circle()
            )
            Button(action: {
                    openPhotoLibrary.toggle()
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .foregroundColor(.gray)
            }.offset(x: 70, y: 80)
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
                    Image(systemName: isEditingUserInfo ? "xmark" : "pencil")
                        .foregroundStyle(.appPrimary)
                }
            }
            .foregroundStyle(.appPrimary)
            
            HStack {
                Text("First Name:")
                    .font(.body)
                    .foregroundStyle(.black)
                   
                Spacer()
                TextField("", text: $vm.firstName)
                    .foregroundStyle(isEditingUserInfo ? .gray : Color.black)
                    .multilineTextAlignment(.trailing)
                    .disabled(!isEditingUserInfo)
            }
           
            HStack {
                Text("Last Name:")
                    .font(.body)
                    .foregroundStyle(.black)
                Spacer()
                TextField("", text: $vm.lastName)
                    .foregroundStyle(isEditingUserInfo ? .gray : Color.black)
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
                            .font(.body)
                            .foregroundStyle(.black)
                    } else {
                        Text("No selected")
                            .foregroundColor(.gray)
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
                            .font(.body)
                            .foregroundStyle(.black)
                    } else {
                        Text("No selected")
                            .foregroundColor(.gray)
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
                    Image(systemName: "pencil")
                        .foregroundStyle(.appPrimary)
                }
            }.foregroundStyle(.appPrimary)
            
            if let location = vm.location {
                Text("\(location)")
                    .font(.body)
            }else{
                Text("No selected")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .backgroundCard(cornerRadius: 10, shadowRadius: 3, shadowColor: .gray, shadowX: 2, shadowY: 2)
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
                    await vm.updateProfile(updateKind: .info)
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
                    self.showAlertDeleteProfile.toggle()
                }
                .padding()
                .foregroundStyle(.gray)
            }
            .padding()
        }
        
    }
}


#Preview {
    NavigationView{
        ProfileTapScreen().environmentObject(ProfileVM())
    }
}
