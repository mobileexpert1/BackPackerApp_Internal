//
//  LocationManager.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didFailWithError(_ error: Error)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager() // ✅ Singleton

    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    var latitude: Double?
    var longitude: Double?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location access granted")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Location access denied/restricted")
            self.requestLocationPermission()
        case .notDetermined:
            print("🔄 Location permission not yet determined")
            self.requestLocationPermission()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }

        // Store the values globally
        latitude = latest.coordinate.latitude
        longitude = latest.coordinate.longitude

        print("📍 Location updated: \(latitude!), \(longitude!)")
        delegate?.didUpdateLocation(latest)
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Failed to get location: \(error.localizedDescription)")
        delegate?.didFailWithError(error)
    }
}
