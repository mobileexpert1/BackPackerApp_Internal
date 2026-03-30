//
//  EmailVC.swift
//  Backpacker
//
//  Created by Mobile on 25/03/26.
//

import UIKit
import CountryPickerView
class EmailVC: UIViewController {
    
    @IBOutlet weak var img_logo_bottom: NSLayoutConstraint! //50
    @IBOutlet weak var img_Logo_width: NSLayoutConstraint!//120
    @IBOutlet weak var img_logo_Height: NSLayoutConstraint!//120
    @IBOutlet weak var logo_Img: UIImageView!
    //Outlet
    @IBOutlet weak var picker_Vw: CountryPickerView!
    @IBOutlet weak var header_ImgTop: NSLayoutConstraint!
   @IBOutlet weak var btn_term_Topconstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_temsandCondition: UILabel!
    @IBOutlet weak var btn_trmcondition: UIButton!
    @IBOutlet weak var vwTxtFld: UIView!
    @IBOutlet weak var lblLogIn: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btn_Continue: UIButton!
    @IBOutlet weak var lbl_Error: UILabel!
    @IBOutlet weak var txtFld_PhoneNumber: UITextField!
    //Variables
    @IBOutlet weak var lbl_EntrNumber: UILabel!
    
    @IBOutlet weak var txtFld_Email: UITextField!
    
    @IBOutlet weak var segment_vw: UIView!
    
    @IBOutlet weak var btn_email: UIButton!
    
    @IBOutlet weak var btn_PhoneNumber: UIButton!
    
    @IBOutlet weak var vw_EmailStack: UIView!
    
    
    @IBOutlet weak var vw_passStack: UIView!
    
    
    @IBOutlet weak var btn_countryPicker: UIButton!
    @IBOutlet weak var lbl_Header_PhneBunber: UILabel!
    
    @IBOutlet weak var lbl_errorPhneNumber: UILabel!
    @IBOutlet weak var lbl_countryCode: UILabel!
    @IBOutlet weak var img_flag: UIImageView!
    
    @IBOutlet weak var vw_TxtFldPhoneNumber: UIView!
    @IBOutlet weak var vw_Flag: UIView!
    
    var isEmailSelected : Bool = true
    var viewModel = LogInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setupRoundedBorder(for: vwTxtFld)
        self.setupRoundedBorder(for: vw_Flag)
        self.setupRoundedBorder(for: vw_TxtFldPhoneNumber)
        applyGradientButtonStyle(to: btn_Continue)
        segment_vw.layer.cornerRadius = 12
           segment_vw.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
           
           updateSegmentUI(isEmailSelected: true)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func action_PhoneNumber(_ sender: Any) {
        updateSegmentUI(isEmailSelected: false)
        
    }
    @IBAction func action_Email(_ sender: Any) {
        updateSegmentUI(isEmailSelected: true)
        
    }
    
