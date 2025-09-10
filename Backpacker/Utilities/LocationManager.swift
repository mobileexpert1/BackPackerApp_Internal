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

    static let shared = LocationManager() // -Singleton
    private var previousLocation: CLLocation?
    private let distanceThreshold: CLLocationDistance = 100 // in meters

    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    var latitude: Double?
    var longitude: Double?
    let vmLongin = LogInVM()
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
            print("-Location access granted")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("- Location access denied/restricted")
            self.requestLocationPermission()
        case .notDetermined:
            print("🔄 Location permission not yet determined")
            self.requestLocationPermission()
        @unknown default:
            break
        }
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let latest = locations.last else { return }
//
//        // Store the values globally
//        latitude = latest.coordinate.latitude
//        longitude = latest.coordinate.longitude
//
//        print("📍 Location updated: \(latitude!), \(longitude!)")
//        delegate?.didUpdateLocation(latest)
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }

        // Store the values globally
        latitude = latest.coordinate.latitude
        longitude = latest.coordinate.longitude

        print("📍 Location updated: \(latitude!), \(longitude!)")

        // Call delegate
        delegate?.didUpdateLocation(latest)

        // Check distance threshold
        if let previous = previousLocation {
            let distance = latest.distance(from: previous) // meters
            print("Distance from previous location: \(distance) meters")
            if distance >= distanceThreshold {
                previousLocation = latest // Update previous location
                self.LocationUpdate()     // Call API only if moved > 100m
            }
        } else {
            // First location update
            previousLocation = latest
            self.LocationUpdate()
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Failed to get location: \(error.localizedDescription)")
        delegate?.didFailWithError(error)
    }
    
    func LocationUpdate() {
        vmLongin.locationUpdate(lat: "\(self.latitude)", long: "\(self.longitude)") { success, message, statusCode in
            guard let statusCode = statusCode else { return }

            let httpStatus = HTTPStatusCode(rawValue: statusCode)

            DispatchQueue.main.async {
                LoaderManager.shared.hide()

                switch httpStatus {
                case .ok, .created:
                    if success {
                        print("Location Update Success:", message)
                    } else {
                        print("Location Update Failed:", message)
                    }

                case .badRequest:
                    print("Bad Request:", message)

                case .unauthorized:
                    // Try refreshing token
                    self.vmLongin.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, let code = refreshStatusCode, [200, 201].contains(code) {
                            self.LocationUpdate() // Retry after refresh
                        } else {
                            print("Token refresh failed")
                            // Optionally log out user
                        }
                    }

                case .unauthorizedToken:
                    print("Unauthorized Token:", message)

                case .methodNotAllowed:
                    print("Method Not Allowed:", message)

                case .internalServerError:
                    print("Server Error:", message)

                case .unknown:
                    print("Unknown error:", message)
                }
            }
        }
    }

    
}
