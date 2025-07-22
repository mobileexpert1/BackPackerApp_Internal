//
//  DescriptionController.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit
import MapKit

class DescriptionController: UIViewController {

    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var btn_Accept: UIButton!
    @IBOutlet weak var btn_Decline: UIButton!
    //Outlet
    
    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Requirment: UILabel!
    @IBOutlet weak var lbl_JobDescription: UILabel!
    
    @IBOutlet weak var lbl_Timing: UILabel!
    @IBOutlet weak var lbl_EndDtae: UILabel!
    @IBOutlet weak var lbl_StrtDate: UILabel!
    
    //Value Outlets
    @IBOutlet weak var lbl_StrtDate_Value: UILabel!
    @IBOutlet weak var lbl_EndDate_Value: UILabel!
    @IBOutlet weak var lbl_Timeing_Value: UILabel!
    @IBOutlet weak var lbl_Description_Value: UILabel!
    @IBOutlet weak var lbl_RequirmentValue: UILabel!
    
    @IBOutlet weak var lbl_MapLocation_Value: UILabel!
    @IBOutlet weak var btn_VwOnMap: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupButtonBorders()
        self.setUpFonts()
     }

     private func setupButtonBorders() {
         btn_Accept.layer.cornerRadius = 10
         btn_Decline.layer.cornerRadius = 10
         applyGradientButtonStyle(to: btn_Accept)
     }
    
    
    private func setUpFonts(){
        lbl_Duration.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Location.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Requirment.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_JobDescription.font = FontManager.inter(.semiBold, size: 14.0)
        btn_VwOnMap.titleLabel?.font = FontManager.inter(.regular, size: 12.0)
        lbl_Timing.font = FontManager.inter(.regular, size: 12.0)
        lbl_EndDtae.font = FontManager.inter(.regular, size: 12.0)
        lbl_Timing.font = FontManager.inter(.regular, size: 12.0)
        lbl_StrtDate.font = FontManager.inter(.regular, size: 12.0)
        //Value
        lbl_StrtDate_Value.font = FontManager.inter(.regular, size: 12.0)
        lbl_EndDate_Value.font = FontManager.inter(.regular, size: 12.0)
        lbl_Timeing_Value.font = FontManager.inter(.regular, size: 12.0)
        lbl_Description_Value.font = FontManager.inter(.regular, size: 12.0)
        lbl_RequirmentValue.font = FontManager.inter(.regular, size: 12.0)
        lbl_MapLocation_Value.font = FontManager.inter(.regular, size: 12.0)
    }
    
    @IBAction func action_Accept(_ sender: Any) {
        
        
    }
    @IBAction func action_Decline(_ sender: Any) {
        
        
    }
    @IBAction func action_OpenMAp(_ sender: Any) {
        let latitude: CLLocationDegrees = 30.7112
            let longitude: CLLocationDegrees = 76.7184
            
            openMapAtCoordinates(latitude: latitude, longitude: longitude)
    }
    func openMapAtCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Selected Location"
        mapItem.openInMaps(launchOptions: options)
    }

}
