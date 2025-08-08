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
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
   // @IBOutlet weak var main_ImgVw: UIImageView!
  //  @IBOutlet weak var Btn_Cross: UIButton!
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
    var selectedImages: [UIImage] = []
    
    //Mic btn OutLet
    
    @IBOutlet weak var btn_Name_mic: UIButton!
    
    
    @IBOutlet weak var btn_description_mic: UIButton!
    @IBOutlet weak var btn_Address_mic: UIButton!
    
    //Speech to text
    let speechManager = SpeechToTextManager()
    var currentActiveTextField: UITextField?
    var currentActiveTextVw: UITextView?
    var currentlyRecordingButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpUI()
        self.setupSpeechCallbacks()
        
    }
    
    func SetUpUI(){
       
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
        
        self.lbl_PlaceHodler.font = FontManager.inter(.medium, size: 10)
        self.lbl_Val_Location.font = FontManager.inter(.regular, size: 14.0)
        applyGradientButtonStyle(to: self.btn_Save)
        self.btncan.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.setUpLocationHeader()
        self.Vw_Placehoder.layer.cornerRadius = 10.0
        self.Vw_Placehoder.layer.borderWidth = 1.0
        self.Vw_Placehoder.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
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
        self.imageCollectionView.register(UINib(nibName: "CommonImagCVC", bundle: nil), forCellWithReuseIdentifier: "CommonImagCVC")
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }
    
  
    @IBAction func action_Name_Mic(_ sender: UIButton) {
      //  handleMicTap(for: sender, textField: txtFldName, textView: nil) //Prevois btn functionality
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SpeechToTextVC") as? SpeechToTextVC {
            vc.currentActiveTextVw = nil
            vc.currentActiveTextField = txtFldName
            vc.onSaveText = { [weak self] text in
                let incomingText = text.trimmingCharacters(in: .whitespacesAndNewlines)

                if let existingText = self?.txtFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !existingText.isEmpty {
                    self?.txtFldName.text = existingText + " " + incomingText
                } else {
                    self?.txtFldName.text = incomingText
                }
                DispatchQueue.main.async {
                    self?.txtFldName.resignFirstResponder()
                    self?.txtFld_Address.resignFirstResponder()
                    self?.txtVw_Description.resignFirstResponder()
                }
                
               
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func action_address_mic(_ sender: UIButton) {
      //  handleMicTap(for: sender, textField: txtFld_Address, textView: nil)
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SpeechToTextVC") as? SpeechToTextVC {
            vc.currentActiveTextVw = nil
            vc.currentActiveTextField = txtFld_Address
            vc.onSaveText = { [weak self] text in
                if let existingText = self?.txtFld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !existingText.isEmpty {
                    let newText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    self?.txtFld_Address.text = existingText + " " + newText
                } else {
                    self?.txtFld_Address.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                DispatchQueue.main.async {
                    self?.txtFldName.resignFirstResponder()
                    self?.txtFld_Address.resignFirstResponder()
                    self?.txtVw_Description.resignFirstResponder()
                }
                
               
               }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func action_descritpion_mic(_ sender: UIButton) {
       // handleMicTap(for: sender, textField: nil, textView: txtVw_Description)
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SpeechToTextVC") as? SpeechToTextVC {
            vc.currentActiveTextVw = txtVw_Description
            vc.currentActiveTextField = nil
            vc.onSaveText = { [weak self] text in
                if let existingText = self?.txtVw_Description.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !existingText.isEmpty {
                    let newText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    self?.txtVw_Description.text = existingText + " " + newText
                } else {
                    self?.txtVw_Description.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                DispatchQueue.main.async {
                    self?.txtFldName.resignFirstResponder()
                    self?.txtFld_Address.resignFirstResponder()
                    self?.txtVw_Description.resignFirstResponder()
                }
                
               
               }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
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
        currentlyRecordingButton = nil
        currentActiveTextField = nil
        currentActiveTextVw = nil
        speechManager.stopRecording()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func actinon_UploadIMage(_ sender: Any) {
        mediaPicker = MediaPickerManager(presentingVC: self)
        mediaPicker?.showMediaOptions(
            isFromNewAccommodation: true,
            singleImageHandler: { image in
                self.selectedImages.append(image)
                self.imageCollectionView.reloadData()
            },
            multipleImagesHandler: { images in
                print("Selected image: \(images)")
                for img in images{
                    self.selectedImages.append(img)
                }
                self.imageCollectionView.reloadData()
            }
        )
     
    }

    
    @IBAction func action_Save_Hangout(_ sender: Any) {
        currentlyRecordingButton = nil
        currentActiveTextField = nil
        currentActiveTextVw = nil
        speechManager.stopRecording()
        let name = txtFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let address = txtFld_Address.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let location = lbl_Val_Location.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let desc = txtVw_Description.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let firstImage = self.selectedImages.first
       let imageData = firstImage?.jpegData(compressionQuality: 0.8)
          guard validateHangoutFields(
              name: name,
              address: address,
              locationText: location,
              description: desc,
              image: imageData,
              on: self
          ) else {
              return
          }
        self.submitHangout(name: name, address: address, lat: self.latitude ?? 0.0, long: self.longitude ?? 0.0, locationText: location, description: desc, image: imageData)
    }
    
}

extension AddNewPlaceVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImagCVC", for: indexPath) as? CommonImagCVC else {
            return UICollectionViewCell()
        }
        cell.img_Vw.image = selectedImages[indexPath.item]
            cell.delegate = self
            cell.indexPath = indexPath
        return cell
    }

    // Optional: Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 110, height: 100)
    }
}
extension AddNewPlaceVC: CommonImagCVCDelegate {
    func didTapRemove(at indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.item)
        imageCollectionView.reloadData()
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
       // txtFld_Address.text = fullAddress
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

}


extension AddNewPlaceVC{
    func submitHangout(name: String, address: String, lat: Double, long: Double, locationText: String, description: String, image: Data?) {

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
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.submitHangout(name: name, address: address, lat: lat, long: long, locationText: locationText, description: description, image: image) // Retry
                            } else {
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
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
        if selectedImages.count == 0  {
            AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please select at least one image.")
            return false
        }
        return true
    }

}
extension AddNewPlaceVC {
    private func setupSpeechCallbacks() {
        speechManager.onResult = { [weak self] text in
                DispatchQueue.main.async {
                    if self?.btn_Name_mic.tag == 1 {
                            self?.txtFldName.text = text
                      
                    }
                    
                    if self?.btn_Address_mic.tag == 1 {
                            self?.txtFld_Address.text = text
                       
                        
                    }
                    
                    if self?.btn_description_mic.tag == 1 {
                            self?.txtVw_Description.text = text
                    }
                }
            }

            speechManager.onError = { error in
                print("Speech error:", error.localizedDescription)
            }

       
     }
    func setUpTag(){
        self.btn_Name_mic.tag = 0
        self.btn_Address_mic.tag = 0
        self.btn_description_mic.tag = 0
    }
    func handleMicTap(for button: UIButton, textField: UITextField?, textView: UITextView?) {
        // Stop if same button tapped again
        if button == currentlyRecordingButton && button.tag == 1 {
            button.tag = 0
            currentlyRecordingButton = nil
            currentActiveTextField = nil
            currentActiveTextVw = nil
            speechManager.stopRecording()
            button.setImage(UIImage(named: "mic"), for: .normal)
            return
        }

        // If a different mic is already recording
        if let previousButton = currentlyRecordingButton, previousButton != button {
            previousButton.tag = 0
            previousButton.tintColor = .black
            previousButton.setImage(UIImage(named: "mic"), for: .normal)
            speechManager.stopRecording()

            // Add delay before starting new mic
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.setUpTag()
                
                button.setImage(UIImage(named: "mic_selected"), for: .normal)
                self.startRecording(for: button, textField: textField, textView: textView)
            }
        } else {
            // Start new mic directly
            setUpTag()
            button.setImage(UIImage(named: "mic_selected"), for: .normal)
            startRecording(for: button, textField: textField, textView: textView)
        }
    }

    private func startRecording(for button: UIButton, textField: UITextField?, textView: UITextView?) {
        button.tag = 1
        currentlyRecordingButton = button
        button.imageView?.image?.withTintColor(.blue)
        currentActiveTextField = textField
        currentActiveTextVw = textView

        speechManager.startRecording()
    }


}
