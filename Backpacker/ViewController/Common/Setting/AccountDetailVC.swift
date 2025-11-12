//
//  AccountDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit
protocol CommonDetailChildDelegate: AnyObject {
    func enableEditing(_ isEnabled: Bool)
}

class AccountDetailVC: UIViewController {
    @IBOutlet weak var EmailVw: CommonTxtFldLblVw!
    
    @IBOutlet weak var stackVw_VisaDateHeight: NSLayoutConstraint!
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
        "Spouse/Partner Visa",
        "Permanent Residency",
        "Investor Visa"
    ]
    var DOBPicker: UIDatePicker?
    @IBOutlet weak var top_HeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var lblzHeaderVisa: UILabel!
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_editHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_backHeight: NSLayoutConstraint!
    var isComeFromUpdate : Bool = false
  
    @IBOutlet weak var lbl_strtDate: UILabel!
    
    @IBOutlet weak var lbl_expDate: UILabel!
    
    @IBOutlet weak var vw_EndDate: UIView!
    @IBOutlet weak var Vw_strtdate: UIView!
    
    @IBOutlet weak var Vw_DobMini: UIView!
    @IBOutlet weak var lbl_dob: UILabel!
    @IBOutlet weak var lbl_avlDob: UILabel!
    @IBOutlet weak var lbl_dobError: UILabel!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var lbl_errExpDate: UILabel!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var lbl_errStrtDate: UILabel!
    
    private var startDatePicker: UIDatePicker?
      private var endDatePicker: UIDatePicker?
    
    var startDateCovertedVal : String?
    var endDateConvertedVal : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_dobError.isHidden = true
        self.lbl_dobError.textColor = .red
        self.lbl_avlDob.textColor = UIColor(named: "subTitleColor")
        self.lbl_dobError.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_dob.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_avlDob.font = FontManager.inter(.regular, size: 12.0)
        self.Vw_DobMini.addShadowAllSides(radius: 2.0)
        
        
        self.setUpButtons()
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.setUpFonts()
        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw_Visa.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw_Visa.delegate = self
        self.tblVw_Visa.dataSource = self
        self.btn_Edit.tag = 0
        handleBottomBtn()
        self.setupPicker()
        //MARK: - Unhide for when show Company Detail VC
#if BackpackerHire
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
                self.handleBottomBtn()
                self.top_HeaderHeight.constant = 0.0
               
            }
        }
#endif
       
        self.getProfileInfo()
#if BackpackerHire
        stackVw_VisaDateHeight.constant = 0.0
        
        #else
        stackVw_VisaDateHeight.constant = 85.0
        
