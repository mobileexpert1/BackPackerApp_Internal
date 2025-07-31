//
//  AddNewPlaceVC.swift
//  Backpacker
//
//  Created by Mobile on 30/07/25.
//

import UIKit
import CoreLocation
class AddNewPlaceVC: UIViewController {

    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var lbl_PlaceHodler: UILabel!
    @IBOutlet weak var imgPlacehoder: UIImageView!
    @IBOutlet weak var Vw_Placehoder: UIView!
    @IBOutlet weak var header_Address: UILabel!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var Vw_Name: UIView!
    @IBOutlet weak var Vw_Address: UIView!
    @IBOutlet weak var header_Name: UILabel!
    
    @IBOutlet weak var main_ImgVw: UIImageView!
    @IBOutlet weak var Btn_Cross: UIButton!
    @IBOutlet weak var lbl_Val_Location: UILabel!
    @IBOutlet weak var vw_Location: UIView!
    @IBOutlet weak var header_Location: UILabel!
    @IBOutlet weak var txtVw_Description: UITextView!
    @IBOutlet weak var Vw_Description: UIView!
    @IBOutlet weak var header_description: UILabel!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var btncan: UIButton!
    @IBOutlet weak var txtFld_Address: UITextField!
    var mediaPicker: MediaPickerManager?
    let viewModel = HangoutViewModel()
    let viewModelAuth = LogInVM()
    var latitude: Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpUI()
        
        
    }
    
    func SetUpUI(){
        self.main_ImgVw.image = UIImage(named:"BgUploadImage")
        Vw_Name.layer.cornerRadius = 10.0
        Vw_Name.layer.borderWidth = 1.0
        Vw_Name.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        
        
        Vw_Address.layer.cornerRadius = 10.0
        Vw_Address.layer.borderWidth = 1.0
        Vw_Address.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        
        Vw_Description.layer.cornerRadius = 10.0
        Vw_Description.layer.borderWidth = 1.0
        Vw_Description.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        vw_Location.layer.cornerRadius = 10.0
        vw_Location.layer.borderWidth = 1.0
        vw_Location.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16)
        self.header_Address.font = FontManager.inter(.medium, size: 14)
        self.header_Name.font = FontManager.inter(.medium, size: 14)
        self.header_description.font = FontManager.inter(.medium, size: 14)
        self.header_Location.font = FontManager.inter(.medium, size: 14)
        
        self.lbl_PlaceHodler.font = FontManager.inter(.medium, size: 13)
        self.lbl_Val_Location.font = FontManager.inter(.regular, size: 14.0)
        applyGradientButtonStyle(to: self.btn_Save)
        self.btncan.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.setUpLocationHeader()
        self.setUpImagePlacehoder()
        txtFldName.attributedPlaceholder = NSAttributedString(
                   string: "Name",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldName.delegate = self
        
        
        txtFld_Address.attributedPlaceholder = NSAttributedString(
                   string: "Address",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFld_Address.delegate = self
        
        txtVw_Description.delegate = self
    }
    
    
    @IBAction func setLocation(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC {
            settingVC.delegate = self
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
    }
    
    func setUpLocationHeader(){
        if lbl_Val_Location.text == "Current Location"{
            self.lbl_Val_Location.textColor = UIColor(hex: "#9D9D9D")
        }else{
            self.lbl_Val_Location.textColor = UIColor.black
        }
    }
    @IBAction func actionCross(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func actinon_UploadIMage(_ sender: Any) {
        mediaPicker = MediaPickerManager(presentingVC: self)
    mediaPicker?.showMediaOptions { image in
        // Do something with the image
        print("Selected image: \(image)")
    
        self.main_ImgVw.image = image
        self.lbl_PlaceHodler.isHidden = true
        self.imgPlacehoder.isHidden = true
        self.setUpImagePlacehoder()
       
    }
     
    }
    @IBAction func action_DeletImage(_ sender: Any) {
        self.main_ImgVw.image = nil
        self.main_ImgVw.image = UIImage(named: "BgUploadImage")
        self.setUpImagePlacehoder()
        
        
    }
    func setUpImagePlacehoder(){
        if self.main_ImgVw.image == UIImage(named:"BgUploadImage"){
            self.main_ImgVw.layer.cornerRadius = 0.0
            self.Btn_Cross.isHidden = true
            self.btn_Save.isUserInteractionEnabled = true
            self.imgPlacehoder.isHidden = false
            self.lbl_PlaceHodler.isHidden = false
        }else{
            self.main_ImgVw.layer.cornerRadius = 10.0
            self.Btn_Cross.isHidden = false
            self.btn_Save.isUserInteractionEnabled = true
            self.imgPlacehoder.isHidden = true
            self.lbl_PlaceHodler.isHidden = true
        }
    }
    
    
    
    @IBAction func action_Save_Hangout(_ sender: Any) {
        let name = txtFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let address = txtFld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let location = lbl_Val_Location.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let desc = txtVw_Description.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
     
          guard validateHangoutFields(
              name: name,
              address: address,
              locationText: location,
              description: desc,
              image: main_ImgVw.image!.jpegData(compressionQuality: 0.8),
              on: self
          ) else {
              return
          }
        self.submitHangout(name: name, address: address, lat: self.latitude ?? 0.0, long: self.longitude ?? 0.0, locationText: location, description: desc, image: main_ImgVw.image!.jpegData(compressionQuality: 0.8))
    }
    
    

}
extension AddNewPlaceVC: UITextFieldDelegate, UITextViewDelegate {

    // Dismiss keyboard when Return is pressed in UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Dismiss keyboard when Return is pressed in UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension AddNewPlaceVC : SetLocationDelegate{
    func didSelectLocation(locationName: String, fullAddress: String, coordinate: CLLocationCoordinate2D) {
        lbl_Val_Location.text = locationName
        txtFld_Address.text = fullAddress
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

}


extension AddNewPlaceVC{
    func submitHangout(name: String, address: String, lat: Double, long: Double, locationText: String, description: String, image: Data?) {
        let image = self.main_ImgVw.image?.jpegData(compressionQuality: 0.8)

            viewModel.uploadHangout(
                name: name,
                       address: address,
                       lat: lat,
                       long: long,
                       locationText: locationText,
                       description: description,
                       image: image
            ) { success, message ,statusCode in
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
                            AlertManager.showAlert(on: self, title: "Success", message: message ?? "Hangout uploaded.")
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                        }
                    case .badRequest:
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.submitHangout(name: name, address: address, lat: lat, long: long, locationText: locationText, description: description, image: image) // Retry
                            } else {
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                        
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.submitHangout(name: name, address: address, lat: lat, long: long, locationText: locationText, description: description, image: image) // Retry
                            } else {
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                        
                        
                    case .unauthorizedToken, .methodNotAllowed, .internalServerError:
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    }
                }
            }
        }

       
    
    func validateHangoutFields(
        name: String,
        address: String,
        locationText: String,
        description: String,
        image: Data?,
        on viewController: UIViewController
    ) -> Bool {
        if name.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter name.")
            return false
        }
        if address.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter address.")
            return false
        }
        if locationText.isEmpty  || locationText == "Current Location"{
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter location.")
            return false
        }
        if description.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter description.")
            return false
        }
        
        if self.main_ImgVw.image == UIImage(named:"BgUploadImage"){
            AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please select an image.")
            return false
            
            if image == nil {
                AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please select an image.")
                return false
            }
            return false
        }
        return true
    }

}
