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
            self.btn_Save.isUserInteractionEnabled = false
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
       }
}
