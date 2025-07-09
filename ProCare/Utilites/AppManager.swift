//
//  AuthManager.swift
//  ProCare
//
//  Created by ahmed hussien on 30/06/2025.
//
import SwiftUI

@MainActor
class AppManager: ObservableObject {
    
    private let apiClient: AppManagerApiClintProtocol = AppManagerApiClint()
    
    func checkVersion()  async {
        guard  let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        let parameters:  [String : Any] = [
            "version": currentVersion,
            "platform": 1
        ]
        do {
            let response = try await apiClient.forceUpdate(parameters: parameters)
            if let data = response.data, let shouldUpdate = data.shouldUpdate{
                if shouldUpdate{
                    showPopup {
                        VStack(spacing: 16) {
                            Text("forced_update")
                                .font(.headline)
                            Text(response.message ?? "يجب عليك تحديث التطبيق لمواصلة الاستخدام.")
                                .font(.subheadline)
                            Button("update") {
                                if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        .frame(maxWidth: 200)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    }
    
                }
            }
            
        }catch {
            
        }
    }
    
    func logout(completion: @escaping () -> Void) async{
        let parameters: [String: Any] = [
            "token": KeychainHelper.shared.get(forKey: .deviceToken) ?? ""
        ]
        
        do {
            let response = try await apiClient.logout(parameters: parameters)
            if let data = response.data, data {
                showToast(response.message ?? "", appearance: .success)
                completion()
            }else{
                showToast(response.message ?? "", appearance: .error)
            }
        } catch {
            showToast(" \(error.localizedDescription)", appearance: .error)
        }
    }
}

struct versionData:Codable{
    var shouldUpdate: Bool?
}


enum AppManagerEndPoints: APIEndpoint {
    
    case forceUpdate(parameters: [String:Any])
    case logout(parameters: [String: Any])
    
    var path: String {
        switch self {
        case .forceUpdate:
            return "/AppVersion/ForceUpdate"
        case .logout:
            return "Auth/Logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .forceUpdate, .logout:
            return .post
        }
    }
    
    var headers: HTTPHeader? {
        switch self {
        case .logout:
            return .authHeader
        default:
            return .default
        }
    }
    
    var task: Parameters {
        switch self {
        case .forceUpdate(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        case .logout(let parameters):
            return .requestParameters(parameters: parameters, encoding: .JSONEncoding())
        }
    }
}

protocol AppManagerApiClintProtocol {
    func forceUpdate(parameters: [String:Any]) async throws -> APIResponse<versionData>
    func logout(parameters: [String: Any]) async throws -> APIResponse<Bool>

}

class AppManagerApiClint : ApiClient<AppManagerEndPoints>, AppManagerApiClintProtocol {
    
    func forceUpdate(parameters: [String:Any] ) async throws -> APIResponse<versionData> {
        return try await request(.forceUpdate(parameters: parameters))
    }
    
    func logout(parameters: [String: Any]) async throws -> APIResponse<Bool> {
        return try await request(.logout(parameters: parameters))
    }
}
