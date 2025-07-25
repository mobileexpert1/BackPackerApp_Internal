//
//  JobDescriptionVC.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit

class JobDescriptionVC: UIViewController {

    @IBOutlet weak var description_ContainerVW: UIView!
    @IBOutlet weak var lblEmployer: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var vW_Employer: UIView!
    @IBOutlet weak var vW_Description: UIView!
    @IBOutlet weak var btn_Employer: UIButton!
    @IBOutlet weak var btn_Description: UIButton!
    
    @IBOutlet weak var lbl_Header: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_Address: UILabel!
    
    @IBOutlet weak var lbl_Time: UILabel!
    var firstVC: DescriptionController!
    var secondVC: EmployerController!

    var currentChildVC: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           firstVC = storyboard.instantiateViewController(withIdentifier: "DescriptionController") as? DescriptionController
           secondVC = storyboard.instantiateViewController(withIdentifier: "EmployerController") as? EmployerController
           
           self.setUPBtns()
           self.showChild(firstVC)
        // Do any additional setup after loading the view.
#if Backapacker
        
        self.segmentHeight.constant = 50.0
        #else
        
        self.segmentHeight.constant = 0.0
        self.lbl_Description.isHidden = true
        self.lblEmployer.isHidden = true
#endif
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setUPBtns(){
        self.btn_Description.tag = 1
        self.btn_Employer.tag = 0
        self.vW_Employer.layer.cornerRadius = 10
        self.vW_Description.layer.cornerRadius = 10
        self.vW_Description.backgroundColor = UIColor(named: "themeColor")
        self.lblEmployer.textColor = .black
        self.lbl_Description.textColor =  .white
        
        
        self.lbl_Description.text = "Description"
        self.lblEmployer.text = "Employer"
        lbl_Header.font = FontManager.inter(.medium, size: 16.0)
        lblTitle.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Address.font = FontManager.inter(.regular, size: 12.0)
        lbl_Time.font = FontManager.inter(.regular, size: 12.0)
        lbl_Description.font = FontManager.inter(.medium, size: 14.0)
        lblEmployer.font = FontManager.inter(.medium, size: 14.0)
    }

    @IBAction func action_btnDescription(_ sender: Any) {
        self.btn_Description.tag = 1
        self.btn_Employer.tag = 0
        if btn_Description.tag == 1 {
            self.vW_Description.backgroundColor  = UIColor(named: "themeColor")
            self.lbl_Description.textColor = .white
            self.lblEmployer.textColor =  .black
            self.vW_Employer.backgroundColor = .clear
        }
        self.setBtnTitle()
        self.showChild(firstVC)
    }
    @IBAction func action_BtnEmployer(_ sender: Any) {
        
        self.btn_Employer.tag = 1
        self.btn_Description.tag = 0
        if btn_Employer.tag == 1 {
            self.vW_Employer.backgroundColor = UIColor(named: "themeColor")
            self.lblEmployer.textColor = .white
            self.lbl_Description.textColor =  .black
            self.vW_Description.backgroundColor = .clear
        }
        self.setBtnTitle()
        self.showChild(secondVC)
    }
    
    @IBAction func action_Bck(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setBtnTitle(){
        self.lbl_Description.text = "Description"
        self.lblEmployer.text = "Employer"
    }
    
    private func showChild(_ newVC: UIViewController) {
        // Remove current child if any
        if let currentVC = currentChildVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }

        // Add new child
        addChild(newVC)
        newVC.view.frame = description_ContainerVW.bounds // ✅ Corrected line
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        description_ContainerVW.addSubview(newVC.view)
        newVC.didMove(toParent: self)

        // Update current
        currentChildVC = newVC
    }


    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
