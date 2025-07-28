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
    var centerPin: UIImageView!
    weak var delegate: SetLocationDelegate?
    var selectedLocationName: String?
    var selectedCoordinate: CLLocationCoordinate2D?
        var selectedFullAddress: String?
        override func viewDidLoad() {
            super.viewDidLoad()
            applyGradientButtonStyle(to: self.btn_sabve)
            mapView.delegate = self
            setupCenterMarker()
            self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        }

        private func setupCenterMarker() {
            // Add a static pin image to the center of the mapView
            centerPin = UIImageView(image: UIImage(named: "placeholder")) // Replace with your pin image name
            centerPin.translatesAutoresizingMaskIntoConstraints = false
            mapView.addSubview(centerPin)

            NSLayoutConstraint.activate([
                centerPin.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
                centerPin.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -centerPin.frame.height / 2)
            ])
        }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let centerCoordinate = mapView.centerCoordinate
            selectedCoordinate = centerCoordinate
            fetchLocationDetails(for: centerCoordinate)
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
