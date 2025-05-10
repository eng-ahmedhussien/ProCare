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
    private let geocoder = CLGeocoder()   // Used for reverse geocoding coordinates to human-readable address
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var address: String = ""
    @Published var isPermissionDenied = false
    @Published var isPermissionRestricted = false
    
    private var lastGeocodedLocation: CLLocation? // Last location that was reverse geocoded
    private var lastGeocodeTime: Date?   // Timestamp of last reverse geocoding
    private let geocodeDistanceThreshold: CLLocationDistance = 50 // meters  // Minimum distance required to trigger a new reverse geocode
    private let geocodeTimeThreshold: TimeInterval = 10 // seconds   // Minimum time interval required to trigger a new reverse geocode

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization()
    }

    // Requests location access permission from the user
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    // Checks the current authorization status and updates flags accordingly
    private func checkAuthorization() {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .restricted:
            isPermissionRestricted = true

        case .denied:
            isPermissionDenied = true

        case .authorizedWhenInUse, .authorizedAlways:
            isPermissionDenied = false
            manager.startUpdatingLocation()

        @unknown default:
            break
        }
    }

    // Triggered when the authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    // Called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }

        if shouldGeocode(location: newLocation) {
            reverseGeocode(location: newLocation)
        }
    }

    // Called when location updates fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.address = "فشل تحديث الموقع"
        }
    }

    // Determines whether the location has changed enough in distance or time to warrant geocoding
    private func shouldGeocode(location: CLLocation) -> Bool {
        let now = Date()

        if let lastLoc = lastGeocodedLocation, let lastTime = lastGeocodeTime {
            let distance = location.distance(from: lastLoc)
            let timeElapsed = now.timeIntervalSince(lastTime)
            return distance > geocodeDistanceThreshold || timeElapsed > geocodeTimeThreshold
        }

        return true
    }

    // Converts the CLLocation into a human-readable address in Arabic
    private func reverseGeocode(location: CLLocation) {
        let locale = Locale(identifier: "ar")

        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let placemark = placemarks?.first {
                    self.address = [
                        placemark.name,
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.country
                    ]
                    .compactMap { $0 }
                    .joined(separator: ", ")

                    self.lastGeocodedLocation = location
                    self.lastGeocodeTime = Date()
                } else if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.address = "تعذر تحديد العنوان"
                }
            }
        }
    }
}
