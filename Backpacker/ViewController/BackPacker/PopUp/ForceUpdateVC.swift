//
//  ForceUpdateVC.swift
//  Backpacker
//
//  Created by Mobile on 08/08/25.
//

import UIKit

class ForceUpdateVC: UIViewController {
    @IBOutlet weak var date_stackHeight: NSLayoutConstraint!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var Vw_ExpiryDate: UIView!
    @IBOutlet weak var lbl_expiryDate: UILabel!
    @IBOutlet weak var lbl_Val_StatrDate: UILabel!
    @IBOutlet weak var ve_ValsatrtDate: UIView!
    @IBOutlet weak var lbl_startDate: UILabel!
    @IBOutlet weak var Vw_LblExpiryDate: UIView!
    @IBOutlet weak var Vw_SatartDate: UIView!
    @IBOutlet weak var DateStackVw: UIStackView!
    @IBOutlet weak var lbl_error_VisaHeight: NSLayoutConstraint!
    @IBOutlet weak var main_Vw: UIView!
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var logo_width: NSLayoutConstraint!
    @IBOutlet weak var logo_height: NSLayoutConstraint!
    @IBOutlet weak var mainDOBVw: UIView!
    @IBOutlet weak var imgDrpDwon: UIImageView!
    @IBOutlet weak var lbl_error_endDate: UILabel!
    @IBOutlet weak var lbl_error_startDate: UILabel!
    @IBOutlet weak var lbl_Val_ExpiryDate: UILabel!
    @IBOutlet weak var lbl_error_SelectVisaType: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vw_Scroll: UIView!
    @IBOutlet weak var lbl_Header: UILabel!
    
    @IBOutlet weak var main_visaTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_drpdwn: UIButton!
    @IBOutlet weak var tbl_height: NSLayoutConstraint!
    @IBOutlet weak var bg_tableVw: UIView!
    @IBOutlet weak var Vw_VisaType: UIView!
    @IBOutlet weak var email_Vw: CommonTxtFldLblVw!
    
    @IBOutlet weak var vWHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_Val_VisaType: UILabel!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var lbl_dobError: UILabel!
    @IBOutlet weak var lbl_main_visaType: UILabel!
    @IBOutlet weak var name_Vw: CommonTxtFldLblVw!
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
    var scrollHight : CGFloat?
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    
    var startDateCovertedVal : String?
    @IBOutlet weak var Vw_DobMini: UIView!
    var endDateConvertedVal : String?
    
    @IBOutlet weak var lbl_dob: UILabel!
    var DOBPicker: UIDatePicker?
    @IBOutlet weak var lbl_avlDob: UILabel!
    
    @IBOutlet weak var btn_frm: UIButton!
    @IBOutlet weak var btn_regional: UIButton!
    
    @IBOutlet weak var imgVw_frm: UIImageView!
    @IBOutlet weak var img_reginal: UIImageView!
    
    @IBOutlet weak var lbl_frmWrk: UILabel!
    @IBOutlet weak var lbl_regional: UILabel!
    
