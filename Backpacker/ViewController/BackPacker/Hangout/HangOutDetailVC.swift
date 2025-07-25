//
//  HangOutDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import MapKit

class HangOutDetailVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var title_Location: UILabel!
    
    @IBOutlet weak var btn_ViewOnMap: UIButton!
    
    @IBOutlet weak var lbl_Address: UILabel!
    
    @IBOutlet weak var title_About: UILabel!
    
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var lbl_restaurantName: UILabel!
    
    @IBOutlet weak var lbl_AboutDescription: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
    }
    
    private func setUpUI(){
        self.title_Location.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_Address.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_restaurantName.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_Rating.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_review.font = FontManager.inter(.regular, size: 10.0)
        self.title_About.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_AboutDescription.font = FontManager.inter(.regular, size: 12.0)
        btn_ViewOnMap.titleLabel?.font = FontManager.inter(.regular, size: 12.0)
    }
    @IBAction func action_VwOnMap(_ sender: Any) {
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
