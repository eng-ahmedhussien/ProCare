    //
    //  SupportView.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 12/07/2025.
    //

import SwiftUI

struct InformationScreen: View {
    @State private var showMapOptions = false
    @State private var selectedAddress: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(SupportInfoType.allCases, id: \.self) { info in
                    SupportRow(info: info) {
                        handleTap(on: info)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 24)
        }
        .appNavigationBar(title: "information".localized())
        .confirmationDialog("Open in", isPresented: $showMapOptions, titleVisibility: .visible) {
            if let address = selectedAddress {
                Button("Apple Maps") {
                    openInAppleMaps(address: address)
                }
                Button("Google Maps") {
                    openInGoogleMaps(address: address)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func handleTap(on info: SupportInfoType) {
        switch info {
        case .tel:
            openURL("tel://\(info.rawValue)")
        case .whatsapp:
            openURL("https://wa.me/\(info.rawValue)")
        case .general, .hr, .support:
            openURL("mailto:\(info.rawValue)")
        case .agreement:
            openURL("https://www.procare.live/terms")
        case .address:
            selectedAddress = info.rawValue
            showMapOptions = true
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openInAppleMaps(address: String) {
        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        openURL("http://maps.apple.com/?q=\(encoded)")
    }
    
    private func openInGoogleMaps(address: String) {
        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "comgooglemaps://?q=\(encoded)"
        
            // Fallback to web if app not installed
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            openURL("https://www.google.com/maps/search/?api=1&query=\(encoded)")
        }
    }
}

struct SupportRow: View {
    let info: SupportInfoType
    var onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: info.icon)
                .foregroundColor(.pink)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(info.label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                Text(info.rawValue)
                    .font(.body)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .backgroundCard(cornerRadius: 12, shadowRadius: 4, shadowX: 0, shadowY: 2)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    NavigationView{
        InformationScreen()
            .appNavigationBar(title: "information".localized())
    }
}