    @IBOutlet weak var lbl_error_work: UILabel!
    @IBOutlet weak var farmViwStackHeight: NSLayoutConstraint!
    var selectedWork: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_regional.textColor = UIColor(named: "subTitleColor")
        self.lbl_frmWrk.textColor = UIColor(named: "subTitleColor")
        self.lbl_frmWrk.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_regional.font = FontManager.inter(.medium, size: 14.0)
        self.setUpUI()
        self.lbl_dobError.isHidden = true
        self.lbl_dobError.textColor = .red
        self.lbl_avlDob.textColor = UIColor(named: "subTitleColor")
        self.lbl_dobError.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_dob.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_avlDob.font = FontManager.inter(.regular, size: 12.0)
        self.Vw_DobMini.addShadowAllSides(radius: 2.0)
        // Do any additional setup after loading the view.
        self.HideShowReginoalWorkFarmView()
#if Backapacker
        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.btn_drpdwn.tag = 0
        self.manageHeightOfTable()
        self.scrollHight = self.mainScrollView.contentSize.height
        self.setUpUIForDate()
        self.date_stackHeight.constant = 85.0
        self.main_visaTypeHeight.constant = 70.0
        self.imgDrpDwon.isHidden = false
        self.lbl_error_SelectVisaType.isHidden = false
        self.logo_width.constant = 55.0
        self.logo_height.constant = 55.0
#else
        self.img_logo.image = UIImage(named: "Logo1")
        self.logo_width.constant = 65.0
        self.logo_height.constant = 65.0
        self.date_stackHeight.constant = 0.0
        self.tbl_height.constant = 0
        self.vWHeightContraint.constant = 0
        self.main_visaTypeHeight.constant = 0.0
        self.imgDrpDwon.isHidden = true
        self.lbl_error_VisaHeight.constant = 0.0
        self.lbl_error_SelectVisaType.isHidden = true
        self.lbl_error_work.isHidden = true
#endif
    }
    private func setUpUIForDate(){
        self.lbl_error_startDate.isHidden = true
        self.lbl_error_endDate.isHidden = true
        self.lbl_error_work.isHidden = true
        self.lbl_error_work.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_error_startDate.font = FontManager.inter(.regular, size: 8.0)
        lbl_error_work.textColor = .red
        self.lbl_error_endDate.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_error_startDate.textColor = .red
        self.lbl_error_endDate.textColor = .red
        self.lbl_error_VisaHeight.constant = 10.0
        self.lbl_startDate.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_expiryDate.font = FontManager.inter(.medium, size: 14.0)
        self.startDateField.font = FontManager.inter(.regular, size: 12.0)
        
        
        
        self.endDateField.font = FontManager.inter(.regular, size: 12.0)
        self.Vw_LblExpiryDate.layer.cornerRadius = 10.0
        self.Vw_LblExpiryDate.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.Vw_LblExpiryDate.layer.borderWidth = 1.0
        
        self.ve_ValsatrtDate.layer.cornerRadius = 10.0
        self.ve_ValsatrtDate.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.ve_ValsatrtDate.layer.borderWidth = 1.0
        self.setupPicker()
    }
    private func HideShowReginoalWorkFarmView(){
#if BackpackerHire
        self.farmViwStackHeight.constant = 0.0
        hideShowFarmRegional(true)
#else
        
        self.farmViwStackHeight.constant = 40.0
        hideShowFarmRegional(false)
#endif
        
    }
    private func hideShowFarmRegional(_ shouldHide: Bool) {
        
        btn_frm.isHidden = shouldHide
        btn_regional.isHidden = shouldHide
        
        imgVw_frm.isHidden = shouldHide
        img_reginal.isHidden = shouldHide
        
        lbl_frmWrk.isHidden = shouldHide
        lbl_regional.isHidden = shouldHide
    }
    func setUpUI(){
        if lbl_Val_VisaType.text == "Select Visa Type" {
            self.lbl_Val_VisaType.textColor = UIColor(named: "subTitleColor")
        }else{
            self.lbl_Val_VisaType.textColor = UIColor(named: "blackColor")
        }
        self.lbl_error_SelectVisaType.font = FontManager.inter(.regular, size: 8.0)
        self.lbl_error_SelectVisaType.textColor = .red
        self.Vw_VisaType.layer.cornerRadius = 10.0
        self.Vw_VisaType.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.Vw_VisaType.layer.borderWidth = 1.0
        self.lbl_main_visaType.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Val_VisaType.font = FontManager.inter(.regular, size: 12.0)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // self.vw_Scroll.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        applyGradientButtonStyle(to: btn_Save)
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_Header.font = FontManager.inter(.semiBold, size: 16.0)
        self.main_Vw.layer.cornerRadius = 10.0
        self.main_Vw.addShadowAllSides(radius: 2.0)
        
        self.name_Vw.setPlaceholder("Name")
        self.name_Vw.setTitleLabel("Name")
        self.name_Vw.lblErrorVisibility(val: true)
        
        self.email_Vw.setPlaceholder("Email")
        self.email_Vw.setTitleLabel("Email")
        self.email_Vw.lblErrorVisibility(val: true)
        
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
        self.lbl_error_startDate.isHidden = true
    }
    
    @IBAction func action_chosseDOB(_ sender: Any) {
        self.showDatePicker()
        
        
    }
    @IBAction func action_farm(_ sender: Any) {
        self.btn_regional.tag = 0
        if self.btn_frm.tag == 0 {
            self.btn_frm.tag = 1
        }else{
            self.btn_frm.tag = 0
        }
        self.updateFrmReginalBtn()
    }
    @IBAction func action_regional(_ sender: Any) {
        self.btn_frm.tag = 0
        if self.btn_regional.tag == 0 {
            self.btn_regional.tag = 1
        }else{
            self.btn_regional.tag = 0
        }
        self.updateFrmReginalBtn()
    }
    private func updateFrmReginalBtn(){
        if self.btn_regional.tag == 1 {
            self.img_reginal.image = UIImage(named: "Checkbox2")
            self.imgVw_frm.image = UIImage(named: "Checkbox")
            self.lbl_regional.textColor = .black
            self.lbl_frmWrk.textColor = UIColor(named: "subTitleColor")
            self.selectedWork = "Regional Work"
        }else{
            self.img_reginal.image = UIImage(named: "Checkbox")
            self.imgVw_frm.image = UIImage(named: "Checkbox2")
            self.lbl_frmWrk.textColor = .black
            self.lbl_regional.textColor = UIColor(named: "subTitleColor")
            self.selectedWork = "Farm Work"
        }
        self.lbl_error_work.isHidden = true
    }
    func showDatePicker() {
        let alert = UIAlertController(title: "Select DOB",
                                      message: "\n\n\n\n\n\n\n\n",
                                      preferredStyle: .actionSheet)
        
        DOBPicker = UIDatePicker(frame: CGRect(x: 0, y: 20,
                                               width: alert.view.bounds.width - 20,
                                               height: 200))
        DOBPicker?.datePickerMode = .date
        DOBPicker?.maximumDate = Date()
        
        if #available(iOS 14.0, *) {
            DOBPicker?.preferredDatePickerStyle = .wheels
        }
        
        alert.view.addSubview(DOBPicker!)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd" //"dd/MM/yyyy"
            
            if let date = self.DOBPicker?.date {
                self.lbl_avlDob.text = formatter.string(from: date)
                self.lbl_dobError.isHidden = true
                self.lbl_avlDob.textColor = UIColor(named: "blackColor")
            }
        }
        
        alert.addAction(doneAction)
        
        // 🟢 THIS MAKES IT APPEAR AT BOTTOM ON iPAD
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.maxY - 10,   // bottom of screen
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []   // no arrow → appears like bottom sheet
        }
        
        present(alert, animated: true)
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
        self.lbl_error_endDate.isHidden = true
    }
    
    @objc func donePressed() {
        
        if startDateField.isFirstResponder == true{
            guard let date = startDatePicker?.date else { return }
            
            // 1️⃣ Visible formatted date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            startDateField.text = formatter.string(from: date)
            
            // 2️⃣ ISO format for backend
            let formatter2 = ISO8601DateFormatter()
            formatter2.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            formatter2.timeZone = TimeZone(secondsFromGMT: 0)
            
            self.startDateCovertedVal = formatter2.string(from: date)
            
            self.lbl_error_startDate.isHidden = true
            
            self.view.endEditing(true)
        }else if endDateField.isFirstResponder == true {
            guard let date = endDatePicker?.date else { return }
            
            // 1️⃣ Visible formatted date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            endDateField.text = formatter.string(from: date)
            
            // 2️⃣ ISO format for backend
            let formatter2 = ISO8601DateFormatter()
            formatter2.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            formatter2.timeZone = TimeZone(secondsFromGMT: 0)
            
            self.endDateConvertedVal = formatter2.string(from: date)
            
            self.lbl_error_endDate.isHidden = true
            
            self.view.endEditing(true)
        }else{
            self.view.endEditing(true)
        }
        
    }
    @IBAction func action_Continue(_ sender: Any) {
        var hasError = false
        // Name & Email validation
        let isNameValid = name_Vw.validateNotEmpty(errorMessage: "Please enter your name")
        if !isNameValid { hasError = true }
        
        let isEmailValid = email_Vw.validateEmail(errorMessage: "Please enter your email")
        if lbl_avlDob.text == "DOB" || lbl_avlDob.text?.isEmpty == true {
            lbl_dobError.isHidden = false
            hasError = true
        } else {
            lbl_dobError.isHidden = true
        }
        
        if !isEmailValid { hasError = true }
#if BackpackerHire
        
        
#else
        // Visa type validation
        if lbl_Val_VisaType.text == "Select Visa Type" {
            lbl_error_VisaHeight.constant = 20
            lbl_error_SelectVisaType.text = "Please select visa type"
            hasError = true
        }
        
        // Start date validation
        if startDateField.text?.isEmpty == true {
            lbl_error_startDate.isHidden = false
            hasError = true
        }else{
            lbl_error_startDate.isHidden = true
        }
        
        // End date validation
        if endDateField.text?.isEmpty == true {
            lbl_error_endDate.isHidden = false
            hasError = true
        }else{
            lbl_error_endDate.isHidden = true
        }
        
        // Check if end date is after start date
        if let startText = startDateField.text, let endText = endDateField.text,
           let formatter = DateFormatter() as DateFormatter?,
           let startDate = formatter.date(from: startText),
           let endDate = formatter.date(from: endText) {
            
            formatter.dateFormat = "MM/dd/yyyy" // make sure this matches your text field format
            if endDate < startDate {
                lbl_error_endDate.text = "End date must be after start date"
                lbl_error_endDate.isHidden = false
                hasError = true
            }
        }
        if selectedWork == "" || selectedWork?.isEmpty == true || selectedWork == nil{
            self.lbl_error_work.isHidden = false
            hasError = true
        }else{
            self.lbl_error_work.isHidden = true
        }
        
#endif
            // If no errors, update profile
            if !hasError {
                updateProfileInfo(
                    name: name_Vw.txtFld.text ?? "",
                    email: email_Vw.txtFld.text ?? "",
                    state: "",
                    area: "",
                    visaType: lbl_Val_VisaType.text ?? "",
                    statrtDate: self.startDateCovertedVal ?? "",
                    endDate: self.endDateConvertedVal ?? "", dob: lbl_avlDob.text ?? ""
                )
            }
        
    }
    
    @IBAction func action_VisaDrodwn(_ sender: Any) {
        if btn_drpdwn.tag == 0{
            self.btn_drpdwn.tag = 1
        }else{
            self.btn_drpdwn.tag = 0
        }
        self.manageHeightOfTable()
    }
}
extension ForceUpdateVC {
    //MARK: - UPdate Profile Api Call
    func updateProfileInfo(name: String, email: String, state: String, area: String, visaType: String,statrtDate: String,endDate: String,dob:String) {
        LoaderManager.shared.show()
        profileVm.updateBackPackerProfile(email: email, name: name, state: "", area: "", visaType: visaType, notificationStatus: false,startDate: statrtDate,endDate: endDate,dob: dob) { [weak self] (success: Bool, result: UpdateProfileResponse?, statusCode: Int?) in
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
                            self.dismiss(animated: true)
                        }
                        
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.updateProfileInfo(name: name, email: email, state: state, area: area, visaType: visaType,statrtDate: self.startDateCovertedVal ?? "",endDate:  self.endDateConvertedVal ?? "", dob: dob)
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




extension ForceUpdateVC : UITableViewDelegate,UITableViewDataSource{
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
        self.lbl_Val_VisaType.text = selectedIssue
        self.btn_drpdwn.tag = 0
        self.manageHeightOfTable()
        if self.lbl_Val_VisaType.text == "Select Visa Type" {
            self.lbl_error_SelectVisaType.isHidden = false
            self.lbl_error_VisaHeight.constant = 20.0
        } else {
            self.lbl_error_SelectVisaType.isHidden = true
            self.lbl_error_VisaHeight.constant = 0.0
        }
        if lbl_Val_VisaType.text == "Select Visa Type" {
            self.lbl_Val_VisaType.textColor = UIColor(named: "subTitleColor")
        }else{
            self.lbl_Val_VisaType.textColor = UIColor(named: "blackColor")
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func manageHeightOfTable(){
        if self.btn_drpdwn.tag == 0{
            self.tbl_height.constant = 0.0
            self.vWHeightContraint.constant = 0.0
            self.bg_tableVw.addShadowAllSides(radius: 0)
            self.mainScrollView.contentSize.height =  self.scrollHight ?? 700
        }else{
            self.bg_tableVw.addShadowAllSides(radius: 1.5)
            self.tbl_height.constant = CGFloat((visaTypes.count * 50)) //176.0
            self.vWHeightContraint.constant = CGFloat((visaTypes.count * 50)) + 14 //190.0
            self.mainScrollView.contentSize.height =  (self.scrollHight ?? 700) +   self.vWHeightContraint.constant
        }
    }
}
