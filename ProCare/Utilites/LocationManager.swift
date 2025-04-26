//
//  LocationManager.swift
//  ProCare
//
//  Created by ahmed hussien on 26/04/2025.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var address: String = ""
    @Published var location: CLLocation?
    @Published var isPermissionDenied = false
    @Published var isPermissionRestricted = false
    @Published var shouldShowLocationDeniedPopup: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization() // Call on init
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func checkAuthorization() {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            isPermissionRestricted = true
            
        case .denied:
            isPermissionDenied = true
            shouldShowLocationDeniedPopup = true // ⬅️ trigger popup when denied
            
        case .authorizedWhenInUse, .authorizedAlways:
            isPermissionDenied = false
            shouldShowLocationDeniedPopup = false // ⬅️ hide popup if allowed
            manager.startUpdatingLocation()
            
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }
        location = newLocation
        reverseGeocode(location: newLocation)
    }
    private func reverseGeocode(location: CLLocation) {
        let locale = Locale(identifier: "ar") // Arabic locale
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let placemark = placemarks?.first {
                self.address = [
                    placemark.name,
                    placemark.locality,  // City
                    placemark.administrativeArea, // State
                    placemark.country // Country
                ]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            } else if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                self.address = "تعذر تحديد العنوان"
            }
        }
    }
}
