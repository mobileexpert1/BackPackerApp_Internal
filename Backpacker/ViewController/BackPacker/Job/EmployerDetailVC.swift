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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUPUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleAppearanceForBackacker(isComeFromEmployer: isComeFrom)
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
            self.VwHeight.constant = 110.0
            self.lbl_SecdaryMainLbl.isHidden = false
            self.lbl_MainHeader.text = "Employer Detail"
           
        }else{
            self.VwHeight.constant = 0.0
            self.lbl_SecdaryMainLbl.isHidden = true
            self.lbl_MainHeader.text = "Backpacker Detail"
        }
        
        
    }
    
}
