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
    }
    
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

    private func openInMaps(latitude: String, longitude: String, name: String) {
        guard let lat = Double(latitude), let lon = Double(longitude) else { return }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}

