//
//  ForceUpdateVC.swift
//  Backpacker
//
//  Created by Mobile on 08/08/25.
//

import UIKit

class ForceUpdateVC: UIViewController {

    @IBOutlet weak var main_Vw: UIView!
    
    @IBOutlet weak var vw_Scroll: UIView!
    @IBOutlet weak var lbl_Header: UILabel!
    
    @IBOutlet weak var email_Vw: CommonTxtFldLblVw!
    
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var name_Vw: CommonTxtFldLblVw!
    let profileVm = ProfileVM()
    let viewModelAuth = LogInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    func setUpUI(){
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

 
    @IBAction func action_Continue(_ sender: Any) {
        let isNameValid = name_Vw.validateNotEmpty(errorMessage: "Please enter your name")
        let isEmailValid = email_Vw.validateNotEmpty(errorMessage: "Please enter your email")
        // Visa type validation
       
        if isNameValid && isEmailValid{
            self.updateProfileInfo(name: name_Vw.txtFld.text ?? "", email: email_Vw.txtFld.text ?? "", state: "", area: "", visaType: "")
        } else {
           
        }
        
    }
    
}
extension ForceUpdateVC {
    //MARK: - UPdate Profile Api Call
    func updateProfileInfo(name: String, email: String, state: String, area: String, visaType: String) {
        LoaderManager.shared.show()
        profileVm.updateBackPackerProfile(email: email, name: name, state: "", area: "", visaType: "", notificationStatus: false) { [weak self] (success: Bool, result: UpdateProfileResponse?, statusCode: Int?) in
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
