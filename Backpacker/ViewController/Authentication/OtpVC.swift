//
//  OtpVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit

class OtpVC: UIViewController {
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    private let hiddenOTPTextField = UITextField()
    
    @IBOutlet weak var lbl_Error: UILabel!
    @IBOutlet weak var btn_Resend: UIButton!
    @IBOutlet weak var btn_verify: UIButton!
    // Visible OTP fields
    @IBOutlet weak var lbl_EnterOtp: UILabel!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var txt5: UITextField!
    @IBOutlet weak var txt6: UITextField!
    // Outer views (optional for borders, animations)
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var lbl_dontReceive: UILabel!
    @IBOutlet weak var btn_verifyHeight: NSLayoutConstraint!
    private var otpTextFields: [UITextField] = []
    var phoneNumbaer : String = ""
    var viewModel = LogInVM()
    var userId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextFields = [txt1, txt2, txt3, txt4, txt5, txt6]
        self.setUpUI()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btn_verifyHeight.constant = 50.0
        applyGradientButtonStyle(to: btn_verify, opacity: 0.4, isUserInteractionEnabled: false)
        self.btn_verify.isUserInteractionEnabled = false
    }
    private func setUpUI(){
        self.lbl_title.font = FontManager.inter(.regular, size: 26.0)
        self.lbl_EnterOtp.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_dontReceive.font = FontManager.inter(.regular, size: 14.0)
        self.btn_Resend.titleLabel?.font = FontManager.inter(.semiBold, size: 14.0)
        let fullText = "We’ve sent an SMS with an activation code to your phone"
        self.lbl_Error.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_Error.isHidden = true
        let phoneNumber = phoneNumbaer
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Apply regular font and color to the whole text
        attributedString.addAttributes([
            .font: FontManager.inter(.regular, size: 14.0),
            .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.697330298)
        ], range: NSRange(location: 0, length: fullText.count))
        
        // Apply bold font and different color to the phone number
        if let range = fullText.range(of: phoneNumber) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .font: FontManager.inter(.medium, size: 15.0),
                .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ], range: nsRange)
        }
        
        self.lbl_SubTitle.text = fullText
        for textField in otpTextFields {
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.textAlignment = .center
        }
        let allViews = [view1, view2, view3, view4, view5, view6]
        
        for view in allViews {
            view?.layer.cornerRadius = 14.0
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        }
        //  self.btn_Resend.setTitle("Resend", for: .normal)
        self.btn_verify.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_verify.layer.cornerRadius = 10.0
        self.btn_Resend.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        
    }
    //MARK: - Action
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func action_Verify(_ sender: Any) {
        
        let val =  checkIfAllFieldsFilled()
        if val == true{
            self.VerifyOtpApiCall()
        }else{
            self.lbl_Error.isHidden = false
            self.lbl_Error.text = "Please Enter All Fields."
        }
    }
    
    
    @IBAction func action_Resend(_ sender: Any) {
       
        self.ResendOtpApiCall()
       
    }
    
    
    
}
extension OtpVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newLength = text.count + string.count - range.length
        
        if newLength <= 1 {
            if string.count > 0 {
                // Set text manually
                textField.text = string
                
                // Move to the next field
                if let index = otpTextFields.firstIndex(of: textField), index < otpTextFields.count - 1 {
                    otpTextFields[index + 1].becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            } else {
                // Handle backspace
                textField.text = ""
                if let index = otpTextFields.firstIndex(of: textField), index > 0 {
                    otpTextFields[index - 1].becomeFirstResponder()
                }
            }
            
            // ✅ Call continuous validation after change
            let val =  checkIfAllFieldsFilled()
            if val == true{
                DispatchQueue.main.async{ [self] in
                    self.btn_verify.isUserInteractionEnabled = true
                    self.lbl_Error.isHidden = true
                    self.btn_verifyHeight.constant = 50.0
                    applyGradientButtonStyle(to: btn_verify)
                }
            }else{
                
                self.btn_verify.isUserInteractionEnabled = true
                self.lbl_Error.isHidden = false
                self.lbl_Error.text = "Please Enter All Fields."
                self.btn_verifyHeight.constant = 0.0
                applyGradientButtonStyle(to: btn_verify)
            }
            return false
        }
        
        return false
    }
    
    func getOTP() -> String {
        return otpTextFields.compactMap { $0.text }.joined()
    }
    func checkIfAllFieldsFilled() -> Bool {
        let isAllFilled = otpTextFields.allSatisfy { !($0.text?.isEmpty ?? true) }
        
        if isAllFilled {
            let otp = otpTextFields.compactMap { $0.text }.joined()
            print("✅ All OTP fields filled. OTP: \(otp)")
            
            return true
            // Optionally call a submit method here
            // submitOTP(otp)
        } else {
            
            return false
        }
    }
    
}
extension OtpVC {
    
    private func VerifyOtpApiCall() {
        LoaderManager.shared.show()
        lbl_Error.isHidden = true

        let fcmToken = UserDefaultsManager.shared.fcmToken
        let deviceInfo = getDeviceInfo()
        
        let req = OtpRequest(
            userId: self.userId,
            otp: self.getOTP(),
            fcmToken: fcmToken ?? "",
            appVersion: deviceInfo.appVersion,
            osType: deviceInfo.osType,
            osVersion: deviceInfo.osVersion,
            deviceBrand: deviceInfo.deviceBrand,
            deviceModel: deviceInfo.deviceModel,
            deviceId: deviceInfo.deviceId
        )

        viewModel.SendOtp(otpRequest: req) { success, result, statusCode in
            guard let statusCode = statusCode else {
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "No status code received.")
                return
            }

            let httpStatus = HTTPStatusCode(rawValue: statusCode)

            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                switch httpStatus {
                case .ok, .created:
                    if result?.success == true {
                        AlertManager.showSingleButtonAlert(on: self, message: result?.message ?? "Success") {
                            let tabBarVC = UIStoryboard(name: "TabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
                            UIApplication.setRootViewController(tabBarVC)
                        }
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Invalid OTP")
                    }

                case .badRequest:
                    self.viewModel.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.VerifyOtpApiCall() // Retry
                        } else {
                            AlertManager.showSingleButtonAlert(on: self, message: refreshStatusCode?.description ?? "Internal Server Error" ){
                                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                                let nav = UINavigationController(rootViewController: loginVC)
                                nav.navigationBar.isHidden = true
                                UIApplication.setRootViewController(nav)
                            }
                        }
                    }

                case .unauthorized, .unauthorizedToken, .methodNotAllowed, .internalServerError:
                    print("⚠️ \(httpStatus.description)")
                case .unknown:
                    print("❓ Unknown error occurred.")
                }
            }
        }
    }

    private func ResendOtpApiCall(){
        let req = ResendOtpRequest(userId: userId)
        viewModel.ReSendOtp(otpRequest: req) { success, result, statusCode in
            DispatchQueue.main.async {
                guard let statusCode = statusCode else {
                    AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                    return
                }
                let httpStatus = HTTPStatusCode(rawValue: statusCode)

                switch httpStatus {
                case .ok, .created:
                    if success, let message = result?.message {
                        AlertManager.showAlert(on: self, title: "", message: message)
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Resend OTP failed.")
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Bad Request", message: "Please check your request parameters.")
                case .unauthorized, .unauthorizedToken:
                    AlertManager.showAlert(on: self, title: "Session Expired", message: "Please log in again.")
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                    let nav = UINavigationController(rootViewController: loginVC)
                    nav.navigationBar.isHidden = true
                    UIApplication.setRootViewController(nav)
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")

                default:
                    AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                }
            }
        }

    }
}
