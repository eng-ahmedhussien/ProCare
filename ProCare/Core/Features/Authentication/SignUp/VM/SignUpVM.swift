//
//  SignUpVM.swift
//  ProCare
//
//  Created by ahmed hussien on 26/03/2025.
//

import SwiftUI
import Combine

//class SignUpVM: ObservableObject {
//    
//    @Published var otp : String = ""
//    private let apiClient: SignUpApiClintProtocol
//    
//    init(apiClient: SignUpApiClintProtocol = SignUpApiClint()) {
//        self.apiClient = apiClient
//    }
//    
//    func signUp(parameters: [String: String]) async {
//        
//        let response = try? await apiClient.signUp(parameters: parameters)
//        await MainActor.run{
//            self.otp = response?.data ?? "nil"
//        }
//    }
//}

//class SignUpVM: ObservableObject {
//    
//    @Published var otp: String = ""
//    @Published var errorMessage: String? // Store error messages
//    private let apiClient: SignUpApiClintProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//    init(apiClient: SignUpApiClintProtocol = SignUpApiClint()) {
//        self.apiClient = apiClient
//    }
//    
//    func signUp(parameters: [String: String]) async {
//        do {
//            let response = try await apiClient.signUp(parameters: parameters)
//            
//            await MainActor.run {
//                if response.status == .Success, let otp = response.data {
//                    self.otp = otp
//                    self.errorMessage = nil
//                } else {
//                    self.errorMessage = response.message
//                }
//            }
//        } catch let APIError.custom(_, message) {
//            await MainActor.run {
//                self.errorMessage = message
//            }
//        } catch {
//            await MainActor.run {
//                self.errorMessage = "Unexpected error occurred"
//            }
//        }
//    }
//    
//    func signUpComin(parameters: [String: String]) {
//        apiClient.signUp(parameters: parameters)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .failure(let error):
//                    self?.handleAPIError(error)
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] data in
//                
//                switch data.status {
//                case .Success:
//                    if let data = data.data {
//                        self?.otp = data
//                    }
//                default:
//                    self?.errorMessage = data.message
//                }
//                
////                if data.status == .Success, let otp = data.data {
////                    self?.otp = otp
////                    self?.errorMessage = nil
////                } else {
////                    self?.errorMessage = data.message
////                }
//            })
//            .store(in: &cancellables)
//    }
//
//    // 🔹 Extracted Error Handling Method
//    private func handleAPIError(_ error: Error) {
//        if let apiError = error as? APIError {
//            switch apiError {
//            case .requestFailed:
//                errorMessage = "Request failed. Please check your internet connection."
//            case .invalidResponse:
//                errorMessage = "Invalid response from the server."
//            case .invalidData:
//                errorMessage = "Received invalid data."
//            case .decodingError:
//                errorMessage = "Failed to decode response."
//            case .custom(let statusCode, let message):
//                errorMessage = "Error \(statusCode): \(message)"
//            }
//        } else {
//            errorMessage = "An unexpected error occurred."
//        }
//    }
//}


@MainActor
final class SignUpVM: ObservableObject {

    @Published var name: String = ""
    @Published var secondName: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var otp : String = ""
    @Published var errorMessage: APIResponseError?
    
    private let apiClient: SignUpApiClintProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(apiClient: SignUpApiClintProtocol = SignUpApiClint()) {
        self.apiClient = apiClient
    }

    
    func signUp(completion: @escaping (String?) -> Void) async {
        let parameter = [
            "firstName": name,
            "lastName": secondName,
            "phoneNumber": phone,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        do {
            let response = try await apiClient.signUp(parameters: parameter)
            
            await MainActor.run {
                if response.status == .Success, let otp = response.data {
                    self.otp = otp
                    completion(otp)
                    self.errorMessage = nil
                } else {
                    self.errorMessage =  APIResponseError(type: nil, title: nil, status: 4, errors: ["error":[response.message]], traceId: nil)
                }
            }
        } catch let APIError{
            await MainActor.run {
                self.errorMessage = APIError as? APIResponseError
            }
        }
    }
    
     func signUpPublisher(parameters: [String: String]) { // 4
        apiClient.signUp(parameters: parameters)
            .receive(on: DispatchQueue.main) // 5
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage =  error
                }
            } receiveValue: { [weak self] otp in
                guard let self = self, let data = otp.data else { return }
                self.otp = data
            }
            .store(in: &cancellables)
    }
    
    
}
