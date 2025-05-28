//
//  LoginVM.swift
//  ProCare
//
//  Created by ahmed hussien on 02/04/2025.
//

import Foundation
import Combine

@MainActor
class LoginVM: ObservableObject {
    
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var userDataLogin : UserDataLogin?
    @Published var goToOTP = false
    @Published var viewState: ViewState = .empty
    

    private let apiClient: LoginApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: LoginApiClintProtocol = LoginApiClint()) {
        self.apiClient = apiClient
    }

    func login(completion: @escaping (_ userSate: UserState) -> Void) async {
        viewState = .loading
        let parameter = [
            "phoneNumber": phone,
            "password": password
        ]
        
        do {
            let response = try await apiClient.login(parameters: parameter)
            
            await MainActor.run {
                if  let userDataLogin = response.data {
                    self.userDataLogin = userDataLogin
                    viewState = .loaded
                    switch userDataLogin.loginStatus {
                    case .Success:
                        if userDataLogin.token != nil {
                            completion(.withToken)
                            
                            //get profile
//                            Task{
//                                await profileVM.getProfile()
//                            }
                        }
                    case .InValidCredintials:
                        debugPrint("InValidCredintials")
                        showAppMessage("InValidCredintials", appearance: .error, position: .top)
                    case .UserLockedOut:
                        debugPrint("UserLockedOut")
                    case .UserNotConfirmed:
                        completion(.userNotConfirmed)
                    case .Error:
                        debugPrint("Error")
                        showAppMessage("Error", appearance: .error, position: .top)
                    case .none:
                        debugPrint("none")
                        showAppMessage("none", appearance: .error, position: .top)
                    }
                    
                } else {
                    showAppMessage("Response received but no user data", appearance: .error, position: .top)
                    debugPrint("Response received but no user data")
                }
            }
        } catch let APIError{
            await MainActor.run {
                showAppMessage("Unexpected error: \(APIError.localizedDescription)", appearance: .error, position: .top)
                debugPrint("Unexpected error: \(APIError.localizedDescription)")
            }
        }
    }
    
    
}

enum UserState {
    case userNotConfirmed
    case withToken
}