    func updateSegmentUI(isEmailSelected: Bool) {
        
        let selectedFont = FontManager.inter(.medium, size: 14.0)
        let normalFont = FontManager.inter(.regular, size: 12.0)
        
        let selectedColor = UIColor.white
        let normalColor = UIColor.black
        
        if isEmailSelected {
            // Email Selected
            self.isEmailSelected = isEmailSelected
            btn_email.backgroundColor = UIColor(hex: "#7EB268")
            btn_email.setTitleColor(selectedColor, for: .normal)
            btn_email.setTitleColor(selectedColor, for: .selected)
            btn_email.titleLabel?.font = selectedFont
            
            btn_PhoneNumber.backgroundColor = .clear
            btn_PhoneNumber.setTitleColor(normalColor, for: .normal)
            btn_PhoneNumber.setTitleColor(normalColor, for: .selected)
            btn_PhoneNumber.titleLabel?.font = normalFont
            btn_PhoneNumber.layer.cornerRadius = 10
            btn_email.layer.cornerRadius = 10
            self.vw_passStack.isHidden = true
            self.vw_EmailStack.isHidden = false
        } else {
            // Phone Selected
            self.isEmailSelected = isEmailSelected
            btn_PhoneNumber.backgroundColor = UIColor(hex: "#7EB268")
            btn_PhoneNumber.setTitleColor(selectedColor, for: .normal)
            btn_PhoneNumber.setTitleColor(selectedColor, for: .selected)
            btn_PhoneNumber.titleLabel?.font = selectedFont
            
            btn_email.backgroundColor = .clear
            btn_email.setTitleColor(normalColor, for: .normal)
            btn_email.setTitleColor(normalColor, for: .selected)
            btn_email.titleLabel?.font = normalFont
            btn_PhoneNumber.layer.cornerRadius = 10
            btn_email.layer.cornerRadius = 10
            self.vw_passStack.isHidden = false
            self.vw_EmailStack.isHidden = true
        }
    }
    func setupRoundedBorder(for view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(named:"borderColor")?.cgColor
        view.clipsToBounds = true
    }
    private func setUI(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tapGesture.cancelsTouchesInView = false // important
          self.view.addGestureRecognizer(tapGesture)
        #if BackpackerHire
        self.header_ImgTop.constant = 20
        #else
        self.header_ImgTop.constant = 70
        #endif
        picker_Vw.delegate = self
        picker_Vw.dataSource = self
        picker_Vw.setCountryByName("India")
        picker_Vw.showCountryNameInView = false
        picker_Vw.showCountryCodeInView = false
        picker_Vw.showPhoneCodeInView = false
        picker_Vw.flagImageView.isHidden = true
        self.lbl_errorPhneNumber.isHidden = true
        txtFld_PhoneNumber.delegate = self
        txtFld_PhoneNumber.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        txtFld_PhoneNumber.keyboardType = .phonePad
        txtFld_Email.delegate = self
        txtFld_Email.addTarget(self, action: #selector(phoneNumberTextChanged), for: .editingChanged)
        self.btn_term_Topconstraint.constant = 0.0
        self.btn_trmcondition.tag = 0
        self.lbl_temsandCondition.textColor = UIColor(named: "subTitleColor")
        self.btn_trmcondition.setImage(UIImage(named: "Checkbox"), for: .normal)
        self.lbl_temsandCondition.font = FontManager.inter(.regular, size: 10.0)
        self.lblLogIn.font = FontManager.inter(.regular, size: 26.0)
        self.lblSubTitle.font = FontManager.inter(.regular, size: 14.0)
        self.txtFld_PhoneNumber.font = FontManager.inter(.regular, size: 17.0)
        self.lbl_EntrNumber.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Header_PhneBunber.font = FontManager.inter(.medium, size: 14.0)
        self.txtFld_Email.placeholder = Constants.Placeholder.email
        self.txtFld_PhoneNumber.placeholder = Constants.Placeholder.phoneNumber
        self.txtFld_PhoneNumber.font = FontManager.inter(.regular, size: 14.0)
        self.txtFld_Email.font = FontManager.inter(.regular, size: 14.0)
        self.txtFld_Email.keyboardType = .emailAddress
        self.btn_Continue.layer.cornerRadius = 10.0
        self.lbl_Error.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_Error.isHidden = true
        self.lbl_errorPhneNumber.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_errorPhneNumber.isHidden = true
        self.btn_Continue.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        txtFld_PhoneNumber.returnKeyType = .done
        self.lbl_temsandCondition.isUserInteractionEnabled = true
        self .setupTermsLabel()
        self.lbl_countryCode.text = picker_Vw.selectedCountry.phoneCode
        self.lbl_countryCode.font = FontManager.inter(.regular, size: 14.0)
        self.img_flag.image = picker_Vw.selectedCountry.flag
        btn_countryPicker.addTarget(self, action: #selector(selectCountryAction(_:)), for: .touchUpInside)
#if BackpackerHire
        self.logo_Img.image = UIImage(named: "Logo2")
        self.img_logo_bottom.constant = 0
        self.img_Logo_width.constant = 180
        self.img_logo_Height.constant = 180
        #else
        self.logo_Img.image = UIImage(named: "launchBP")
        self.img_logo_bottom.constant = 50
        self.img_Logo_width.constant = 120
        self.img_logo_Height.constant = 120
#endif
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @objc func emailTextChanged(_ textField: UITextField) {
       
    }
    @objc func phoneNumberTextChanged(_ textField: UITextField) {
        
        
    }
    @objc func selectCountryAction(_ sender: Any) {
        picker_Vw.showCountriesList(from: self)
        
    }
    private func setupTermsLabel() {
        let text = "I have read and agree to the Privacy Policy and Terms & Conditions"
        
        let attributedText = NSMutableAttributedString(string: text)
        let fullRange = (text as NSString)
        
        // Define the tap targets
        let privacyRange = fullRange.range(of: "Privacy Policy")
        let termsRange = fullRange.range(of: "Terms & Conditions")
        let eulaRange = fullRange.range(of: "EULA")
        
        // Apply link styling (blue + underline)
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "themeColor"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        attributedText.addAttributes(linkAttributes, range: privacyRange)
        attributedText.addAttributes(linkAttributes, range: termsRange)
        attributedText.addAttributes(linkAttributes, range: eulaRange)
        
        // Assign to label
        lbl_temsandCondition.attributedText = attributedText
        lbl_temsandCondition.numberOfLines = 0
        lbl_temsandCondition.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:)))
        lbl_temsandCondition.addGestureRecognizer(tapGesture)
    }
    @objc private func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else { return }
        
