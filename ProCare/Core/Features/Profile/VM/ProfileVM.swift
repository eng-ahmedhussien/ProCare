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
    
    @Published var firstName: String = "ahmed"
    @Published var lastName: String = "hussien"
    @Published var dateOfBirth: Date?
    @Published var location: String?
    @Published var gender: Gender?
    
    @Published var viewState: ViewState = .empty
    
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
                AppUserDefaults.shared.setCodable(profileData, forKey: .profileData)
                firstName = profileData.firstName ?? ""
                lastName = profileData.lastName ?? ""
                gender = Gender(rawValue: profileData.gender ?? 0) ?? .notSpecified
                dateOfBirth =  dateFromString(profileData.birthDate ?? "") ?? Date()
                location = profileData.city ?? "" + " - " + (profileData.governorate ?? "") + "- " + (profileData.addressNotes ?? "")
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
    
}


func dateFromString(_ dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX") // Recommended for fixed format parsing
    return formatter.date(from: dateString)
}
