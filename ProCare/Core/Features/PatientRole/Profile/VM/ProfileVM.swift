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
import CoreLocation

@MainActor
class ProfileVM: ObservableObject {
    // MARK: - Published Properties (Profile)
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date?
    @Published var location: String?
    @Published var gender: Gender?
    @Published var phoneNumber: String = ""
    @Published var viewState: ViewState = .idle
    @Published var profileImage: String?
    @Published var profileData: Profile?

    // MARK: - Published Properties (Governorates & Cities)
    @Published var governorates: [Governorates] = []
    @Published var citys: [City] = []
    @Published var selectedGovernorate: Int?
    @Published var selectedCity: Int?
    @Published var addressInDetails = ""

    // MARK: - Published Properties (Image Handling)
    @Published var uploadedImage: UIImage?
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            if let selectedImage = selectedImage {
                Task {
                    await loadImage(selectedImage)
                }
            }
        }
    }
    @Published var showUploadImageAlert: Bool = false

    // MARK: - Private Properties
    private let apiClient: ProfileApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(apiClient: ProfileApiClintProtocol = ProfileApiClint()) {
        self.apiClient = apiClient
    }

    // MARK: - Enums
    enum UpdateKind {
        case location
        case image
        case info
    }

    // MARK: - Computed Properties
    var minimumDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    }

    // MARK: - API Methods
    func fetchProfile() async {
        viewState = .loading
        do {
            let response = try await apiClient.getProfile()
            viewState = .loaded
            handleApiResponse(response){
                if let profileData = response.data{
                    KeychainHelper.shared.set(profileData, forKey: .profileData)
                   // AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
                    self.updateProfileData(profileData)
                    self.profileData = profileData
                }
            }
        } catch {
            handleError("⚠️⚠️⚠️Unexpected error: \(error.localizedDescription)")
        }
    }

    func deleteProfile(completion: @escaping () -> Void) async {
        viewState = .loading
        do {
            let response = try await apiClient.deleteProfile()
            viewState = .loaded
            handleApiResponse(response,onSuccess: completion)
        } catch {
            handleError("⚠️⚠️⚠️Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func updateProfile(updateKind: UpdateKind) async {
        viewState = .loading
        do {
            let response = try await apiClient.updateProfile(
                parameters: getParameters(updateKind: updateKind),
                image: uploadedImage
            )
            viewState = .loaded
            handleApiResponse(response){
                if let profile = response.data {
                    self.profileData = profile
                    self.updateProfileData(profile)
                }
            }
        } catch {
            handleError("⚠️⚠️⚠️Unexpected error: \(error.localizedDescription)")
        }
    }

    func fetchGovernorates() async {
        do {
            let response = try await apiClient.getGovernorates()
            handleApiResponse(response){
                if let governorates = response.data {
                    self.governorates = governorates
                    Task {
                        await self.fetchCityByGovernorateId(id: self.selectedGovernorate ?? 0)
                    }
                }
            }
        } catch {
            handleError("⚠️⚠️⚠️Unexpected error: \(error.localizedDescription)")
        }
    }

    func fetchCityByGovernorateId(id: Int) async {
        do {
            let response = try await apiClient.getCityByGovernorateId(id: id)
            handleApiResponse(response){
                if let cities = response.data {
                    self.citys = cities
                }
            }
        } catch {
            handleError("⚠️⚠️⚠️Unexpected error: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper Methods
    func updateProfileData(_ profileData: Profile) {
        AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
        firstName = profileData.firstName ?? ""
        lastName = profileData.lastName ?? ""
        gender = Gender(rawValue: profileData.gender ?? 0) ?? .notSpecified
        dateOfBirth = profileData.birthDate?.toAPIDate()
        location = "\(profileData.city ?? "") - \(profileData.governorate ?? "") - \(profileData.addressNotes ?? "")"
        profileImage = profileData.image ?? ""
        phoneNumber = profileData.phoneNumber ?? ""
        selectedGovernorate = profileData.governorateId ?? 0
        selectedCity = profileData.cityId ?? 0
        addressInDetails = profileData.addressNotes ?? ""
    }
    
    fileprivate  func handleApiResponse<T: Codable>(_ response: APIResponse<T>, onSuccess: (() -> Void)) {
        switch response.status {
        case .Success:
            if let _ = response.data {
                onSuccess()
            } else {
                handleError("Response received but no user data")
            }
        case .Error, .AuthFailure, .Conflict:
            showToast(
                response.message ?? "network error",
                appearance: .error
            )
        case .none:
            break
        }
    }

    fileprivate func getParameters(updateKind: UpdateKind) -> [String: Any] {
        let location = LocationManager.shared.location ?? CLLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        switch updateKind {
        case .location:
            return [
                "GovernorateId": selectedGovernorate ?? 0,
                "CityId": selectedCity ?? 0,
                "AddressNotes": addressInDetails,
                "Latitude": lat,
                "Longitude": lon
            ]
        case .image:
            return [:]
        case .info:
            if let gender = gender, gender != .notSpecified {
                return [
                    "FirstName": firstName,
                    "LastName": lastName,
                    "BirthDate": dateOfBirth?.toAPIDateString() ?? "",
                    "phoneNumber": phoneNumber,
                    "Gender": gender.rawValue
                ]
            } else {
                return [
                    "FirstName": firstName,
                    "LastName": lastName,
                    "BirthDate": dateOfBirth?.toAPIDateString() ?? "",
                    "phoneNumber": phoneNumber
                ]
            }
        }
    }

    fileprivate func handleError(_ response: String) {
        viewState = .failed(response)
        debugPrint("⚠️⚠️⚠️\(response)")
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





