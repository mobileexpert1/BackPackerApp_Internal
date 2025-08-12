//
//  EmployerController.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit
import MapKit

class EmployerController: UIViewController {
    @IBOutlet weak var mapViw: MKMapView!
    //OutLet Lables
    @IBOutlet weak var lbl_Emplyeer_Detail: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_CompletedJobs: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    //Outlet lable Values
    @IBOutlet weak var lbl_Name_Value: UILabel!
    @IBOutlet weak var lbl_CompletedJobsValue: UILabel!
    @IBOutlet weak var lbl_Address_Value: UILabel!
    var objJobDetail : JobDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        ///  setUpAttributedText()
        mapViw.delegate = self
        setUpFonts()
        self.lbl_Emplyeer_Detail.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
    
    private func setUpFonts(){
        lbl_Emplyeer_Detail.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Location.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Name_Value.font = FontManager.inter(.semiBold, size: 13.0)
        lbl_CompletedJobsValue.font = FontManager.inter(.semiBold, size: 13.0)
        lbl_Address_Value.font = FontManager.inter(.semiBold, size: 13.0)
        lblName.font = FontManager.inter(.regular, size: 13.0)
        lbl_CompletedJobs.font = FontManager.inter(.regular, size: 13.0)
        lbl_Address.font = FontManager.inter(.regular, size: 13.0)
        
    }
    
    private func setUpAttributedText() {
        setAttributed(label: lblName, title: "Name :", value: "ABC")
        setAttributed(label: lbl_Address, title: "Address :", value: "123 Main Street")
        setAttributed(label: lbl_CompletedJobs, title: "Completed Jobs :", value: "12")
    }
    
    func setupUI(){
        if let empObj = objJobDetail?.employerId {
            // Name
            lbl_Name_Value.text = (empObj.name.isEmpty == false) ? empObj.name : "-"
            
            // Completed Jobs
            lbl_CompletedJobsValue.text = "\(objJobDetail?.completedJobsCount ?? 0)"
            
            // Address
            lbl_Address_Value.text = (empObj.state.isEmpty == false) ? empObj.state : "-"
            
            // Latitude & Longitude
            if   empObj.lat != 0 &&  empObj.long != 0 {
                showMarkerOnMap(latitude: empObj.lat, longitude: empObj.long)
            } else {
                // No marker if coordinates are missing or zero
                mapViw.removeAnnotations(mapViw.annotations)
            }
        }
    }
    
    private func setAttributed(label: UILabel, title: String, value: String) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: label.font.pointSize),
            .foregroundColor: UIColor.label
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: label.font.pointSize),
            .foregroundColor: UIColor.label
        ]
        
        let attributedText = NSMutableAttributedString(string: "\(title) ", attributes: titleAttributes)
        attributedText.append(NSAttributedString(string: value, attributes: valueAttributes))
        label.attributedText = attributedText
    }
}
extension EmployerController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Skip the user location blue dot
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "custom_marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            // Set your custom image
            annotationView?.image = UIImage(named: "custom_marker") // Make sure image exists in Assets

            // Optional: Adjust the anchor point so the bottom of the marker is the coordinate
            annotationView?.centerOffset = CGPoint(x: 0, y: -annotationView!.frame.size.height / 2)

        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func showMarkerOnMap(latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees,
                         title: String = "Location",
                         subtitle: String? = nil) {

        // Remove previous markers (except user location)
        let nonUserAnnotations = mapViw.annotations.filter { !($0 is MKUserLocation) }
        mapViw.removeAnnotations(nonUserAnnotations)

        // Create annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        annotation.subtitle = subtitle

        // Add to map
        mapViw.addAnnotation(annotation)

        // Zoom in
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapViw.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let title = view.annotation?.title ?? nil {
            print("Marker selected: \(title)")
//            self.description_Scroll.layoutIfNeeded()
//            self.view.layoutIfNeeded()
//            setUpHeight()
        }
    }

}