        // Prepare text layout manager
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Tap location
        var tapLocation = gesture.location(in: label)
        
        // Compute used rect (actual text area)
        let usedRect = layoutManager.usedRect(for: textContainer)
        // Adjust tap point for top/left alignment (UILabel typically centers vertically)
        tapLocation.y -= (label.bounds.size.height - usedRect.size.height) / 10
        
        // Get character index at tap
        let index = layoutManager.characterIndex(
            for: tapLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        let text = attributedText.string
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        //    let eulaRange = (text as NSString).range(of: "EULA")
        
        // Match and open appropriate URL
        if NSLocationInRange(index, privacyRange) {
#if BackpackerHire
            openURL("https://backpacker.csdevhub.com/privacy-policy/employer")
#else
            openURL("https://backpacker.csdevhub.com/privacy-policy/backpacker")
#endif
        } else if NSLocationInRange(index, termsRange) {
#if BackpackerHire
            openURL("https://backpacker.csdevhub.com/terms-condition/employer")
#else
            openURL("https://backpacker.csdevhub.com/terms-condition/backpacker")
#endif
        }
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    /// Helper: Detect which text index was tapped
    private func characterRange(at point: CGPoint, in label: UILabel) -> NSRange? {
        guard let attributedText = label.attributedText else { return nil }
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let location = CGPoint(x: point.x, y: point.y)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSRange(location: index, length: 1)
    }
    @objc func termsLabelTapped() {
#if BackpackerHire
        if let url = URL(string: "https://backpacker.csdevhub.com/terms-condition/employer") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
#else
        if let url = URL(string: "https://backpacker.csdevhub.com/terms-condition/backpacker") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
#endif
        
    }
    
    private func handleTermConditionBtn(){
        if self.btn_trmcondition.tag == 0{
            self.btn_trmcondition.tag = 1
            self.btn_trmcondition.setImage(UIImage(named: "Checkbox2"), for: .normal)
        }else{
            self.btn_trmcondition.tag = 0
            self.btn_trmcondition.setImage(UIImage(named: "Checkbox"), for: .normal)
        }
    }
    
    @IBAction func btn_termsCondition(_ sender: Any) {
        self.handleTermConditionBtn()
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        self.view.endEditing(true)
        if isEmailSelected {
            if self.validateEmail() {
                if self.btn_trmcondition.tag == 1{
                    self.loginApiCall()
                }else{
                    AlertManager.showAlert(
                        on: self,
                        title: "Terms & Conditions Required",
                        message: "You must agree to the Terms & Conditions to create an account or log in."
                    )
                    
                }
                
            }
        }else{
            if self.validatePhoneNumber() {
                if self.btn_trmcondition.tag == 1{
                    self.loginApiCall()
                }else{
                    AlertManager.showAlert(
                        on: self,
                        title: "Terms & Conditions Required",
                        message: "You must agree to the Terms & Conditions to create an account or log in."
                    )
                    
                }
            }
        }
      
    }
    func validateEmail() -> Bool {
        
        let email = txtFld_Email.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // ✅ Check empty
        if email.isEmpty {
            lbl_Error.isHidden = false
            lbl_Error.text = "Email cannot be empty."
            btn_term_Topconstraint.constant = 10.0
            return false
        }
        
        // ✅ Email Regex Validation
        let emailPredicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
        
        if emailPredicate.evaluate(with: email) {
            print("✅ Valid Email")
            lbl_Error.isHidden = true
            lbl_Error.text = ""
            btn_term_Topconstraint.constant = 5.0
            return true
        } else {
            lbl_Error.isHidden = false
            lbl_Error.text = "Please enter a valid email address."
            btn_term_Topconstraint.constant = 10.0
            return false
        }
    }
    
    
   
}

extension EmailVC : CountryPickerViewDelegate,CountryPickerViewDataSource ,UITextFieldDelegate{
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        self.lbl_countryCode.text  = country.phoneCode
        self.img_flag.image = country.flag
        if txtFld_PhoneNumber.text?.isEmpty == false{
            let _ =   self.validatePhoneNumber()
        }
        
    }
    
