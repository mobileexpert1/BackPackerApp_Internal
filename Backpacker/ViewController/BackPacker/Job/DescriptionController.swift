//
//  DescriptionController.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit
import MapKit
import SkeletonView
protocol DescriptionControllerDelegate: AnyObject {
    func descriptionController(_ controller: DescriptionController, didUpdateHeight height: CGFloat)
}

class DescriptionController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var description_Scroll: UIScrollView!
    @IBOutlet weak var mapVw: MKMapView!
    //Outlet
    
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Requirment: UILabel!
    @IBOutlet weak var lbl_JobDescription: UILabel!
    
    
    
    //Value Outlets
    
    @IBOutlet weak var val_Rate: UILabel!
    @IBOutlet weak var header_raterPerhour: UILabel!
    @IBOutlet weak var lbl_Val_EndTime: UILabel!
    @IBOutlet weak var lbl_Val_StartTime: UILabel!
    @IBOutlet weak var lbl_Val_StartDate: UILabel!
    @IBOutlet weak var lbl_EndTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lbl_Description_Value: UILabel!
    @IBOutlet weak var lbl_RequirmentValue: UILabel!
    
    @IBOutlet weak var lbl_MapLocation_Value: UILabel!
    @IBOutlet weak var btn_VwOnMap: UIButton!
    
    @IBOutlet weak var vwStartTime: UIView!
    @IBOutlet weak var vwDate: UIView!
    
    @IBOutlet weak var vwEndTime: UIView!
    var objJobDetail : JobDetail?
    var EmpobjJobDetail : EmployerJobDetail?
    var lbl_Descripyion_ContentHeight : CGFloat?
    var lbl_requirment__ContentHeight : CGFloat?
    weak var delegate: DescriptionControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapVw.delegate = self
        setupButtonBorders()
        self.setUpFonts()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if BackpackerHire
        if let obj = self.EmpobjJobDetail {
            self.setUpUIEmployer(obj: obj)
        }
        #else
        
        if let obj = self.objJobDetail {
            self.setUpUI(obj: obj)
        }
