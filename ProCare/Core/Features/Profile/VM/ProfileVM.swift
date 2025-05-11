//
//  ProfileVM.swift
//  ProCare
//
//  Created by ahmed hussien on 02/05/2025.
//

import Foundation
import Combine

@MainActor
class ProfileVM: ObservableObject {
    
    // MARK: Profile
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date?
    @Published var location: String?
    @Published var gender: Gender?
    @Published var viewState: ViewState = .empty
    
    // MARK: - Governorates
    @Published var governorates: [Governorates] = []
    @Published var citys: [City] = []
    @Published var selectedGovernorate: Int?
    @Published var selectedCity: Int?
    @Published var addressInDetails = ""
    
    var minimumDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    }
    // MARK: - Published Properties
    private let apiClient: ProfileApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: ProfileApiClintProtocol = ProfileApiClint()) {
        self.apiClient = apiClient
    }
    
    // MARK: - API Methods
    func getProfile() async {
        do {
            let response = try await apiClient.getProfile()
            if let profileData = response.data {
                putProfileData(profileData)
            } else {
                debugPrint("Response received but no user data")
            }
        } catch {
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
    
    func updateProfile(latitude: String? = nil, longitude: String? = nil) async{
        viewState = .loading
        let parameters :[String : Any]  = [
            "FirstName": firstName,
            "LastName": lastName,
            "BirthDate": dateToString(dateOfBirth ?? .now),
            "GovernorateId": selectedGovernorate ?? 0,
            "CityId": selectedCity ?? 0,
            "AddressNotes": addressInDetails,
            "Gender": gender?.rawValue ?? 0,
            "Latitude" : latitude ?? "",
            "Longitude": longitude ?? ""
        ]
        
        do {
            let response = try await apiClient.updateProfile(parameters: parameters)
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
    private func putProfileData( _ profileData : Profile) {
        AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
        firstName = profileData.firstName ?? ""
        lastName = profileData.lastName ?? ""
        gender = Gender(rawValue: profileData.gender ?? 0) ?? .notSpecified
        dateOfBirth =  dateFromString(profileData.birthDate ?? "") ?? Date()
        location = "\(profileData.city ?? "") - \(profileData.governorate ?? "") - \(profileData.addressNotes ?? "")"
        
        //MARK: location
        selectedGovernorate = profileData.governorateId ?? 1
        selectedCity = profileData.cityId ?? 1
        addressInDetails = profileData.addressNotes ?? ""
    }
}


func dateFromString(_ dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX") // Recommended for fixed format parsing
    return formatter.date(from: dateString)
}


func dateToString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}
