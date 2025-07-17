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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradientButtonStyle(to: btn_Continue)
    }
    private func setUI(){
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
    }
    
    @objc func selectCountryAction(_ sender: Any) {
        picker_Vw.showCountriesList(from: self)
        
    }
    
    //MARK: - Action
    
    @IBAction func action_Continue(_ sender: Any) {
        self.view.endEditing(true)
        if self.validatePhoneNumber() {
        
            self.loginApiCall()
        }
        
        
        
        
        
    }
    func setupRoundedBorder(for view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(named:"borderColor")?.cgColor
        view.clipsToBounds = true
    }
    
    
    
}
//MARK: - EXtension
extension LoginVC : CountryPickerViewDelegate,CountryPickerViewDataSource ,UITextFieldDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        self.lbl_phoneCode.text  = country.phoneCode
        self.imgFlg.image = country.flag
        if txtFld_PhoneNumber.text?.isEmpty == false{
            self.validatePhoneNumber()
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
            return false
        }
        if phoneCode.isEmpty {
            self.lbl_Error.isHidden = false
            self.lbl_Error.text = "Please select a country code."
            return false
        }
        // Validate format
        let isValid = ValidationManager.isValidPhoneNumber(phoneNumber, countryCode: phoneCode)
        
        if isValid {
            print("✅ Valid number")
            self.lbl_Error.isHidden = true
            self.lbl_Error.text = ""
            return true
        } else {
            self.lbl_Error.isHidden = false
            self.lbl_Error.text = Constants.Alert.invalidPhoneMessage
            return false
        }
    }
    
    // ✅ Real-time validation on text change
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            _ = self.validatePhoneNumber()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // ✅ Dismiss keyboard
        return true
    }
}



extension LoginVC {
    private func loginApiCall(){
        LoaderManager.shared.show()
        let loginRequest = LoginRequest(
            roleType: "1",
            mobileNumber: self.txtFld_PhoneNumber.text!,
            countryCode: picker_Vw.selectedCountry.phoneCode,
            countryName: picker_Vw.selectedCountry.name,
            fcmToken: UserDefaultsManager.shared.fcmToken ?? ""
        )
        viewModel.loginUser(loginRequest: loginRequest) { success, response, statusCode in
            if let statusCode = statusCode {
                let httpStatus = HTTPStatusCode(rawValue: statusCode)

                switch httpStatus {
                case .ok, .created:
                    print("✅ Success:", httpStatus.description)
                    DispatchQueue.main.async {
                        if success, let userId = response?.data?.userId {
                            UserDefaultsManager.shared.userId = userId
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                LoaderManager.shared.hide()
                                self.push(OtpVC.self, fromStoryboard: "Main", identifier: "OtpVC") { vc in
                                    vc.phoneNumbaer = self.txtFld_PhoneNumber.text ?? ""
                                    vc.userId = UserDefaultsManager.shared.userId ?? ""
                                }
                            }
                            self.txtFld_PhoneNumber.text = ""
                        } else {
                        }
                    }
                case .badRequest:
                    print("⚠️ Bad request:", httpStatus.description)
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
            }
            
        }

    }
}
