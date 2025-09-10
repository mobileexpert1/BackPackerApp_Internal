//
//  BackPackerDetailVC.swift
//  BackpackerHire
//
//  Created by Mobile on 25/07/25.
//

import UIKit
import MapKit
class BackPackerDetailVC: UIViewController {
    @IBOutlet weak var mapVw: MKMapView!
    let sectionTitles = ["Accepted", "Declined"]
    let itemsPerSection = [
        ["Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa"],
        ["Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh"],
        ["Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai"] // 👈 Add a third section here
    ]
    @IBOutlet weak var tblVw: UITableView!
    
    @IBOutlet weak var lbl_Val_JobCount: UILabel!
    @IBOutlet weak var lbl_ValNam: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lbl_AddressVal: UILabel!
    @IBOutlet weak var lbl_TotalJobs: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_mainHeader: UILabel!
    let Role =  UserDefaults.standard.string(forKey: "UserRoleType")
    var obj : Backpacker?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.isHidden = true
 //       let nib = UINib(nibName: "HomeTVC", bundle: nil)
//        self.tblVw.register(nib, forCellReuseIdentifier: "HomeTVC")
//        tblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                    //        forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
//        self.tblVw.delegate = self
//        self.tblVw.dataSource = self
        tblVw.showsVerticalScrollIndicator = false
        tblVw.showsHorizontalScrollIndicator = false
        tblVw.contentInset = .zero
        tblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        self.setUpUi()
        self.setUpData()
    }
    private func setUpUi(){
        self.lbl_mainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.lblName.font = FontManager.inter(.regular, size: 13.0)
        self.lbl_TotalJobs.font = FontManager.inter(.regular, size: 13.0)
        self.lbl_Address.font = FontManager.inter(.regular, size: 13.0)
        
        self.lbl_ValNam.font = FontManager.inter(.semiBold, size: 13.0)
        self.lbl_Val_JobCount.font = FontManager.inter(.semiBold, size: 13.0)
        self.lbl_AddressVal.font = FontManager.inter(.semiBold, size: 13.0)
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setUpData() {
        if let obj = obj {
            if obj.name.isEmpty {
                self.lbl_ValNam.text = obj.mobileNumber
            } else {
                self.lbl_ValNam.text = obj.name
            }
            
            self.lbl_Val_JobCount.text = "\(obj.jobsCount)"
            // Show marker on map  // 30.635736085050272, 76.72116343400654
            showMapMarker(latitude: obj.lat, longitude: obj.long, title: obj.name, subtitle: "")

            // Fetch address from coordinates
            fetchAddressFromCoordinates(latitude: obj.lat, longitude: obj.long) { [weak self] fetchedAddress in
                DispatchQueue.main.async {
                    if let addressString = fetchedAddress {
                        self?.lbl_AddressVal.text = addressString
                    } else {
                        self?.lbl_AddressVal.text = "No found" // fallback to the existing address
                    }
                }
            }
        }
    }

    private func showMapMarker(latitude: Double, longitude: Double, title: String, subtitle: String) {
        let coordinate: CLLocationCoordinate2D

        if latitude == 0.0 && longitude == 0.0 {
            // Set fallback location (for example, center of the world or a default city)
            let lat = LocationManager.shared.latitude
            let long = LocationManager.shared.longitude
            coordinate = CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: long ?? 0.0) // Example: London
            self.title = "Curen"
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
extension BackPackerDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
            return UITableViewCell()
        }
        let sectionItems = itemsPerSection[indexPath.section]
        cell.isComeForHireDetailPage  = true
        //cell.isComeFromJob = false
        cell.configure(with: sectionItems,section: indexPath.section)
        cell.onTap = { [weak self]  val  in
            guard let self = self else { return }
            print("Cell tapped at index: \(indexPath.item)")
            // Navigate or perform any action
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.titleLaBLE.text = sectionTitles[section]
        header.section = section
        header.contentView.backgroundColor = .white // prevent background flicker
        header.onButtonTap = { [weak self] tappedSection in
            
            self?.handleHeaderButtonTap(in: tappedSection)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
  
    private func handleHeaderButtonTap(in section: Int) {
        print("Button tapped in section \(section)")
    }
    
}
