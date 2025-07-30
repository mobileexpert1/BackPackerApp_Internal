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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupButtonBorders()
        self.setUpFonts()
     }

     private func setupButtonBorders() {
         self.header_raterPerhour.font = FontManager.inter(.semiBold, size: 14.0)
         self.val_Rate.font = FontManager.inter(.medium, size: 14.0)
         btn_Accept.layer.cornerRadius = 10
         btn_Decline.layer.cornerRadius = 10
         applyGradientButtonStyle(to: btn_Accept)
         self.vwDate.addShadowAllSides(radius: 2)
         self.vwStartTime.addShadowAllSides(radius: 2)
         self.vwEndTime.addShadowAllSides(radius: 2)
#if BackpackerHire
         self.btn_Accept.isHidden = true
         self.btn_Accept.isUserInteractionEnabled = false
         
         self.btn_Decline.isHidden = true
         self.btn_Decline.isUserInteractionEnabled = false
         
         #else
         self.btn_Accept.isHidden = false
         self.btn_Accept.isUserInteractionEnabled = true
         
         self.btn_Decline.isHidden = false
         self.btn_Decline.isUserInteractionEnabled = true
         
         
#endif
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