#endif
    }
    func refreshData(obj: EmployerJobDetail) {
        if let formatted = obj.startDate.formattedISODate() {
            self.lbl_Val_StartDate.text = formatted
        }
        if let start = obj.startTime.toAmPmFormat(), let end = obj.endTime.toAmPmFormat() {
            print("Start: \(start), End: \(end)")
            self.lbl_Val_EndTime.text = end
            self.lbl_Val_StartTime.text = start
        }
        self.val_Rate.text = "$\(obj.price)"
        self.lbl_Description_Value.text = obj.description
        self.lbl_RequirmentValue.text = obj.requirements
        print("Scroll Content height", self.contentView.frame.height)
        self.lbl_MapLocation_Value.text  = obj.address
        let font = FontManager.inter(.medium, size: 13.0)
        let labelWidth = view.frame.width - 40 // e.g. 16 padding on each side
        let calculatedHeightDescription = obj.description.heightForLabel(font: font, width: labelWidth)
        let calculatedHeightRequirment = obj.requirements.heightForLabel(font: font, width: labelWidth)
        self.lbl_Descripyion_ContentHeight = calculatedHeightDescription
        self.lbl_requirment__ContentHeight =  calculatedHeightRequirment
        let lat = obj.lat
        let lon = obj.long
        showMarkerOnMap(latitude: lat, longitude: lon, title: obj.address)
        self.setUpHeight()
      }
    
    func refreshDatabp(obj: JobDetail) {
        if let formatted = obj.startDate.formattedISODate() {
            self.lbl_Val_StartDate.text = formatted
        }
        if let start = obj.startTime.toAmPmFormat(), let end = obj.endTime.toAmPmFormat() {
            print("Start: \(start), End: \(end)")
            self.lbl_Val_EndTime.text = end
            self.lbl_Val_StartTime.text = start
        }
        self.val_Rate.text = "$\(obj.price)"
        self.lbl_Description_Value.text = obj.description
        self.lbl_RequirmentValue.text = obj.requirements
        print("Scroll Content height", self.contentView.frame.height)
        self.lbl_MapLocation_Value.text  = obj.locationText
        let font = FontManager.inter(.medium, size: 13.0)
        let labelWidth = view.frame.width - 40 // e.g. 16 padding on each side
        let calculatedHeightDescription = obj.description.heightForLabel(font: font, width: labelWidth)
        let calculatedHeightRequirment = obj.requirements.heightForLabel(font: font, width: labelWidth)
        self.lbl_Descripyion_ContentHeight = calculatedHeightDescription
        self.lbl_requirment__ContentHeight =  calculatedHeightRequirment
        let lat = obj.lat
        let lon = obj.long
        showMarkerOnMap(latitude: lat, longitude: lon, title: obj.address)
        self.setUpHeight()
      }
    private func setupButtonBorders() {
        self.header_raterPerhour.font = FontManager.inter(.semiBold, size: 14.0)
        self.val_Rate.font = FontManager.inter(.medium, size: 14.0)
      
        self.vwDate.addShadowAllSides(radius: 2)
        self.vwStartTime.addShadowAllSides(radius: 2)
        self.vwEndTime.addShadowAllSides(radius: 2)

    }
    
    
    private func setUpFonts(){
        lbl_Duration.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Location.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Requirment.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_JobDescription.font = FontManager.inter(.semiBold, size: 14.0)
        btn_VwOnMap.titleLabel?.font = FontManager.inter(.regular, size: 12.0)
        
        lbl_Description_Value.font = FontManager.inter(.regular, size: 12.0)
        lbl_RequirmentValue.font = FontManager.inter(.regular, size: 12.0)
        lbl_MapLocation_Value.font = FontManager.inter(.regular, size: 12.0)
        
        self.lblDate.font = FontManager.inter(.regular, size: 12.0)
        self.lblStartTime.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_EndTime.font = FontManager.inter(.regular, size: 12.0)
        
        self.lbl_Val_EndTime.font = FontManager.inter(.semiBold, size: 12.0)
        self.lbl_Val_StartTime.font = FontManager.inter(.semiBold, size: 12.0)
        self.lbl_Val_StartDate.font = FontManager.inter(.semiBold, size: 12.0)
    }
    
    @IBAction func action_Accept(_ sender: Any) {
        
        
    }
    @IBAction func action_Decline(_ sender: Any) {
        
        
    }
    @IBAction func action_OpenMAp(_ sender: Any) {
        
#if BackpackerHire
        if let lat = self.EmpobjJobDetail?.lat,
           let long = self.EmpobjJobDetail?.long {
            openJobLocation(lat: lat, long: long)
        }
        
        #else
        
        if let lat = self.objJobDetail?.lat,
           let long = self.objJobDetail?.long {
            openJobLocation(lat: lat, long: long)
        }
#endif
       
    }
    func openJobLocation(lat: Double, long: Double, title: String = "Job Location") {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        ])
    }

    func setUpUI(obj: JobDetail){
        if let formatted = obj.startDate.formattedISODate() {
            self.lbl_Val_StartDate.text = formatted
        }
        if let start = obj.startTime.toAmPmFormat(), let end = obj.endTime.toAmPmFormat() {
            print("Start: \(start), End: \(end)")
            self.lbl_Val_EndTime.text = end
            self.lbl_Val_StartTime.text = start
        }
        self.val_Rate.text = "$\(obj.price)"
        self.lbl_Description_Value.text = obj.description
        self.lbl_RequirmentValue.text = obj.requirements
        print("Scroll Content height", self.contentView.frame.height)
        self.lbl_MapLocation_Value.text  = obj.address
        let font = FontManager.inter(.medium, size: 13.0)
        let labelWidth = view.frame.width - 40 // e.g. 16 padding on each side
        let calculatedHeightDescription = obj.description.heightForLabel(font: font, width: labelWidth)
        let calculatedHeightRequirment = obj.requirements.heightForLabel(font: font, width: labelWidth)
        self.lbl_Descripyion_ContentHeight = calculatedHeightDescription
        self.lbl_requirment__ContentHeight =  calculatedHeightRequirment
        let lat = obj.lat
        let lon = obj.long
        showMarkerOnMap(latitude: lat, longitude: lon, title: obj.address)
        self.setUpHeight()
    }
    func setUpUIEmployer(obj: EmployerJobDetail){
        if let formatted = obj.startDate.formattedISODate() {
            self.lbl_Val_StartDate.text = formatted
        }
        if let start = obj.startTime.toAmPmFormat(), let end = obj.endTime.toAmPmFormat() {
            print("Start: \(start), End: \(end)")
            self.lbl_Val_EndTime.text = end
            self.lbl_Val_StartTime.text = start
        }
        self.val_Rate.text = "$\(obj.price)"
        self.lbl_Description_Value.text = obj.description
        self.lbl_RequirmentValue.text = obj.requirements
        print("Scroll Content height", self.contentView.frame.height)
        self.lbl_MapLocation_Value.text  = obj.address
        let font = FontManager.inter(.medium, size: 13.0)
        let labelWidth = view.frame.width - 40 // e.g. 16 padding on each side
        let calculatedHeightDescription = obj.description.heightForLabel(font: font, width: labelWidth)
        let calculatedHeightRequirment = obj.requirements.heightForLabel(font: font, width: labelWidth)
        self.lbl_Descripyion_ContentHeight = calculatedHeightDescription
        self.lbl_requirment__ContentHeight =  calculatedHeightRequirment
        let lat = obj.lat
        let lon = obj.long
        showMarkerOnMap(latitude: lat, longitude: lon, title: obj.address)
        self.setUpHeight()
    }
    func setUpHeight() {
        let descriptionHeight = lbl_Descripyion_ContentHeight ?? 50
        let requirementHeight = lbl_requirment__ContentHeight ?? 50
        let mapHeight: CGFloat =  300.0 //240.0
        let topViewHeight: CGFloat =  170.0
        //105 255
        let totalHeight = descriptionHeight + requirementHeight + mapHeight + topViewHeight + 112
        let addHeight = totalHeight
        self.description_Scroll.contentSize.height = addHeight
        delegate?.descriptionController(self, didUpdateHeight:  addHeight)
        
        
    }
    
    
    
}
extension DescriptionController: MKMapViewDelegate {
    
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
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func showMarkerOnMap(latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees,
                         title: String = "Location",
                         subtitle: String? = nil) {
        
        // Remove previous markers (except user location)
        let nonUserAnnotations = mapVw.annotations.filter { !($0 is MKUserLocation) }
        mapVw.removeAnnotations(nonUserAnnotations)
        
        // Create annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        annotation.subtitle = subtitle
        
        // Add to map
        mapVw.addAnnotation(annotation)
        
        // Zoom in
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        mapVw.setRegion(region, animated: true)
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
