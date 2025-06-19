//
//  ProfileVM.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import Foundation
import Combine
import PhotosUI
import UIKit
import _PhotosUI_SwiftUI

@MainActor
class ProfileVM: ObservableObject {
    
    // MARK: Profile
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date?
    @Published var location: String?
    @Published var gender: Gender?
    @Published var viewState: ViewState = .idle
    @Published var profileImage: String?
    @Published var profileData: Profile?
        
    
    // MARK: - Governorates
    @Published var governorates: [Governorates] = []
    @Published var citys: [City] = []
    @Published var selectedGovernorate: Int?
    @Published var selectedCity: Int?
    @Published var addressInDetails = ""
    
    enum UpdateKind {
        case location
        case image
        case info
    }
    
    var minimumDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    }
    
    //image
    @Published var uploadedImage: UIImage?
    @Published var selectedImage: PhotosPickerItem? {
        didSet{
            if let selectedImage = selectedImage {
                Task {
                    await loadImage(selectedImage)
                }
            }
        }
    }
    @Published  var showUploadImageAlert: Bool = false
    
    // MARK: - Published Properties
    private let apiClient: ProfileApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ProfileApiClintProtocol = ProfileApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func fetchProfile() async {
        viewState = .loading
        do {
            let response = try await apiClient.getProfile()
            if let profileData = response.data {
                viewState = .loaded
                AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
                putProfileData(profileData)
                self.profileData = profileData
            } else {
              //  AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
                debugPrint("Response received but no user data")
            }
        }catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func deleteProfile(completion: @escaping () -> Void) async {
        viewState = .loading
        do {
            let response = try await apiClient.deleteProfile()
            if let _ = response.data {
                viewState = .loaded
                completion()
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func updateProfile(updateKind: UpdateKind, latitude: String? = nil, longitude: String? = nil) async{
        viewState = .loading
        var parameters :[String : Any]  = [:]
        
        switch updateKind {
        case .location:
            parameters   = [
                "GovernorateId": selectedGovernorate ?? 0,
                "CityId": selectedCity ?? 0,
                "AddressNotes": addressInDetails,
                "Latitude" : latitude ?? "",
                "Longitude": longitude ?? ""
            ]
        case .image:
            parameters   = [:]
        case .info:
            parameters   = [
                "FirstName": firstName,
                "LastName": lastName,
                "BirthDate": dateOfBirth?.toAPIDateString() ?? "",
                "GovernorateId": selectedGovernorate ?? 0,
                "CityId": selectedCity ?? 0,
                "AddressNotes": addressInDetails,
                "Gender": gender?.rawValue ?? 0
            ]
        }
       
        do {
            let response = try await apiClient.updateProfile(parameters: parameters,image: uploadedImage)
            if let profileData = response.data {
                viewState = .loaded
                putProfileData(profileData)
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func fetchGovernorates() async {
        do {
            let response = try await apiClient.getGovernorates()
            if let governorates = response.data {
                self.governorates = governorates
                Task {
                    await  self.fetchCityByGovernorateId(id: self.selectedGovernorate ?? 0)
                }
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func fetchCityByGovernorateId(id: Int) async {
        do {
            let response = try await apiClient.getCityByGovernorateId(id: id)
            if let cities = response.data {
                self.citys = cities
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
            debugPrint("Unexpected error: \(error.localizedDescription)")
        }
    }
    
}

extension ProfileVM {
     func putProfileData( _ profileData : Profile) {
        AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
        firstName = profileData.firstName ?? ""
        lastName = profileData.lastName ?? ""
        gender = Gender(rawValue: profileData.gender ?? 0) ?? .notSpecified
        dateOfBirth =  profileData.birthDate?.toAPIDate()
        location = "\(profileData.city ?? "") - \(profileData.governorate ?? "") - \(profileData.addressNotes ?? "")"
        profileImage =   profileData.image ?? ""
        
        //MARK: location
        selectedGovernorate = profileData.governorateId ?? 1
        selectedCity = profileData.cityId ?? 1
        addressInDetails = profileData.addressNotes ?? ""
    }
    
    @MainActor
    private func loadImage(_ photosPickerItem: PhotosPickerItem?) async {
        guard let data = try? await photosPickerItem?.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data) else {
            return
        }
        
        self.showUploadImageAlert.toggle()
        self.uploadedImage = uiImage
        
    }
}





