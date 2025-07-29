//
//  ChooseRoleTypeVC.swift
//  Backpacker
//
//  Created by Mobile on 28/07/25.
//

import UIKit

class ChooseRoleTypeVC: UIViewController {
    @IBOutlet weak var tick_Image_Accomodation: UIImageView!
    let empRoleType = "2"
    let accomodationRoleType = "3"
    let hangOutRoleType = "4"
    @IBOutlet weak var Subtitle_Accomodation: UILabel!
    @IBOutlet weak var subTitle_Emp: UILabel!
    @IBOutlet weak var titleEmp: UILabel!
    @IBOutlet weak var BgVwEmp: UIView!
    @IBOutlet weak var BgVwAccomodation: UIView!
    @IBOutlet weak var ttle_Accomodation: UILabel!
    @IBOutlet weak var tick_Image_Hangout: UIImageView!
    @IBOutlet weak var Tick_Img_Emp: UIImageView!
    @IBOutlet weak var title_Hangiut: UILabel!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var subttle_Hangout: UILabel!
    @IBOutlet weak var BgVwHangout: UIView!
    @IBOutlet weak var btn_Save: UIButton!
    var viewModel = LogInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
        applyGradientButtonStyle(to: self.btn_Save)
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        // Do any additional setup after loading the view.
    }
    
    
    func setUpUi(){
        
        self.title_Hangiut.font = FontManager.inter(.medium, size: 15.0)
        self.subttle_Hangout.font = FontManager.inter(.regular, size: 12.0)
        
        self.titleEmp.font = FontManager.inter(.medium, size: 15.0)
        self.subTitle_Emp.font = FontManager.inter(.regular, size: 12.0)
        
        self.ttle_Accomodation.font = FontManager.inter(.medium, size: 15.0)
        self.Subtitle_Accomodation.font = FontManager.inter(.regular, size: 12.0)
        self.tick_Image_Hangout.isHidden = true
        self.tick_Image_Accomodation.isHidden = true
        self.Tick_Img_Emp.isHidden = true
        self.BgVwHangout.layer.cornerRadius = 10
        self.BgVwHangout.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwHangout.layer.borderWidth = 1.0
        
        self.BgVwAccomodation.layer.cornerRadius = 10
        self.BgVwAccomodation.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwAccomodation.layer.borderWidth = 1.0
        
        self.BgVwEmp.layer.cornerRadius = 10
        self.BgVwEmp.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwEmp.layer.borderWidth = 1.0
        
        
        
    }
    @IBAction func action_Employer(_ sender: Any) {
        self.tick_Image_Hangout.isHidden = true
        self.tick_Image_Accomodation.isHidden = true
        self.Tick_Img_Emp.isHidden = false
        
        
        self.BgVwHangout.layer.cornerRadius = 10
        self.BgVwHangout.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwHangout.layer.borderWidth = 1.0
        
        self.BgVwAccomodation.layer.cornerRadius = 10
        self.BgVwAccomodation.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwAccomodation.layer.borderWidth = 1.0
        
        self.BgVwEmp.layer.cornerRadius = 10
        self.BgVwEmp.layer.borderColor = UIColor(hex: "#785DC2").cgColor
        self.BgVwEmp.layer.borderWidth = 1.0
        
        saveRoleType(empRoleType)
    }
    
    @IBAction func action_Hangout(_ sender: Any) {
        self.tick_Image_Hangout.isHidden = false
        self.tick_Image_Accomodation.isHidden = true
        self.Tick_Img_Emp.isHidden = true
        
        self.BgVwHangout.layer.cornerRadius = 10
        self.BgVwHangout.layer.borderColor = UIColor(hex: "#29A1F8").cgColor
        self.BgVwHangout.layer.borderWidth = 1.0
        
        self.BgVwAccomodation.layer.cornerRadius = 10
        self.BgVwAccomodation.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwAccomodation.layer.borderWidth = 1.0
        
        self.BgVwEmp.layer.cornerRadius = 10
        self.BgVwEmp.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwEmp.layer.borderWidth = 1.0
        saveRoleType(hangOutRoleType)
    }
    
    @IBAction func action_Accomodation(_ sender: Any) {
        self.tick_Image_Hangout.isHidden = true
        self.tick_Image_Accomodation.isHidden = false
        self.Tick_Img_Emp.isHidden = true
        self.BgVwHangout.layer.cornerRadius = 10
        self.BgVwHangout.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwHangout.layer.borderWidth = 1.0
        
        self.BgVwAccomodation.layer.cornerRadius = 10
        self.BgVwAccomodation.layer.borderColor = UIColor(hex: "#F76BA7").cgColor
        self.BgVwAccomodation.layer.borderWidth = 1.0
        
        self.BgVwEmp.layer.cornerRadius = 10
        self.BgVwEmp.layer.borderColor = UIColor(hex: "#DDDDDD").cgColor
        self.BgVwEmp.layer.borderWidth = 1.0
        
        saveRoleType(accomodationRoleType)
        
    }
    
    private func saveRoleType(_ type: String) {
        UserDefaults.standard.set(type, forKey: "UserRoleType")
        UserDefaults.standard.synchronize() // optional
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Save(_ sender: Any) {
        ChooseRoleTypeApiCall()
    }
    
    
    private func ChooseRoleTypeApiCall() {
        LoaderManager.shared.show()
        let role = UserDefaults.standard.string(forKey: "UserRoleType") ?? "2"
        let req = ChooseRoleTypeRequest(subRoleType: role)
        
        viewModel.chooseRoleType(otpRequest: req) { success, result, statusCode in
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
                    if ((result?.success) != nil) == true {
                        AlertManager.showSingleButtonAlert(on: self, message: result?.message ?? "Success") {
                            let storyboard = UIStoryboard(name: "MainTabBarEmpStoryboard", bundle: nil)
                            let rootVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarEmpController")
                            UIApplication.setRootViewController(rootVC)
                        }
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Invalid OTP")
                    }
                    
                case .badRequest:
                    self.viewModel.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.ChooseRoleTypeApiCall() // Retry
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
}
