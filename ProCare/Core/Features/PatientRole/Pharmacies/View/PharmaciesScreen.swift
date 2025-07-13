//
//  PharmacyListView.swift
//  ProCare
//
//  Created by ahmed hussien on 09/06/2025.
//


import SwiftUI
import Foundation
import MapKit

struct PharmaciesScreen: View {

    @ObservedObject var vm: PharmaciesVM
    @State private var showingCallSheet = false
    @State private var selectedPharmacy: PharmacyItem?
    @State private var showingMapOptions = false
    @State private var selectedMapLocation: (latitude: Double, longitude: Double, name: String)? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(vm.pharmacies) { pharmacy in
                    PharmacyCardView(
                        pharmacy: pharmacy,
                        onCallTap: { pharmacy in
                            selectedPharmacy = pharmacy
                            showingCallSheet = true
                        },
                        onMapTap: openInMaps
                    )
                }
            }
            .padding(.vertical)
        }
        .appNavigationBar(title: "pharmacies".localized())
        .onAppear {
            if vm.pharmacies.isEmpty {
                Task {
                    await vm.fetchPharmacies(loadType: .initial)
                }
            }
        }
        .refreshable {
            Task {
                await vm.fetchPharmacies(loadType: .refresh)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .confirmationDialog(
            "choose_number_to_call".localized(),
            isPresented: $showingCallSheet,
            titleVisibility: .visible
        ) {
            callOptions
        }
        .confirmationDialog(
            "open_in".localized(),
            isPresented: $showingMapOptions,
            titleVisibility: .visible
        ) {
            if let location = selectedMapLocation {
                Button("apple_maps".localized()) {
                    openInAppleMaps(latitude: location.latitude, longitude: location.longitude, name: location.name)
                }
                Button("google_maps".localized()) {
                    openInGoogleMaps(latitude: location.latitude, longitude: location.longitude, name: location.name)
                }
            }
            Button("cancel".localized(), role: .cancel) {}
        }
    }
    
   

   
}

//MARK: - call
extension PharmaciesScreen {
    private var callOptions: some View {
        Group {
            if let pharmacy = selectedPharmacy {
                if let phoneNumber = pharmacy.phoneNumber {
                    Button("\("phone".localized()): \(phoneNumber)") {
                        callNumber(phoneNumber)
                    }
                }
                if let lineNumber = pharmacy.lineNumber {
                    Button("\("line".localized()): \(lineNumber)") {
                        callNumber(lineNumber)
                    }
                }
            }
            Button("cancel".localized(), role: .cancel) {}
        }
    }

    private func callNumber(_ number: String) {
        let digits = number.filter { $0.isNumber || $0 == "+" }
        if let url = URL(string: "tel://\(digits)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

//MARK: - maps
extension PharmaciesScreen {
    private func openInMaps(latitude: Double, longitude: Double, name: String) {
        selectedMapLocation = (latitude, longitude, name)
        showingMapOptions = true
    }

    private func openInAppleMaps(latitude: Double, longitude: Double, name: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    private func openInGoogleMaps(latitude: Double, longitude: Double, name: String) {
        let urlString = "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=14&views=traffic"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let webURLString = "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)"
            if let webURL = URL(string: webURLString) {
                UIApplication.shared.open(webURL)
            }
        }
    }
}
