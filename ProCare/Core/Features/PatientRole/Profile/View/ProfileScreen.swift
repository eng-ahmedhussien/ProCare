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
    @EnvironmentObject var appManager: AppManager
    
    @State private var isEditingUserInfo: Bool = false
    @State private var isEditingLocation: Bool = false
    @State private var openPhotoLibrary: Bool = false
    @State private var showAlertDeleteProfile = false
    @State private var showAlertLogout = false
    
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    private var isFormValid: Bool {
        ValidationRule.isEmpty.validate(vm.firstName) == nil &&
        ValidationRule.isEmpty.validate(vm.lastName) == nil &&
        ValidationRule.phone.validate(vm.phoneNumber) == nil
    }
    
    
    var body: some View {
        content
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
            .alert("logout".localized(), isPresented: $showAlertLogout) {
                Button("cancel".localized(), role: .cancel) { }
                Button("logout".localized(), role: .destructive) {
                    Task {
                        await appManager.logout {
                            appRouter.popToRoot()
                            authManager.logout()
                        }
                    }
                }
            } message: {
                Text("are_you_sure_logout".localized())
            }
        
    }
    
    
    private var content: some View {
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
                profileContent
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
    }
    
    @ViewBuilder
    private var profileContent: some View {
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .center, spacing: 20) {
                profileImage
                userInfo
            }
            .padding()
            .backgroundCard(cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
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
            SupportButton()
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
            UserInfoRow(label: "name") {
                if isEditingUserInfo {
                    HStack{
                        TextField("first_name", text: $vm.firstName)
                            .textFieldStyle(.roundedBorder)
                            .foregroundStyle(.appSecode)
                            .frame(width: screenWidth / 3)
                        
                        TextField("last_name", text: $vm.lastName)
                            .textFieldStyle(.roundedBorder)
                            .foregroundStyle(.appSecode)
                            .frame(width: screenWidth / 3)
                    }
                } else {
                    Text(vm.firstName + " " + vm.lastName)
                        .foregroundStyle(.appSecode)
                }
            }
            
                // last_name
//            UserInfoRow(label: "last_name") {
//                if isEditingUserInfo {
//                    TextField("last_name", text: $vm.lastName)
//                        .textFieldStyle(.roundedBorder)
//                        .foregroundStyle(.appSecode)
//                        .frame(width: screenWidth / 3)
//                } else {
//                    Text(vm.lastName)
//                        .foregroundStyle(.appSecode)
//                }
//            }
                // gender
            UserInfoRow(label: "gender") {
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
            UserInfoRow(label: "dateOfBirth") {
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
            UserInfoRow(label: "phone_number") {
                if isEditingUserInfo {
                    AppTextField(
                        text: $vm.phoneNumber,
                        placeholder: "phoneNumber".localized(),
                        validationRules: [.phone],style: .plain
                    )
                    .textFieldStyle(.roundedBorder)
                        // .frame(width: screenWidth / 2.5)
                } else {
                    Text(vm.phoneNumber)
                        .foregroundStyle(.appSecode)
                }
            }
        }
    }
    
    var locationView: some View {
        VStack(alignment: .leading, spacing: 0) {
                // Header Section
            HStack {
                Text("user_location")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.appPrimary)
                
                Spacer()
                
                Button(action: {
                    appRouter.pushView(UpdateAddressView())
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.appPrimary)
                }
                .accessibilityLabel("Edit location")
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
                // Content Section
            VStack(alignment: .leading, spacing: 10) {
                    // User Selected Address
                if let address = vm.location {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("address")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text(address)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("address")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text("no_address_selected")
                            .font(.body)
                            .foregroundStyle(.tertiary)
                            .italic()
                    }
                }
                
                    // Current Location
                VStack(alignment: .leading, spacing: 2) {
                    Text("current_location")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Text(LocationManager.shared.address)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .backgroundCard(cornerRadius: 10, shadowRadius: 2, shadowColor: .gray)
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
            .appButtonStyle(.solid,width: 300,disabled: !isFormValid)
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
                        showAlertLogout.toggle()
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


struct UserInfoRow<Content: View>: View {
    let label: String
    let content: () -> Content

    init(label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    var body: some View {
        HStack {
            Text(label.localized())
                .foregroundStyle(.appSecode)
            Spacer()
            content()
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
//            .environment(\.locale, .init(identifier: "ar"))
//            .environment(\.layoutDirection, .rightToLeft)   //
        
    }
}