    //DatatSource
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        
        return ["NG", "US", "GB"].compactMap { countryPickerView.getCountryByCode($0) }
        
    }
    func validatePhoneNumber() -> Bool {
        let phoneNumber = txtFld_PhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let phoneCode = picker_Vw.selectedCountry.phoneCode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check for empty fields
        if phoneNumber.isEmpty {
            self.lbl_errorPhneNumber.isHidden = false
            self.lbl_errorPhneNumber.text = "Phone number cannot be empty."
            self.btn_term_Topconstraint.constant = 10.0
            return false
        }
        if phoneCode.isEmpty {
            self.lbl_errorPhneNumber.isHidden = false
            self.lbl_errorPhneNumber.text = "Please select a country code."
            self.btn_term_Topconstraint.constant = 10.0
            return false
        }
        // Validate format
        let region = picker_Vw.selectedCountry.code
        let  isValid   = ValidationManager.isValidPhoneNumber(phoneNumber, regionCode: region)
        if isValid {
            print("-Valid number")
            self.lbl_errorPhneNumber.isHidden = true
            self.lbl_errorPhneNumber.text = ""
            self.btn_term_Topconstraint.constant = 5.0
            return true
        } else {
            self.lbl_errorPhneNumber.isHidden = false
            self.lbl_errorPhneNumber.text = Constants.Alert.invalidPhoneMessage
            self.btn_term_Topconstraint.constant = 10.0
            return false
        }
    }
    
    // -Real-time validation on text change
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtFld_PhoneNumber {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                _ = self.validatePhoneNumber()
            }
        }else if textField == self.txtFld_Email{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                _ = self.validateEmail()
            }
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // -Dismiss keyboard
        return true
    }
    
    
}
extension EmailVC {
    private func loginApiCall(){
        LoaderManager.shared.show()
        var role = String()
        var token = String()
#if BackpackerHire
        role = "2"
        token = UserDefaultsManager.shared.employerfcmToken ??  ""
#else
        role = "1"
        token = UserDefaultsManager.shared.fcmToken ?? ""
#endif
        var logInType : String = "mobile"
        var req : SignInRequest
        if isEmailSelected == true{
            logInType = "email"
            req = SignInRequest(
                roleType: role,
                mobileNumber: "",
                countryCode: "",
                countryName: "",
                email: self.txtFld_Email.text!, loginType: logInType
            )
        }else{
            logInType = "mobile"
            req = SignInRequest(
                roleType: role,
                mobileNumber: self.txtFld_PhoneNumber.text!,
                countryCode: picker_Vw.selectedCountry.phoneCode,
                countryName: picker_Vw.selectedCountry.name,
                email: "", loginType: logInType
            )
        }
        viewModel.loginUser(loginRequest: req) { success, response, statusCode in
            if let statusCode = statusCode {
                let httpStatus = HTTPStatusCode(rawValue: statusCode)
                LoaderManager.shared.hide()
                switch httpStatus {
                case .ok, .created:
                    print("-Success:", httpStatus.description)
                    DispatchQueue.main.async {
                        if success, let userId = response?.data?.userId {
#if BackpackerHire
                            UserDefaultsManager.shared.employeruserId = userId
#else
                            UserDefaultsManager.shared.userId = userId
                            
#endif
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                LoaderManager.shared.hide()
                                self.push(OtpVC.self, fromStoryboard: "Main", identifier: "OtpVC") { vc in
                                    // vc.phoneNumbaer = self.txtFld_PhoneNumber.text ?? ""
#if BackpackerHire
                                    vc.userId = UserDefaultsManager.shared.employeruserId ?? ""
#else
                                    vc.userId = UserDefaultsManager.shared.userId ?? ""
                                    
#endif
                                }
                            }
                            //  self.txtFld_PhoneNumber.text = ""
                        } else {
                        }
                    }
                case .badRequest:
                    print(" Bad request:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Alert", message:response?.message ?? "Something went wrong")
                case .unauthorized:
                    print(" Unauthorized:", httpStatus.description)
                    self.viewModel.refreshToken { (success, result, statusCode) in
                        if statusCode == 200 || statusCode == 201 {
                            self.loginApiCall()
                        }
                    }
                case .methodNotAllowed:
                    print(" Method not allowed:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                case .internalServerError:
                    print(" Server error:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                case .unknown:
                    print(" Unknown status:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                case .unauthorizedToken:
                    print(" Unknown status:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                }
            }else{
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "Something went wrong.")
            }
        }
        
    }
}