#endif
    }
    
    private func setUpFonts(){
        self.lbl_strtDate.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_expDate.font = FontManager.inter(.medium, size: 14.0)
        
        self.startDateField.font = FontManager.inter(.regular, size: 12.0)
        self.endDateField.font = FontManager.inter(.regular, size: 12.0)
        
        self.Vw_strtdate.layer.cornerRadius = 10
        self.vw_EndDate.layer.cornerRadius = 10
        self.Vw_strtdate.addShadowAllSides(radius: 2.0)
        self.vw_EndDate.addShadowAllSides(radius: 2.0)
        
        self.lbl_errExpDate.textColor = .red
        self.lbl_errStrtDate.textColor = .red
        self.lbl_errExpDate.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_errStrtDate.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_errExpDate.isHidden = true
        self.lbl_errStrtDate.isHidden = true
        
        self.startDateField.isUserInteractionEnabled = false
        self.endDateField.isUserInteractionEnabled = false
        
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
        self.NameVw.txtFld.isUserInteractionEnabled = false
        self.phoneNumberVw.setPlaceholder("Phone Number")
        self.phoneNumberVw.setTitleLabel("Phone Number")
        self.phoneNumberVw.lblErrorVisibility(val: true)
        self.phoneNumberVw.txtFld.isUserInteractionEnabled = false
        self.EmailVw.setPlaceholder("Email")
        self.EmailVw.setTitleLabel("Email")
        self.EmailVw.lblErrorVisibility(val: true)
        self.EmailVw.txtFld.isUserInteractionEnabled = false
        self.stateVw.setPlaceholder("State")
        self.stateVw.setTitleLabel("State")
        self.stateVw.lblErrorVisibility(val: true)
        self.stateVw.txtFld.isUserInteractionEnabled = false
        self.CountryVw.setPlaceholder("Country")
        self.CountryVw.setTitleLabel("Country")
        self.CountryVw.lblErrorVisibility(val: true)
        self.CountryVw.txtFld.isUserInteractionEnabled = false
        self.AreaVW.setPlaceholder("Area")
        self.AreaVW.setTitleLabel("Area")
        self.AreaVW.lblErrorVisibility(val: true)
        self.AreaVW.txtFld.isUserInteractionEnabled = false
        self.AreaVW.txtFld.keyboardType = .default
    }
    private func setupPicker(){
        startDatePicker = UIDatePicker()
              startDatePicker?.datePickerMode = .date
              if #available(iOS 14.0, *) {
                  startDatePicker?.preferredDatePickerStyle = .wheels
              }
              startDatePicker?.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
              startDateField.inputView = startDatePicker
              
              // Setup End Date Picker
              endDatePicker = UIDatePicker()
              endDatePicker?.datePickerMode = .date
              if #available(iOS 14.0, *) {
                  endDatePicker?.preferredDatePickerStyle = .wheels
              }
              endDatePicker?.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
              endDateField.inputView = endDatePicker
              
              // Optional: Add toolbar with Done button
              let toolbar = UIToolbar()
              toolbar.sizeToFit()
              let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
              toolbar.setItems([doneButton], animated: true)
              startDateField.inputAccessoryView = toolbar
              endDateField.inputAccessoryView = toolbar
    }
    @objc func startDateChanged() {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           startDateField.text = formatter.string(from: startDatePicker?.date ?? Date())
        
        guard let date = startDatePicker?.date else { return }

            let formatter2 = ISO8601DateFormatter()
            formatter2.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            formatter2.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        self.startDateCovertedVal = formatter2.string(from: date)
        self.lbl_errStrtDate.isHidden = true
       }
       
       @objc func endDateChanged() {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           endDateField.text = formatter.string(from: endDatePicker?.date ?? Date())
           
           
           guard let date = endDatePicker?.date else { return }

               let formatter2 = ISO8601DateFormatter()
               formatter2.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
               formatter2.timeZone = TimeZone(secondsFromGMT: 0) // UTC
           self.endDateConvertedVal = formatter2.string(from: date)
           self.lbl_errExpDate.isHidden = true
       }
       
       @objc func donePressed() {
           self.view.endEditing(true)
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
        if btn_Edit.tag == 1 {
            if btn_drpdwn.tag == 0{
                self.btn_drpdwn.tag = 1
            }else{
                self.btn_drpdwn.tag = 0
            }
            self.manageHeightOfTable()
        }
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
    func showDatePicker() {
        let alert = UIAlertController(title: "Select DOB", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
                
                DOBPicker = UIDatePicker(frame: CGRect(x: 0, y: 20, width: alert.view.bounds.width - 20, height: 200))
                DOBPicker?.datePickerMode = .date
                DOBPicker?.maximumDate = Date()
                if #available(iOS 14.0, *) {
                    DOBPicker?.preferredDatePickerStyle = .wheels
                }
                
                alert.view.addSubview(DOBPicker!)
                
                let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    if let date = self.DOBPicker?.date {
                        self.lbl_avlDob.text = formatter.string(from: date)
                        self.lbl_dobError.isHidden = true
                     
                        self.lbl_avlDob.textColor = UIColor(named: "blackColor")
                    }
                }
                alert.addAction(doneAction)
                
                present(alert, animated: true, completion: nil)
        }
    @IBAction func action_chosseDob(_ sender: Any) {
        self.showDatePicker()
    }
    @IBAction func action_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    func isEditap(){
#if BackpackerHire
        if isComeFromUpdate == true{
            DispatchQueue.main.async {
                self.NameVw.txtFld.isUserInteractionEnabled = true
                self.EmailVw.txtFld.isUserInteractionEnabled = true
                self.stateVw.txtFld.isUserInteractionEnabled = true
                self.AreaVW.txtFld.isUserInteractionEnabled = true
            }
            self.stckBotmHeight.constant = 50.0
        }else{
            self.isComeFromUpdate = false
            self.stckBotmHeight.constant = 0.0
        }
        #endif
    }
    @IBAction func actionEdit(_ sender: Any) {
        if self.btn_Edit.tag == 0{
            self.btn_Edit.tag = 1
            self.isComeFromUpdate = true
            DispatchQueue.main.async {
                self.NameVw.txtFld.isUserInteractionEnabled = true
                self.EmailVw.txtFld.isUserInteractionEnabled = true
                self.stateVw.txtFld.isUserInteractionEnabled = true
                self.AreaVW.txtFld.isUserInteractionEnabled = true
                self.startDateField.isUserInteractionEnabled  = true
                self.endDateField.isUserInteractionEnabled  = true
            }
        }else{
            self.btn_Edit.tag = 0
            self.isComeFromUpdate = false
            self.NameVw.txtFld.isUserInteractionEnabled = false
            self.EmailVw.txtFld.isUserInteractionEnabled = false
            self.stateVw.txtFld.isUserInteractionEnabled = false
            self.AreaVW.txtFld.isUserInteractionEnabled = false
            self.startDateField.isUserInteractionEnabled  = false
            self.endDateField.isUserInteractionEnabled  = false
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
        var hasError : Bool = false
#if BackpackerHire
        isVisaTypeValid = true
        hasError = false
        #else
        if self.lbl_VisaTitle.text == "Select Visa Type" {
            self.lbl_error_SelectVisaType.isHidden = false
            self.lbl_error_VisaHeight.constant = 20.0
            isVisaTypeValid = false
        } else {
            self.lbl_error_SelectVisaType.isHidden = true
            self.lbl_error_VisaHeight.constant = 0.0
            isVisaTypeValid = true
        }
        
        // Start date validation
        if startDateField.text?.isEmpty == true {
            lbl_errStrtDate.isHidden = false
            hasError = true
        }

        // End date validation
        if endDateField.text?.isEmpty == true {
            lbl_errExpDate.isHidden = false
            hasError = true
        }

        // Check if end date is after start date
        if let startText = startDateField.text, let endText = endDateField.text,
           let formatter = DateFormatter() as DateFormatter?,
           let startDate = formatter.date(from: startText),
           let endDate = formatter.date(from: endText) {
            
            formatter.dateFormat = "MM/dd/yyyy" // make sure this matches your text field format
            if endDate < startDate {
                lbl_errExpDate.text = "End date must be after start date"
                lbl_errExpDate.isHidden = false
                hasError = true
            }
        }
        
        
#endif
       
       
        if isNameValid && isEmailValid && isPhoneValid && isCountryValid && isStateValid && isAreaValid && isVisaTypeValid && !hasError {
            if isComeFromUpdate == true{
                let name = NameVw.txtFld.text!
                let email = EmailVw.txtFld.text!
                let state = stateVw.txtFld.text!
                let area = AreaVW.txtFld.text!
#if BackpackerHire
                let visaType = ""
#else
                let visaType = self.lbl_VisaTitle.text!
#endif
                AlertManager.showConfirmationAlert(on: self, title: "Alert!", message: "Do you really want to update your profile information?") {
                    self.updateProfileInfo(name: name, email: email, state: state, area: area, visaType: visaType,startDate: self.startDateCovertedVal ?? "",endDate: self.endDateConvertedVal ?? "")
                }
                
               
            }
        } else {
           
        }

    }
    
    
    @IBAction func action_Cancelk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AccountDetailVC: CommonDetailChildDelegate {
    func enableEditing(_ isEnabled: Bool) {
            // Enable or disable editing UI
            if isEnabled {
                self.isComeFromUpdate = true
               
            } else {
                self.isComeFromUpdate = false
            }
        isEditap()
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
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
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
        
        if let startDate = data.startDate {
            self.startDateCovertedVal = startDate
            let isoString =  self.startDateCovertedVal ?? ""
            if let formatted = formatISODate(isoString) {
                print(formatted) // Output: "10 Oct 2013"
                self.startDateField.text = formatted
            } else {
                print("Invalid date")
            }

        }
        if let expDate = data.endDate {
            self.endDateConvertedVal = expDate
            let isoString =  self.endDateConvertedVal ?? ""
            if let formatted = formatISODate(isoString) {
                print(formatted) // Output: "10 Oct 2013"
                self.endDateField.text = formatted
            } else {
                print("Invalid date")
            }
        }
        
        if let isoDate = data.dob {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // handles .000Z too

            if let date = isoFormatter.date(from: isoDate) ?? ISO8601DateFormatter().date(from: isoDate.replacingOccurrences(of: ".000Z", with: "Z")) {
                
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "MM/dd/yyyy"
                displayFormatter.timeZone = .current // converts to local
                
                let formattedDate = displayFormatter.string(from: date)
                lbl_avlDob.text = formattedDate
                lbl_dobError.isHidden = true
                self.lbl_avlDob.textColor = UIColor(named: "blackColor")
                
                print("✅ Formatted DOB:", formattedDate)
                
            } else {
                print("❌ Could not parse ISO date:", isoDate)
                lbl_dobError.isHidden = false
            }
        } else {
            lbl_dobError.isHidden = false
        }

       
    }
    func formatISODate(_ isoString: String) -> String? {
        // 1. Convert ISO string to Date
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = isoFormatter.date(from: isoString) else {
            return nil // Return nil if parsing fails
        }
        
        // 2. Format Date to desired string
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" // e.g., 10 Oct 2013
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: date)
    }

    func updateProfileInfo(name: String, email: String, state: String, area: String, visaType: String,startDate: String,endDate: String) {
        LoaderManager.shared.show()
        profileVm.updateBackPackerProfile(email: email, name: name, state: state, area: area, visaType: visaType, notificationStatus: false,startDate: startDate,endDate: endDate,dob: self.lbl_avlDob.text ?? "") { [weak self] (success: Bool, result: UpdateProfileResponse?, statusCode: Int?) in
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
                            self.updateProfileInfo(name: name, email: email, state: state, area: area, visaType: visaType,startDate: startDate,endDate: endDate)
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Session expired. Please log in again.")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                }
            }
        }
    }
}
