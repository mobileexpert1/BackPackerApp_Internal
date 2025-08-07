//
//  SetLocationVC.swift
//  Backpacker
//
//  Created by Mobile on 25/07/25.
//

import UIKit
import MapKit
import CoreLocation
protocol SetLocationDelegate: AnyObject {
    func didSelectLocation(locationName: String, fullAddress: String, coordinate: CLLocationCoordinate2D)
}



class SetLocationVC: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var btn_sabve: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let geocoder = CLGeocoder()
      let locationManager = CLLocationManager()

      weak var delegate: SetLocationDelegate?

      var selectedLocationName: String?
      var selectedCoordinate: CLLocationCoordinate2D?
      var selectedFullAddress: String?
        override func viewDidLoad() {
            super.viewDidLoad()
            applyGradientButtonStyle(to: self.btn_sabve)
                    lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)

                    mapView.delegate = self
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
        }

    func fetchLocationDetails(for coordinate: CLLocationCoordinate2D) {
           let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
           geocoder.cancelGeocode()

           geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
               guard let self = self else { return }

               if let placemark = placemarks?.first {
                   let locationName = placemark.subLocality ?? placemark.locality ?? "Unnamed Location"

                   let fullAddress = [
                       placemark.name,
                       placemark.subLocality,
                       placemark.locality,
                       placemark.administrativeArea,
                       placemark.postalCode,
                       placemark.country
                   ].compactMap { $0 }.joined(separator: ", ")

                   self.selectedLocationName = locationName
                   self.selectedFullAddress = fullAddress

                   print("📍 Location: \(locationName)")
                   print("🏠 Address: \(fullAddress)")
               }
           }
       }

       func addCustomPin(at coordinate: CLLocationCoordinate2D) {
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinate
           annotation.title = "Selected Location"

           mapView.removeAnnotations(mapView.annotations)
           mapView.addAnnotation(annotation)
       }

       // MARK: - MKMapViewDelegate

       func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
           let centerCoordinate = mapView.centerCoordinate
           selectedCoordinate = centerCoordinate
           fetchLocationDetails(for: centerCoordinate)

           addCustomPin(at: centerCoordinate)
       }

       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           if annotation is MKUserLocation {
               return nil
           }

           let identifier = "CustomPin"
           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

           if annotationView == nil {
               annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               annotationView?.image = UIImage(named: "placeholder") // Your pin image
               annotationView?.canShowCallout = true
           } else {
               annotationView?.annotation = annotation
           }

           return annotationView
       }


    @IBAction func action_Save(_ sender: Any) {
        guard let name = selectedLocationName,
                     let address = selectedFullAddress,
                     let coordinate = selectedCoordinate else {
                   print("⚠️ Location not ready yet")
                   return
               }

               delegate?.didSelectLocation(locationName: name, fullAddress: address, coordinate: coordinate)
               self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SetLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        locationManager.stopUpdatingLocation()

        let coordinate = location.coordinate
        selectedCoordinate = coordinate
        fetchLocationDetails(for: coordinate)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        addCustomPin(at: coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
    }
}
