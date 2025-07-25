//
//  SubscriptionVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit

class SubscriptionVC: UIViewController {
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var lbl_ChoosePlan: UILabel!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    
    @IBOutlet weak var Vw_premium: UIView!
    
    @IBOutlet weak var ve_Annual: UIView!
    
    @IBOutlet weak var vw_Freetrial: UIView!
    
    
    @IBOutlet weak var btnProceed: UIButton!
    
    @IBOutlet weak var btn_Cancle: UIButton!
    
    @IBOutlet weak var lbl_premium: UILabel!
    
    @IBOutlet weak var lbl_PremiumAmny: UILabel!
    
    @IBOutlet weak var premiumImg: UIImageView!
    
    @IBOutlet weak var lbl_Anual: UILabel!
    @IBOutlet weak var imgFreetrial: UIImageView!
    
    @IBOutlet weak var lbl_freetrialAmount: UILabel!
    @IBOutlet weak var lbl_FreeTrial: UILabel!
    @IBOutlet weak var img_Annual: UIImageView!
    @IBOutlet weak var lbl_AnnualAmount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientButtonStyle(to: self.btnProceed)
        
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_ChoosePlan.font = FontManager.inter(.semiBold, size: 20.0)
        self.lbl_SubTitle.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_premium.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_PremiumAmny.font = FontManager.inter(.regular, size: 16.0)
        self.lbl_Anual.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_AnnualAmount.font = FontManager.inter(.regular, size: 16.0)
        self.lbl_FreeTrial.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_freetrialAmount.font = FontManager.inter(.regular, size: 16.0)
        
        self.btnProceed.titleLabel?.font  = FontManager.inter(.medium, size: 16.0)
        self.btn_Cancle.titleLabel?.font  = FontManager.inter(.medium, size: 16.0)
        vw_Freetrial.addShadowAllSides(radius:2)
        Vw_premium.addShadowAllSides(radius:2)
        ve_Annual.addShadowAllSides(radius:2)
        vw_Freetrial.layer.cornerRadius = 10.0
        Vw_premium.layer.cornerRadius = 10.0
        ve_Annual.layer.cornerRadius = 10.0
        self.imgFreetrial.image = UIImage(named: "off")
        self.premiumImg.image = UIImage(named: "off")
        self.img_Annual.image = UIImage(named: "off")
    }
    
    @IBAction func action_Freetrial(_ sender: Any) {
        self.imgFreetrial.image = UIImage(named: "on")
        self.premiumImg.image = UIImage(named: "off")
        self.img_Annual.image = UIImage(named: "off")
        
    }
    @IBAction func action_Premium(_ sender: Any) {
        self.premiumImg.image = UIImage(named: "on")
        self.imgFreetrial.image = UIImage(named: "off")
        self.img_Annual.image = UIImage(named: "off")
    }
    
    
    @IBAction func action_Annual(_ sender: Any) {
        self.img_Annual.image = UIImage(named: "on")
        self.imgFreetrial.image = UIImage(named: "off")
        self.premiumImg.image = UIImage(named: "off")
        
    }
    
    @IBAction func action_Proceed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
