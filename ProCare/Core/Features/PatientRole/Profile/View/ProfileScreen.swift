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
            switch vm.viewState {
            case .idle:
                EmptyView()
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                        .appProgressStyle()
                    Spacer()
                }
            case .loaded:
                content
            case .failed(let error):
                VStack {
                    Spacer()
                    RetryView(message: error){
                        Task {
                            await vm.fetchProfile()
                        }
                    }
                    Spacer()
                }
            }
        }
        .background(.appBackground)
        .onAppear {
            Task{
                await  vm.fetchProfile()
            }
        }
        .photosPicker(isPresented: $openPhotoLibrary, selection: $vm.selectedImage, matching: .images)
        .alert("upload_image".localized(), isPresented: $vm.showUploadImageAlert) {
            Button("cancel".localized(), role: .destructive) { }
            Button("upload".localized(), role: .cancel) {
                Task{
                    await vm.updateProfile(updateKind: .image)
                }
            }
        }
        .alert("delete_profile".localized().localized(),isPresented: $showAlertDeleteProfile) {
            Button("cancel".localized(), role: .cancel) { }
            Button("delete".localized(), role: .destructive) {
                Task {
                    await vm.deleteProfile(){
                        appRouter.popToRoot()
                        authManager.logout()
                    }
                }
            }
        } message: {
            Text("are_you_sure_delete_profile".localized())
        }

    }
    
    @ViewBuilder
    private var content: some View {
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .center, spacing: 20) {
                profileImage
                userInfo
            }
            .padding()
            .backgroundCard(cornerRadius: 10, shadowRadius: 4, shadowColor: .gray, shadowX: 2, shadowY: 2)
            .padding()
            .dismissKeyboardOnTap()
            
            locationView
            
            buttons
            
        }
    }
}


extension ProfileTapScreen{
    var header: some View {
        HStack {
            Spacer()
            Text("profile")
                .padding(5)
                .font(.title)
                .foregroundStyle(.white)
            Spacer()
            Button(action: {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }) {
                Image(systemName: "globe")
                    .foregroundStyle(.white)
            }.padding(.horizontal)
            
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
                Text("user_info")
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
            
            HStack{
                
                AppTextField(text: $vm.firstName)
                    .foregroundStyle(isEditingUserInfo ? .gray : .black)
                    .disabled(!isEditingUserInfo)
                
                AppTextField(text: $vm.lastName)
                    .foregroundStyle(isEditingUserInfo ? .gray : .black)
                    .disabled(!isEditingUserInfo)
            }
            
            HStack {
                if isEditingUserInfo {
                    Picker("gender".localized(), selection: $vm.gender) {
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
                            .padding()
                    } else {
                        Text("no_selected".localized())
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
                    .environment(\.locale, Locale(identifier: "en"))

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
                Text("user_location")
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
                    .foregroundStyle(.black)
                
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
            Button("update_profile".localized()) {
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
                    Button {
                        appRouter.pushView(PhoneScreen())
                    } label: {
                        Text("change_password")
                            .lineLimit(1)
                    }   .foregroundStyle(.appPrimary)
                        .buttonStyle(AppButton(kind: .border))

                    
                    Button("logout".localized()) {
                        appRouter.popToRoot()
                        authManager.logout()
                    }
                    .buttonStyle(AppButton(kind: .solid))
                }
                
                Button("delete_account".localized()) {
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
    var vm = ProfileVM()
    vm.viewState = .loading
    vm.putProfileData(Profile.mock)
   return  NavigationView{
        ProfileTapScreen()
           .environmentObject(vm)
    }
}
