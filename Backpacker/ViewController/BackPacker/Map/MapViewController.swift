//
//  MapViewController.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapVw: MKMapView!
    //Lables OutLet
    
    @IBOutlet weak var lbl_Header: UILabel!
    
    @IBOutlet weak var lbl_DurationHeader: UILabel!
    
    @IBOutlet weak var lbl_EmpDetailHeader: UILabel!
    
    @IBOutlet weak var header_StrtDate: UILabel!
    
    @IBOutlet weak var btmVwHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var header_EndDate: UILabel!
    
    @IBOutlet weak var lbl_Timing_Val: UILabel!
    @IBOutlet weak var headerTimings: UILabel!
    
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var lbl_EndDate_Val: UILabel!
    @IBOutlet weak var lbl_StrtDate_Val: UILabel!
    @IBOutlet weak var lbl_Employer_Address: UILabel!
    @IBOutlet weak var lbl_EmployerName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapVw.delegate = self
        mapVw.showsUserLocation = true
        LocationManager.shared.delegate = self
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.startUpdatingLocation()
        self.setUpUI()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
           bottomVw.addGestureRecognizer(panGesture)
    }
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)

        // Invert the Y translation because dragging upwards decreases y
        let newHeight = btmVwHeightConstraint.constant - translation.y

        // Set minimum and maximum height limits
        let minHeight: CGFloat = 234
        let maxHeight: CGFloat = self.view.frame.height - 100 // adjust as needed

        // Clamp height within bounds
        btmVwHeightConstraint.constant = max(minHeight, min(newHeight, maxHeight))

        // Reset translation to avoid compounding
        gesture.setTranslation(.zero, in: self.view)

        // Animate on end of gesture
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }

    private func setUpUI(){
        
        self.lbl_Header.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_EmpDetailHeader.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_DurationHeader.font = FontManager.inter(.semiBold, size: 14.0)
        header_StrtDate.font = FontManager.inter(.medium, size: 14.0)
        header_EndDate.font = FontManager.inter(.medium, size: 14.0)
       headerTimings.font = FontManager.inter(.medium, size: 14.0)
        
        
        lbl_StrtDate_Val.font = FontManager.inter(.regular, size: 14.0)
        lbl_EndDate_Val.font = FontManager.inter(.regular, size: 14.0)
        lbl_Timing_Val.font = FontManager.inter(.regular, size: 14.0)
        lbl_Employer_Address.font = FontManager.inter(.regular, size: 12.0)
        lbl_EmployerName.font = FontManager.inter(.medium, size: 14.0)
        bottomVw.layer.cornerRadius = 15  // or any radius
        bottomVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomVw.layer.masksToBounds = true
    }
    
    
}

extension MapViewController : LocationManagerDelegate{
    func checkLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // ✅ Permission granted — start location updates
            LocationManager.shared.startUpdatingLocation()
            
        case .notDetermined:
            // 🔄 Ask for permission
            LocationManager.shared.requestLocationPermission()
            
        case .denied, .restricted:
            // ❌ Denied or restricted — prompt to open Settings
            presentSettingsAlert()
            
        @unknown default:
            break
        }
    }
    
    func presentSettingsAlert() {
        let alert = UIAlertController(
            title: "Location Permission Required",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }))
        
        self.present(alert, animated: true)
    }
    func didUpdateLocation(_ location: CLLocation) {
         // Center map on user location
         let region = MKCoordinateRegion(center: location.coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
         mapVw.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        pin.title = "You are here"
        mapVw.addAnnotation(pin)
     }

     func didFailWithError(_ error: Error) {
         print("❌ Location error: \(error.localizedDescription)")
     }
}
extension MapViewController: MKMapViewDelegate {
    
    // MARK: - Add Custom Marker and Remove Previous Ones
    
    // MARK: - Customize Annotation View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Avoid changing the default blue dot for user location
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        let identifier = "CustomMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "map_Marker") // 🔹 Ensure this image is in Assets

            // Offset to place pin tip on exact coordinate
            if let image = annotationView?.image {
                annotationView?.centerOffset = CGPoint(x: 0, y: -image.size.height / 2)
            }
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}
