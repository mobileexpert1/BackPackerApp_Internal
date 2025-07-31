//
//  AccountDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class AccountDetailVC: UIViewController {
    @IBOutlet weak var EmailVw: CommonTxtFldLblVw!
    
    @IBOutlet weak var visaTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var AreaVW: CommonTxtFldLblVw!
    @IBOutlet weak var CountryVw: CommonTxtFldLblVw!
    @IBOutlet weak var stateVw: CommonTxtFldLblVw!
    @IBOutlet weak var phoneNumberVw: CommonTxtFldLblVw!
    @IBOutlet weak var NameVw: CommonTxtFldLblVw!
    @IBOutlet weak var vWHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVw_Visa: UITableView!
    @IBOutlet weak var btn_drpdwn: UIButton!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var lbl_VisaTitle: UILabel!
    
    @IBOutlet weak var BgVwTbl: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var visaVw: UIView!
    
    @IBOutlet weak var stckBotmHeight: NSLayoutConstraint!
    //heightConstraint
    
    let visaTypes = [
        "Tourist Visa",
        "Business Visa",
        "Student Visa",
        "Work Visa",
        "Transit Visa",
        "Spouse/Partner Visa",
        "Diplomatic Visa",
        "Refugee Visa",
        "Permanent Residency",
        "Investor Visa"
    ]
    @IBOutlet weak var lblzHeaderVisa: UILabel!
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpButtons()
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.setUPFLDS()
        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw_Visa.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw_Visa.delegate = self
        self.tblVw_Visa.dataSource = self
        self.btn_Edit.tag = 0
        handleBottomBtn()
        if role == "3" || role == "4" ||  role == "2"{
            self.visaTypeHeight.constant = 0.0
            self.visaVw.isHidden = true
            self.btn_drpdwn.tag = 0
            self.manageHeightOfTable()
            self.btn_drpdwn.isHidden = true
        }
    }
    private func setUPFLDS(){
       
        self.lblzHeaderVisa.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_VisaTitle.font = FontManager.inter(.regular, size: 12.0)
        self.visaVw.addShadowAllSides(radius:2)
        self.NameVw.setPlaceholder("Name")
        self.NameVw.setTitleLabel("Name")
        self.NameVw.lblErrorVisibility(val: true)
        
        self.phoneNumberVw.setPlaceholder("Phone Number")
        self.phoneNumberVw.setTitleLabel("Phone Number")
        self.phoneNumberVw.lblErrorVisibility(val: true)
        
        self.EmailVw.setPlaceholder("Email")
        self.EmailVw.setTitleLabel("Email")
        self.EmailVw.lblErrorVisibility(val: true)
        
        self.stateVw.setPlaceholder("State")
        self.stateVw.setTitleLabel("State")
        self.stateVw.lblErrorVisibility(val: true)
        
        self.CountryVw.setPlaceholder("Country")
        self.CountryVw.setTitleLabel("Country")
        self.CountryVw.lblErrorVisibility(val: true)
        
        self.AreaVW.setPlaceholder("Area")
        self.AreaVW.setTitleLabel("Area")
        self.AreaVW.lblErrorVisibility(val: true)
    }
    
    private func setUpButtons(){
        self.btn_drpdwn.tag = 0
        self.manageHeightOfTable()
        btn_Cancel.titleLabel?.font = FontManager.inter(.semiBold, size: 14.0)
        btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 14.0)
        
        // Corner Radius
        btn_Save.layer.cornerRadius = 10.0
        // Border
        applyGradientButtonStyle(to: btn_Save)
        // Optional: Clip to bounds for corner radius to work
        btn_Cancel.clipsToBounds = true
        self.tblVwHeight.constant = 0.0
        self.btn_Edit.titleLabel?.font = FontManager.inter(.medium, size: 16.0)
    }
    @IBAction func action_VisaDrpDwn(_ sender: Any) {
        
        if btn_drpdwn.tag == 0{
            self.btn_drpdwn.tag = 1
        }else{
            self.btn_drpdwn.tag = 0
        }
        self.manageHeightOfTable()
    }
    func manageHeightOfTable(){
        if self.btn_drpdwn.tag == 0{
            self.tblVwHeight.constant = 0.0
            self.vWHeightContraint.constant = 0.0
            self.BgVwTbl.addShadowAllSides(radius: 0)
        }else{
            self.BgVwTbl.addShadowAllSides(radius: 1.5)
            self.tblVwHeight.constant = 176.0
            self.vWHeightContraint.constant = 190.0
        }
    }
    
    @IBAction func action_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        if self.btn_Edit.tag == 0{
            self.btn_Edit.tag = 1
        }else{
            self.btn_Edit.tag = 0
        }
        self.handleBottomBtn()
    }
    private func handleBottomBtn(){
        if self.btn_Edit.tag == 0{
            self.stckBotmHeight.constant = 0.0
        }else{
            self.stckBotmHeight.constant = 50.0
        }
    }
    @IBAction func actionSave(_ sender: Any) {
        
        let isNameValid = NameVw.validateNotEmpty(errorMessage: "Please enter your name")
        let isEmailValid = EmailVw.validateNotEmpty(errorMessage: "Please enter your email")
        let isPhoneValid = phoneNumberVw.validateNotEmpty(errorMessage: "Please enter your phone number")
        let isCountryValid = CountryVw.validateNotEmpty(errorMessage: "Please enter your country")
        let isStateValid = stateVw.validateNotEmpty(errorMessage: "Please enter your state")
        let isAreaValid = AreaVW.validateNotEmpty(errorMessage: "Please enter your area")

        if isNameValid && isEmailValid && isPhoneValid && isCountryValid && isStateValid && isAreaValid {
            // ✅ All fields are valid
            // Proceed to next screen or save data
        } else {
            // ❌ One or more fields are invalid, errors already shown in each view
        }

    }
    
    
    @IBAction func action_Cancelk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AccountDetailVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visaTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportIssueTVC", for: indexPath) as? ReportIssueTVC else {
            return UITableViewCell()
        }

        cell.lbl_Issue.text = visaTypes[indexPath.row] // assuming your cell has `lbl_title`
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIssue = visaTypes[indexPath.row]
            print("Selected issue: \(selectedIssue)")
        self.lbl_VisaTitle.text = selectedIssue
        self.btn_drpdwn.tag = 0
        self.manageHeightOfTable()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
