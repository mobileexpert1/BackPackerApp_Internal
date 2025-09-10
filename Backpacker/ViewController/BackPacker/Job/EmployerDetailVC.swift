//
//  EmployerDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import MapKit

class EmployerDetailVC: UIViewController {

    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var ValueName: UILabel!
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var valueAddrees: UILabel!
    @IBOutlet weak var valueJobs: UILabel!
    @IBOutlet weak var titleTotalJobs: UILabel!
    @IBOutlet weak var titleAddress: UILabel!
    
    @IBOutlet weak var lbl_SecdaryMainLbl: UILabel!
    
    @IBOutlet weak var VwHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCityName: UILabel!
    
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbljobCount: UILabel!
    var isComeFrom : Bool = false
    var name = String()
    var totalJobs = String()
    var address = String()
    var lat = Double()
    var long = Double()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUPUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleAppearanceForBackacker(isComeFromEmployer: isComeFrom)
        self.setUpLableValues()
    }
    
    private func setUPUI(){
        
        self.lbl_Location.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        
        self.titleName.font = FontManager.inter(.regular, size: 13.0)
        self.titleAddress.font = FontManager.inter(.regular, size: 13.0)
        self.titleAddress.font = FontManager.inter(.regular, size: 13.0)
        self.lblCityName.font = FontManager.inter(.regular, size: 13.0)
        
        self.valueJobs.font = FontManager.inter(.semiBold, size: 13.0)
        self.ValueName.font = FontManager.inter(.semiBold, size: 13.0)
        self.valueAddrees.font = FontManager.inter(.semiBold, size: 13.0)
        
        self.titleTotalJobs.font = FontManager.inter(.regular, size: 13.0)
        self.lbl_Location.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbljobCount.font = FontManager.inter(.semiBold, size: 13.0)
        
        
        self.lbl_SecdaryMainLbl.font = FontManager.inter(.semiBold, size: 13.0)
    }

    @IBAction func action_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleAppearanceForBackacker(isComeFromEmployer:Bool = false){
        if  isComeFromEmployer {
//            self.VwHeight.constant = 110.0
//            self.lbl_SecdaryMainLbl.isHidden = false
            self.VwHeight.constant = 0.0
            self.lbl_SecdaryMainLbl.isHidden = true
            self.lbl_MainHeader.text = "Employer Detail"
           
        }else{
            self.VwHeight.constant = 0.0
            self.lbl_SecdaryMainLbl.isHidden = true
            self.lbl_MainHeader.text = "Backpacker Detail"
        }
        
        
    }
    
    private func setUpLableValues(){
        self.valueJobs.text = self.totalJobs
        self.ValueName.text = self.name

        // Show marker on map
        showMapMarker(latitude: lat, longitude: long, title: name, subtitle: address)

        // Fetch address from coordinates
        fetchAddressFromCoordinates(latitude: lat, longitude: long) { [weak self] fetchedAddress in
            DispatchQueue.main.async {
                if let addressString = fetchedAddress {
                    self?.valueAddrees.text = addressString
                } else {
                    self?.valueAddrees.text = self?.address // fallback to the existing address
                }
            }
        }
    }

    private func showMapMarker(latitude: Double, longitude: Double, title: String, subtitle: String) {
        let coordinate: CLLocationCoordinate2D

        if latitude == 0.0 && longitude == 0.0 {
            // Set fallback location (for example, center of the world or a default city)
            coordinate = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278) // Example: London
        } else {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.mapVw.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        self.mapVw.addAnnotation(annotation)
    }

    private func fetchAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                var addressString = ""
                
                if let name = placemark.name {
                    addressString += name + ", "
                }
                if let locality = placemark.locality {
                    addressString += locality + ", "
                }
                if let administrativeArea = placemark.administrativeArea {
                    addressString += administrativeArea + ", "
                }
                if let country = placemark.country {
                    addressString += country
                }
                
                completion(addressString)
            } else {
                completion(nil)
            }
        }
    }

}
