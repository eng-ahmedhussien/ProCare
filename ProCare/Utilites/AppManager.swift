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
        
        print("version = \(currentVersion)")
        
        let parameters:  [String : Any] = [
            "version": currentVersion,
            "platform": 1
        ]
        do {
            let response = try await apiClient.forceUpdate(parameters: parameters)
            if let data = response.data, let shouldUpdate = data.shouldUpdate{
                if shouldUpdate{
                    
                    showPopup {
                        VStack(spacing: 20) {
                            // Icon
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Color.appPrimary)
                            
                            VStack(spacing: 12) {
                                // Title - More descriptive and user-friendly
                                Text("update_required")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                
                                // Description - Clear explanation in Arabic
                                Text(
                                    response.message ?? "force_update_message".localized())
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            // Single primary action button for force update
                            Button {
                                if let url = URL(string: "https://apps.apple.com/app/6748255985") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.down.circle.fill")
                                    Text("update_now")
                                        .fontWeight(.medium)
                                }
                            }.buttonStyle(AppButton())
                        }
                        .padding(24)
                        .frame(maxWidth: 320) // Better constraint for readability
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.regularMaterial)
                                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.quaternary, lineWidth: 0.5)
                        }
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
