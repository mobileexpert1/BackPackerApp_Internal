//
//  LoginVC.swift
//  Backpacker
//
//  Created by Mobile on 02/07/25.
//

import UIKit
import CountryPickerView

class LoginVC: UIViewController {
    
    //Outlet
    @IBOutlet weak var btn_term_Topconstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_temsandCondition: UILabel!
    @IBOutlet weak var btn_trmcondition: UIButton!
    @IBOutlet weak var vwTxtFld: UIView!
    @IBOutlet weak var phoneNumberVw: UIView!
    @IBOutlet weak var lblLogIn: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var picker_Vw: CountryPickerView!
    @IBOutlet weak var btn_countryPicker: UIButton!
    @IBOutlet weak var btn_Continue: UIButton!
    @IBOutlet weak var lbl_phoneCode: UILabel!
    @IBOutlet weak var lbl_Error: UILabel!
    @IBOutlet weak var txtFld_PhoneNumber: UITextField!
    //Variables
    @IBOutlet weak var imgFlg: UIImageView!
    @IBOutlet weak var lbl_EntrNumber: UILabel!
    var countryName = String()
    var phoneCode = String()
    var flag = UIImage()
    var viewModel = LogInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setupRoundedBorder(for: vwTxtFld)
        self.setupRoundedBorder(for: phoneNumberVw)
        applyGradientButtonStyle(to: btn_Continue)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    private func setUI(){
        self.btn_term_Topconstraint.constant = 0.0
        self.btn_trmcondition.tag = 0
        self.lbl_temsandCondition.textColor = UIColor(named: "subTitleColor")
        self.btn_trmcondition.setImage(UIImage(named: "Checkbox"), for: .normal)
        self.lbl_temsandCondition.font = FontManager.inter(.regular, size: 10.0)
        self.lblLogIn.font = FontManager.inter(.regular, size: 26.0)
        self.lblSubTitle.font = FontManager.inter(.regular, size: 14.0)
        self.txtFld_PhoneNumber.font = FontManager.inter(.regular, size: 17.0)
        self.lbl_EntrNumber.font = FontManager.inter(.medium, size: 14.0)
        self.txtFld_PhoneNumber.placeholder = Constants.Placeholder.phoneNumber
        self.txtFld_PhoneNumber.font = FontManager.inter(.regular, size: 14.0)
        self.txtFld_PhoneNumber.keyboardType = .phonePad
        self.btn_Continue.layer.cornerRadius = 10.0
        picker_Vw.delegate = self
        picker_Vw.dataSource = self
        picker_Vw.setCountryByName("India")
        picker_Vw.showCountryNameInView = false
        picker_Vw.showCountryCodeInView = false
        picker_Vw.showPhoneCodeInView = false
        picker_Vw.flagImageView.isHidden = true
        self.lbl_Error.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_Error.isHidden = true
        self.lbl_phoneCode.text = picker_Vw.selectedCountry.phoneCode
        self.lbl_phoneCode.font = FontManager.inter(.regular, size: 14.0)
        self.imgFlg.image = picker_Vw.selectedCountry.flag
        self.btn_Continue.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.txtFld_PhoneNumber.delegate = self
        txtFld_PhoneNumber.returnKeyType = .done
        btn_countryPicker.addTarget(self, action: #selector(selectCountryAction(_:)), for: .touchUpInside)
     //   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
      //  lbl_temsandCondition.addGestureRecognizer(tapGesture)
        self.lbl_temsandCondition.isUserInteractionEnabled = true
        self .setupTermsLabel()
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
             .foregroundColor: UIColor.systemBlue,
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
//        } else if NSLocationInRange(index, eulaRange) {
//    #if BackpackerHire
//            openURL("https://backpacker.csdevhub.com/eula/employer")
//    #else
//            openURL("https://backpacker.csdevhub.com/eula/backpacker")
//    #endif
//        }
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
           // self.lbl_temsandCondition.textColor = UIColor(named: "themeColor")
         //   self.lbl_temsandCondition.isUserInteractionEnabled = true
        }else{
            self.btn_trmcondition.tag = 0
            self.btn_trmcondition.setImage(UIImage(named: "Checkbox"), for: .normal)
         //   self.lbl_temsandCondition.textColor = UIColor(named: "subTitleColor")
         //   self.lbl_temsandCondition.isUserInteractionEnabled = false
        }
    }
    @objc func selectCountryAction(_ sender: Any) {
        picker_Vw.showCountriesList(from: self)
        
    }
    
    //MARK: - Action
    
    @IBAction func action_Continue(_ sender: Any) {
        self.view.endEditing(true)
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
    func setupRoundedBorder(for view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(named:"borderColor")?.cgColor
        view.clipsToBounds = true
    }
    
    @IBAction func action_termsAndCondtionBtn(_ sender: Any) {
        
        self.handleTermConditionBtn()
    }
    
    
}
//MARK: - EXtension
extension LoginVC : CountryPickerViewDelegate,CountryPickerViewDataSource ,UITextFieldDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        self.lbl_phoneCode.text  = country.phoneCode
        self.imgFlg.image = country.flag
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
            self.lbl_Error.isHidden = false
            self.lbl_Error.text = "Phone number cannot be empty."
            self.btn_term_Topconstraint.constant = 10.0
            return false
        }
        if phoneCode.isEmpty {
            self.lbl_Error.isHidden = false
            self.lbl_Error.text = "Please select a country code."
            self.btn_term_Topconstraint.constant = 10.0
            return false
        }
        // Validate format
        let region = picker_Vw.selectedCountry.code
        let  isValid   = ValidationManager.isValidPhoneNumber(phoneNumber, regionCode: region)
        if isValid {
            print("-Valid number")
            self.lbl_Error.isHidden = true
            self.lbl_Error.text = ""
            self.btn_term_Topconstraint.constant = 2.0
            return true
        } else {
            self.lbl_Error.isHidden = false
            self.lbl_Error.text = Constants.Alert.invalidPhoneMessage
            self.btn_term_Topconstraint.constant = 10.0
            return false
        }
    }
    
    // -Real-time validation on text change
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            _ = self.validatePhoneNumber()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // -Dismiss keyboard
        return true
    }
}



extension LoginVC {
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
        
        let loginRequest = LoginRequest(
            roleType: role,
            mobileNumber: self.txtFld_PhoneNumber.text!,
            countryCode: picker_Vw.selectedCountry.phoneCode,
            countryName: picker_Vw.selectedCountry.name,
            fcmToken: token
        )
        viewModel.loginUser(loginRequest: loginRequest) { success, response, statusCode in
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
                    print("⚠️ Bad request:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Alert", message:response?.message ?? "Something went wrong")
                case .unauthorized:
                    print("🔒 Unauthorized:", httpStatus.description)
                    self.viewModel.refreshToken { (success, result, statusCode) in
                        if statusCode == 200 || statusCode == 201 {
                            self.loginApiCall()
                        }
                    }
                case .methodNotAllowed:
                    print("🚫 Method not allowed:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                case .internalServerError:
                    print("💥 Server error:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                case .unknown:
                    print("❓ Unknown status:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                case .unauthorizedToken:
                    print("❓ Unknown status:", httpStatus.description)
                    AlertManager.showAlert(on: self, title: "Error", message: httpStatus.description)
                }
            }else{
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "Something went wrong.")
            }
            
        }

    }
}
