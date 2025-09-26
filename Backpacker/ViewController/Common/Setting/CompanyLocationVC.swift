//
//  CompanyLocationVC.swift
//  BackpackerHire
//
//  Created by Mobile on 26/09/25.
//

import UIKit
import Foundation
import MapKit
class CompanyLocationVC: UIViewController {

    @IBOutlet weak var txtFld_manual: UITextField!
    @IBOutlet weak var txtFld_Vw: UIView!
    @IBOutlet weak var lbl_manually: UILabel!
    @IBOutlet weak var main_VwManual: UIView!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var txtFldLcation: UITextField!
    @IBOutlet weak var VwTxtFld: UIView!
    @IBOutlet weak var lbl_addlocation: UILabel!
    @IBOutlet weak var bgVwAddLocation: UIView!
    var isLocAlreadyAdded: Bool = true
    let profileVm = ProfileVM()
    let viewModelAuth = LogInVM()
    var lat : Double?
    var long : Double?
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
    }
    @IBAction func btn_canle(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btn_save(_ sender: Any) {
        if self.lat != 0.0 && self.long != 0.0{
            self.addCompanyLocation()
        }else{
            AlertManager.showAlert(on: self, title: "Alert!", message: "Location not properly get,Please choose location again.")
        }
        
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
        if isLocAlreadyAdded == true{
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

extension CompanyLocationVC {
    private func addCompanyLocation(){
        
        // Call API
        LoaderManager.shared.show()
        let locationText = self.txtFldLcation.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        profileVm.addCompanyLocation(name: locationText, lat: lat ?? 0.0, long: long ?? 0.0) { success, message ,statusCode in
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
                    if success == true {
                        self.dismiss(animated: true)
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.addCompanyLocation()
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    
                }
            }
        }
        
    }
}
