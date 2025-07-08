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
                    AppProgressView()
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
        .onFirstAppear {
            Task{
                await  vm.fetchProfile()
            }
        }
        .refreshable {
            Task {
                await vm.fetchProfile()
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
        VStack( spacing: 10){
            // header
            HStack {
                Text("user_info")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isEditingUserInfo.toggle()
                }) {
                    Image(systemName: isEditingUserInfo ? "xmark" : "square.and.pencil")
                        .foregroundStyle(.appPrimary)
                }
            }
            .foregroundStyle(.appPrimary)
            .padding(.bottom)
            // firstName
            HStack{
                Text("first_name")
                    .foregroundStyle(.appSecode)
                
                Spacer()

                if isEditingUserInfo{
                    TextField("first_name", text:  $vm.firstName)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.appSecode)
                        .frame(width: screenWidth / 3)
                }else{
                    Text(vm.firstName)
                        .foregroundStyle(.appSecode)
                }
            }
            // last_name
            HStack{
                Text("last_name")
                    .foregroundStyle(.appSecode)
                
                Spacer()
                
                if isEditingUserInfo{
                    TextField("last_name", text:   $vm.lastName)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.appSecode)
                        .frame(width: screenWidth / 3)
                }else{
                    Text(vm.lastName)
                        .foregroundStyle(.appSecode)
                }
            }
            // gender
            HStack {
                Text("gender")
                    .font(.body)
                    .foregroundStyle(.appSecode)
                
                Spacer()
                
                if isEditingUserInfo {
                    Picker("gender".localized(), selection: $vm.gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.displayName).tag(gender)
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    if let gender = vm.gender {
                        Text(gender.displayName)
                            .font(.body)
                            .foregroundStyle(.appSecode)
                    } else {
                        Text("no_selected".localized())
                            .foregroundColor(.gray)
                    }
                }
            }
            // dateOfBirth
            HStack {
                Text("dateOfBirth")
                    .font(.body)
                    
                
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
                           
                    } else {
                        Text("no_selected")
                            .font(.body)
                    }
                }
            }.foregroundStyle(.appSecode)
            // phone number
            HStack{
                Text("phone_number")
                    .foregroundStyle(.appSecode)
      
                Spacer()
                if isEditingUserInfo{
                    AppTextField(
                        text: $vm.phoneNumber,
                        placeholder: "phoneNumber".localized(),
                        validationRules: [.phone],style: .plain
                    )
                    .textFieldStyle(.roundedBorder)
                   // .frame(width: screenWidth / 2.5)
                }else{
                    Text(vm.phoneNumber)
                        .foregroundStyle(.appSecode)
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
                    Image(systemName: "square.and.pencil")
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
                        appRouter.pushView(ChangePasswordScreen())
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
    let vm = ProfileVM()
    vm.viewState = .loaded
    vm.updateProfileData(Profile.mock)
   return  NavigationView{
        ProfileTapScreen()
           .environmentObject(vm)
           .environment(\.locale, .init(identifier: "ar"))
           .environment(\.layoutDirection, .rightToLeft)   //
           
    }
}
