//
//  CompanyLocationVC.swift
//  BackpackerHire
//
//  Created by Mobile on 26/09/25.
//

import UIKit
import Foundation
import MapKit

protocol CompanyLocationVCDelegate: AnyObject {
    func didLocationAdded(success: Bool)
}


class CompanyLocationVC: UIViewController {
    weak var delegate: CompanyLocationVCDelegate?
    @IBOutlet weak var txtFld_manual: UITextField!
    @IBOutlet weak var txtFld_Vw: UIView!
    @IBOutlet weak var lbl_manually: UILabel!
    @IBOutlet weak var main_VwManual: UIView!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var txtFldLcation: UITextField!
    @IBOutlet weak var VwTxtFld: UIView!
    @IBOutlet weak var lbl_addlocation: UILabel!
    @IBOutlet weak var bgVwAddLocation: UIView!
    var isLocAlreadyAdded: Bool = false
    let profileVm = ProfileVM()
    let viewModelAuth = LogInVM()
    var lat : Double?
    var long : Double?
    var locationAlreadyExist : Bool = false
    var companyID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
       
        
    }
    func setUpUI(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2) // semi-transparent
        applyGradientButtonStyle(to: self.btn_Save)
        self.VwTxtFld.addShadowAllSides(radius: 0.5)
        self.btn_Save.titleLabel?.font = FontManager.inter(.regular, size: 16.0)
        self.txtFldLcation.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_addlocation.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_manually.font = FontManager.inter(.regular, size: 14.0)
        self.txtFld_Vw.addShadowAllSides(radius: 0.5)
        self.txtFld_manual.font = FontManager.inter(.regular, size: 14.0)
        self.handleManualTxtFldAppearance()
        txtFldLcation.delegate = self
        txtFld_manual.delegate = self
    }
    @IBAction func btn_canle(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_save(_ sender: Any) {
        // Check if latitude and longitude are valid
            guard self.lat != 0.0 && self.long != 0.0 else {
                AlertManager.showAlert(on: self, title: "Alert!", message: "Location not properly obtained. Please choose location again.")
                return
            }
        var loctext = String()
            // Trimmed location text
        if isLocAlreadyAdded {
            loctext = self.txtFld_manual.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        } else {
            loctext = self.txtFldLcation.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        
            
            // Check if location text is empty
        guard !loctext.isEmpty else {
                AlertManager.showAlert(on: self, title: "Alert", message: "Please enter your address")
                return
            }
            
            // Show alert based on whether the location is already added
           
            
            // Call API
            self.addCompanyLocation()
        
    }
    @IBAction func action_choosecation(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC {
            settingVC.delegate = self
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("- Could not instantiate SettingVC")
        }
        
    }
    private func handleManualTxtFldAppearance(){
        if isLocAlreadyAdded == false{
            self.main_VwManual.isHidden = true
            self.lbl_manually.isHidden = true
            self.txtFld_manual.isHidden = true
        }else{
            self.main_VwManual.isHidden = false
            self.lbl_manually.isHidden = false
            self.txtFld_manual.isHidden = false
        }
    }
}
extension CompanyLocationVC : SetLocationDelegate{
    func didSelectLocation(locationName: String, fullAddress: String, coordinate: CLLocationCoordinate2D) {
        let Address = "\(locationName), \(fullAddress)"
        self.txtFldLcation.text = Address
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
    }
}

extension CompanyLocationVC : UITextFieldDelegate {
    private func addCompanyLocation() {
        
        // Call API
        LoaderManager.shared.show()
        var locationText : String?
        if isLocAlreadyAdded == true {
            locationText = self.txtFld_manual.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }else{
            locationText = self.txtFldLcation.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }

        profileVm.addCompanyLocation2(
            name: locationText ?? "",
            lat: lat ?? 0.0,
            long: long ?? 0.0, businessCompanyId: self.companyID ?? ""
        ) { response, error, statusCode in
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
                    if let response = response, response.success == true {
                        self.handleLocationCheck(response: response.data)
                     //   self.dismiss(animated: true)
                    } else {
                        let msg = response?.message ?? error?.customDescription ?? "Something went wrong."
                        AlertManager.showAlert(on: self, title: "Error", message: msg)
                    }
                    
                case .badRequest:
                    let msg = response?.message ?? error?.customDescription ?? "Something went wrong."
                    AlertManager.showAlert(on: self, title: "Error", message: msg)
                    
                case .unauthorized:
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.addCompanyLocation()
                        } else {
                            let msg = response?.message ?? error?.customDescription ?? "Internal Server Error"
                            NavigationHelper.showLoginRedirectAlert(on: self, message: msg)
                        }
                    }
                    
                case .unauthorizedToken:
                    let msg = response?.message ?? error?.customDescription ?? "Internal Server Error"
                    NavigationHelper.showLoginRedirectAlert(on: self, message: msg)
                    
                case .unknown:
                    let msg = response?.message ?? error?.customDescription ?? "Something went wrong. Try again later."
                    AlertManager.showAlert(on: self, title: "Server Error", message: msg)
                    
                case .methodNotAllowed, .internalServerError:
                    let msg = response?.message ?? error?.customDescription ?? "Something went wrong."
                    AlertManager.showAlert(on: self, title: "Error", message: msg)
                }
            }
        }
    }
    func handleLocationCheck(response: LocationCheckData?) {
        guard let isNotExist = response?.isNotExist else {
            print("⚠️ Could not get isNotExist")
            self.delegate?.didLocationAdded(success: false)
            self.dismiss(animated: true)
            return
        }
        
        if isNotExist {
            print("✅ Location does not exist. You can add it.")
            self.delegate?.didLocationAdded(success: true)
            self.dismiss(animated: true)
            self.isLocAlreadyAdded = false
        } else {
            print("❌ Location already exists.")
            self.isLocAlreadyAdded = true
            AlertManager.showAlert(on: self, title: "Error", message:"A location with this name already exists for your business."){
                self.handleUIForIfLocationExist()
            }
            
        }
       
    }
    func handleUIForIfLocationExist(){
        if isLocAlreadyAdded == true {
            self.isLocAlreadyAdded = true
            self.handleManualTxtFldAppearance()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss keyboard
        return true
    }
}
// MARK: - LocationCheckResponse
struct LocationCheckResponse: Codable {
    let success: Bool?
    let message: String?
    let data: LocationCheckData?
}

// MARK: - LocationCheckData
struct LocationCheckData: Codable {
    let isNotExist: Bool?
}
