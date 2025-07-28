//
//  ChooseRoleTypeVC.swift
//  Backpacker
//
//  Created by Mobile on 28/07/25.
//

import UIKit

class ChooseRoleTypeVC: UIViewController {
    let empRoleType = 0
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var Btn_Hangout: UIButton!
    @IBOutlet weak var btn_accomodation: UIButton!
    let accomodationRoleType = 1
    @IBOutlet weak var btn_Save: UIButton!
    let hangOutRoleType = 2
    @IBOutlet weak var btn_employer: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientButtonStyle(to: self.btn_Save)
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_employer.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_accomodation.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.Btn_Hangout.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action_Employer(_ sender: Any) {
        btn_employer.layer.borderColor = UIColor.black.cgColor
        btn_employer.layer.borderWidth = 1.0
        btn_accomodation.layer.borderColor = UIColor.clear.cgColor
        Btn_Hangout.layer.borderColor = UIColor.clear.cgColor
        saveRoleType(empRoleType)
    }
    
    @IBAction func action_Hangout(_ sender: Any) {
        Btn_Hangout.layer.borderColor = UIColor.black.cgColor
        Btn_Hangout.layer.borderWidth = 1.0
        btn_accomodation.layer.borderColor = UIColor.clear.cgColor
        btn_employer.layer.borderColor = UIColor.clear.cgColor
        saveRoleType(hangOutRoleType)
    }
    
    @IBAction func action_Accomodation(_ sender: Any) {
        btn_accomodation.layer.borderColor = UIColor.black.cgColor
        btn_accomodation.layer.borderWidth = 1.0
        Btn_Hangout.layer.borderColor = UIColor.clear.cgColor
        btn_employer.layer.borderColor = UIColor.clear.cgColor
        saveRoleType(accomodationRoleType)
       
    }
    
    private func saveRoleType(_ type: Int) {
        UserDefaults.standard.set(type, forKey: "UserRoleType")
        UserDefaults.standard.synchronize() // optional
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Save(_ sender: Any) {
        let tabBarVC = UIStoryboard(name: "TabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
        UIApplication.setRootViewController(tabBarVC)
        
    }
}
