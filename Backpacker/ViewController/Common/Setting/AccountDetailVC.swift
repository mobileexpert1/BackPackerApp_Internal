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
    @IBOutlet weak var lbl_error_VisaHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_error_SelectVisaType: UILabel!
    let profileVm = ProfileVM()
    let viewModelAuth = LogInVM()
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
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_editHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_backHeight: NSLayoutConstraint!
    var isComeFromUpdate : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpButtons()
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.setUpFonts()
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
            if role == "2" {
                self.lbl_MainHeader.isHidden = true
                self.btn_Edit.isHidden = true
                self.btn_back.isHidden = true
                self.btn_back.setImage(UIImage(named: ""), for: .normal)
                self.btn_backHeight.constant = 0.0
                self.btn_editHeight.constant  = 0.0
                self.btn_Edit.tag = 1
                self.handleBottomBtn()
            }
        }
#if Backapacker
        self.getProfileInfo()
        
#endif
    }
    
    private func setUpFonts(){
        self.lbl_error_VisaHeight.constant = 0.0
        self.lbl_error_SelectVisaType.isHidden = true
        lbl_error_SelectVisaType.font = FontManager.inter(.regular, size: 8.0)
        lbl_error_SelectVisaType.textColor = .red
        self.lblzHeaderVisa.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_VisaTitle.font = FontManager.inter(.regular, size: 12.0)
        self.visaVw.addShadowAllSides(radius:2)
        self.NameVw.setPlaceholder("Name")
        self.NameVw.setTitleLabel("Name")
        self.NameVw.lblErrorVisibility(val: true)
        
        self.phoneNumberVw.setPlaceholder("Phone Number")
        self.phoneNumberVw.setTitleLabel("Phone Number")
        self.phoneNumberVw.lblErrorVisibility(val: true)
        self.phoneNumberVw.txtFld.isUserInteractionEnabled = false
        self.EmailVw.setPlaceholder("Email")
        self.EmailVw.setTitleLabel("Email")
        self.EmailVw.lblErrorVisibility(val: true)
        
        self.stateVw.setPlaceholder("State")
        self.stateVw.setTitleLabel("State")
        self.stateVw.lblErrorVisibility(val: true)
        
        self.CountryVw.setPlaceholder("Country")
        self.CountryVw.setTitleLabel("Country")
        self.CountryVw.lblErrorVisibility(val: true)
        self.CountryVw.txtFld.isUserInteractionEnabled = false
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
            self.isComeFromUpdate = true
        }else{
            self.btn_Edit.tag = 0
            self.isComeFromUpdate = false
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
        // Visa type validation
        let isVisaTypeValid: Bool
        if self.lbl_VisaTitle.text == "Select Visa Type" {
            self.lbl_error_SelectVisaType.isHidden = false
            self.lbl_error_VisaHeight.constant = 20.0
            isVisaTypeValid = false
        } else {
            self.lbl_error_SelectVisaType.isHidden = true
            self.lbl_error_VisaHeight.constant = 0.0
            isVisaTypeValid = true
        }
        if isNameValid && isEmailValid && isPhoneValid && isCountryValid && isStateValid && isAreaValid && isVisaTypeValid{
            if isComeFromUpdate == true{
                let name = NameVw.txtFld.text!
                let email = EmailVw.txtFld.text!
                let state = stateVw.txtFld.text!
                let area = AreaVW.txtFld.text!
                let visaType = self.lbl_VisaTitle.text!
                self.updateProfileInfo(name: name, email: email, state: state, area: area, visaType: visaType)
            }
        } else {
           
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
        if self.lbl_VisaTitle.text == "Select Visa Type" {
            self.lbl_error_SelectVisaType.isHidden = false
            self.lbl_error_VisaHeight.constant = 20.0
        } else {
            self.lbl_error_SelectVisaType.isHidden = true
            self.lbl_error_VisaHeight.constant = 0.0
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
extension AccountDetailVC {
    func getProfileInfo(isComeFromUpdate:Bool = false) {
            LoaderManager.shared.show()
            
            profileVm.getBackPackerProfile(isComeFromUpdate: isComeFromUpdate) { [weak self] (success: Bool, result: UserProfileResponse?, statusCode: Int?) in
                guard let self = self else { return }
                
                guard let statusCode = statusCode else {
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                    return
                }
                
                let httpStatus = HTTPStatusCode(rawValue: statusCode)
                
                DispatchQueue.main.async {
                    LoaderManager.shared.hide()
                    
                    switch httpStatus {
                    case .ok, .created:
                        if success, let profileData = result?.data {
                            print("User Profile data fetched result:", profileData)
                            self.setProfileData(profileData)
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getProfileInfo() // Retry on token refresh success
                            } else {
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Session expired. Please log in again.")
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                }
            }
        }
    
    func setProfileData(_ data: UserProfileData){
        NameVw.txtFld.text = data.name.isEmpty ? nil : data.name
        EmailVw.txtFld.text = data.email.isEmpty ? nil : data.email
        CountryVw.txtFld.text = data.countryName.isEmpty ? nil : data.countryName

        // Phone Number with optional country code
        if data.mobileNumber.isEmpty {
            phoneNumberVw.txtFld.text = nil
        } else {
            if data.countryCode.isEmpty {
                phoneNumberVw.txtFld.text = data.mobileNumber
            } else {
                phoneNumberVw.txtFld.text = "\(data.countryCode) \(data.mobileNumber)"
            }
        }

        stateVw.txtFld.text = data.state.isEmpty ? nil : data.state
        AreaVW.txtFld.text = data.area.isEmpty ? nil : data.area

        lbl_VisaTitle.text = data.visaType.isEmpty ? "Select Visa Type" : data.visaType

    }
    
    func updateProfileInfo(name: String, email: String, state: String, area: String, visaType: String) {
        
        profileVm.updateBackPackerProfile(email: email, name: name, state: state, area: area, visaType: visaType, notificationStatus: false) { [weak self] (success: Bool, result: UpdateProfileResponse?, statusCode: Int?) in
            guard let self = self else { return }
            
            guard let statusCode = statusCode else {
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                return
            }
            
            let httpStatus = HTTPStatusCode(rawValue: statusCode)
            
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                switch httpStatus {
                case .ok, .created:
                    if success, let profileData = result?.data {
                        print("User Profile data fetched result:", profileData)
                        AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Profile updated successfully"){
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.updateProfileInfo(name: name, email: email, state: state, area: area, visaType: visaType)
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Session expired. Please log in again.")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                }
            }
        }
    }
}
