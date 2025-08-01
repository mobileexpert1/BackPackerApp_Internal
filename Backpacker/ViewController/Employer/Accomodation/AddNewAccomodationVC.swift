//
//  AddNewAccomodationVC.swift
//  BackpackerHire
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import CoreLocation


class AddNewAccomodationVC: UIViewController {

    @IBOutlet weak var scroolHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var btn_Remove: UIButton!
    @IBOutlet weak var tblVw: UITableView!
    
   // @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var btn_Cancle: UIButton!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var BgVwDescription: UIView!
    @IBOutlet weak var txtVwDescription: UITextView!
    @IBOutlet weak var lbl_description: UILabel!
    
    
    //UploadImage outlets
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var mainBgVw: UIView!
    @IBOutlet weak var lbl_UploadImg: UILabel!
    @IBOutlet weak var placeholderImg: UIImageView!
    @IBOutlet weak var uploadImgVw: UIView!
    var mediaPicker: MediaPickerManager?
    
    @IBOutlet weak var txtFldName: UITextField!
    
    @IBOutlet weak var txtFldPrice: UITextField!
    @IBOutlet weak var headerPrice: UILabel!
    @IBOutlet weak var headerFacilities: UILabel!
    @IBOutlet weak var headerName: UILabel!
    
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var valLocation: UILabel!
    @IBOutlet weak var headerAddress: UILabel!
    @IBOutlet weak var headerLocation: UILabel!
    
    @IBOutlet weak var BgVwName: UIView!
    
    @IBOutlet weak var BgVwLocation: UIView!
    
    @IBOutlet weak var BgVwPrice: UIView!
    @IBOutlet weak var BgVwAddress: UIView!
    var selectedFilterIndexes: Set<Int> = []
    let filterArrya = ["Free Wifi","Swimming Pool","Parking"]
    let viewModel = AccommodationViewModel()
    let viewModelAuth = LogInVM()
    var latitude: Double?
    var longitude: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FacilityTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "FacilityTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        tblVw.isScrollEnabled = false
        tblVw.rowHeight = 30
          tblVw.estimatedRowHeight = 0
          tblVw.tableHeaderView = UIView()
          tblVw.tableFooterView = UIView()
        txtFldAddress.isUserInteractionEnabled = false
          tblVw.reloadData()

          DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
              self.tblVw.layoutIfNeeded()
              self.scroolHeight.constant = self.tblVw.contentSize.height
              self.view.layoutIfNeeded()
          }

        self.setupui()
        self.setUpTxtFlds()
        self.setUPLocationText()
    }
    
    func setUPLocationText(){
        self.valLocation.font = FontManager.inter(.regular, size: 14.0)
        if valLocation.text == "Current Location"{
            valLocation.textColor = UIColor(hex: "#9D9D9D")
        }else{
            valLocation.textColor = UIColor.black
        }
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    private func setupui(){
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.txtVwDescription.delegate = self
        self.lbl_description.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_UploadImg.font = FontManager.inter(.medium, size: 13.0)
        self.BgVwDescription.layer.cornerRadius = 10.0
        self.BgVwDescription.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwDescription.layer.borderWidth = 1.0
        self.uploadedImage.image = UIImage(named: "BgUploadImage")
        self.setUpImagePlacehoder()
        applyGradientButtonStyle(to: self.btn_Save)
        
        headerName.font = FontManager.inter(.medium, size: 14.0)
        headerLocation.font = FontManager.inter(.medium, size: 14.0)
        headerAddress.font = FontManager.inter(.medium, size: 14.0)
        headerFacilities.font = FontManager.inter(.medium, size: 14.0)
        headerPrice.font = FontManager.inter(.medium, size: 14.0)
        
        BgVwName.layer.cornerRadius = 10.0
        BgVwName.layer.borderWidth = 1.0
        BgVwName.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        BgVwName.layer.cornerRadius = 10.0
        BgVwName.layer.borderWidth = 1.0
        BgVwName.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        BgVwName.layer.cornerRadius = 10.0
        BgVwName.layer.borderWidth = 1.0
        BgVwName.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        BgVwName.layer.cornerRadius = 10.0
        BgVwName.layer.borderWidth = 1.0
        BgVwName.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        BgVwName.layer.cornerRadius = 10.0
        BgVwName.layer.borderWidth = 1.0
        BgVwName.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        BgVwLocation.layer.cornerRadius = 10.0
        BgVwLocation.layer.borderWidth = 1.0
        BgVwLocation.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        BgVwAddress.layer.cornerRadius = 10.0
        BgVwAddress.layer.borderWidth = 1.0
        BgVwAddress.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        
        BgVwPrice.layer.cornerRadius = 10.0
        BgVwPrice.layer.borderWidth = 1.0
        BgVwPrice.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        
        
    }
    func setUpTxtFlds(){
        if valLocation.text == "Current Location"{
            valLocation.textColor = UIColor(hex: "#9D9D9D")
        }else{
            valLocation.textColor = UIColor(hex: "#9D9D9D")
        }
        
        txtFldName.attributedPlaceholder = NSAttributedString(
                   string: "Name",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldName.delegate = self
        
        txtFldPrice.attributedPlaceholder = NSAttributedString(
                   string: "Price",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldPrice.delegate = self
        
        
        txtFldAddress.attributedPlaceholder = NSAttributedString(
                   string: "Address",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldAddress.delegate = self
    }
   
   
    
    @IBAction func action_Location(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC {
            settingVC.delegate = self
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
    }
    
    
    func addDottedBorder(to view: UIView, color: UIColor = .black, cornerRadius: CGFloat = 8.0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4] // 4 points drawn, 4 points space
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.frame = view.bounds
        
        // Remove previous if exists
        view.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

        view.layer.addSublayer(shapeLayer)
    }
    
    
    @IBAction func action_Save(_ sender: Any) {
        let trimmedName = txtFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedAddress = txtFldAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedLocationText = valLocation.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedDescription = txtVwDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines)  ?? ""
        let trimmedPrice = txtFldPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imageData = self.uploadedImage.image?.jpegData(compressionQuality: 0.8)
        
        let selectedFacilities = selectedFilterIndexes.compactMap { index in
            return filterArrya.indices.contains(index) ? filterArrya[index] : nil
        }

        let isValid = validateAccommodationFields(
            name: trimmedName,
            address: trimmedAddress,
            locationText: trimmedLocationText,
            description: trimmedDescription,
            price: trimmedPrice,
            facilities: selectedFacilities,
            image: imageData,
            mainImageView: self.uploadedImage,
            on: self
        )

        if isValid {
            self.submitAccommodation(name: trimmedName, address: trimmedAddress, lat: self.latitude ?? 0.0, long: self.longitude ?? 0.0, locationText: trimmedLocationText, description: trimmedDescription, price: trimmedPrice, facilitiesIndexes: selectedFilterIndexes, filterArray: selectedFacilities, image: imageData, mainImageView: self.uploadedImage, on: self)
        }
       

    }
    
    
    @IBAction func action_Cancle(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func action_UploadImage(_ sender: Any) {
        mediaPicker = MediaPickerManager(presentingVC: self)
    mediaPicker?.showMediaOptions { image in
        // Do something with the image
        print("Selected image: \(image)")
    
        self.uploadedImage.image = image
        self.placeholderImg.isHidden = true
        self.lbl_UploadImg.isHidden = true
        self.setUpImagePlacehoder()
       
    }
        
    }
    func setUpImagePlacehoder(){
        if self.uploadedImage.image == UIImage(named: "BgUploadImage"){
            self.uploadedImage.layer.cornerRadius = 0.0
            self.btn_Remove.isHidden = true
            self.btn_Save.isUserInteractionEnabled = true
            self.placeholderImg.isHidden = false
            self.lbl_UploadImg.isHidden = false
        }else{
            self.uploadedImage.layer.cornerRadius = 10.0
            self.btn_Remove.isHidden = false
            self.btn_Save.isUserInteractionEnabled = true
            self.placeholderImg.isHidden = true
            self.lbl_UploadImg.isHidden = true
        }
    }
    @IBAction func action_RemoveImage(_ sender: Any) {
        self.uploadedImage.image = nil
        self.uploadedImage.image = UIImage(named: "BgUploadImage")
        self.setUpImagePlacehoder()
        
    }
}



extension AddNewAccomodationVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArrya.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

             let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityTVC", for: indexPath) as! FacilityTVC
             cell.lblTitle.text = filterArrya[indexPath.row]
             
        if selectedFilterIndexes.contains(indexPath.row) {
            cell.imgCheckBox.image = UIImage(named: "Checkbox2")
        } else {
            cell.imgCheckBox.image = UIImage(named: "Checkbox")
        }
             return cell

     
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                // Toggle selection for filter section
        if selectedFilterIndexes.contains(indexPath.row) {
               selectedFilterIndexes.remove(indexPath.row)
           } else {
               selectedFilterIndexes.insert(indexPath.row)
           }
          
            
        tblVw.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
   
}
extension AddNewAccomodationVC: UITextFieldDelegate, UITextViewDelegate {

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


extension AddNewAccomodationVC : SetLocationDelegate{
    func didSelectLocation(locationName: String, fullAddress: String, coordinate: CLLocationCoordinate2D) {
        valLocation.text = locationName
        txtFldAddress.text = fullAddress
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
       }
}
extension AddNewAccomodationVC {
    func validateAccommodationFields(
        name: String,
        address: String,
        locationText: String,
        description: String,
        price: String,
        facilities: [String],
        image: Data?,
        mainImageView: UIImageView,
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

        if locationText.isEmpty || locationText == "Current Location" {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter location.")
            return false
        }

        if description.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter description.")
            return false
        }

        if price.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter price.")
            return false
        }

        if facilities.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please select at least one facility.")
            return false
        }

        if mainImageView.image == UIImage(named: "BgUploadImage") {
            AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please select an image.")
            return false
        }

        if image == nil {
            AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please select an image.")
            return false
        }

        return true
    }

    func submitAccommodation(
        name: String,
        address: String,
        lat: Double,
        long: Double,
        locationText: String,
        description: String,
        price: String,
        facilitiesIndexes: Set<Int>,
        filterArray: [String],
        image: Data?,
        mainImageView: UIImageView,
        on viewController: UIViewController
    ) {

        // Call API
        viewModel.uploadAccommodation(
            name: name,
            address: address,
            lat: lat,
            long: long,
            locationText: locationText,
            description: description,
            price: price,
            facilities: filterArray,
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
                        AlertManager.showAlert(on: self, title: "Success", message: message ?? "Accomodation uploaded.")
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    }
                case .badRequest:
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.submitAccommodation(name: name, address: address, lat: lat, long: long, locationText: locationText, description: description, price: price, facilitiesIndexes: facilitiesIndexes, filterArray: filterArray, image: image, mainImageView: mainImageView, on: self)
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                    
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.submitAccommodation(name: name, address: address, lat: lat, long: long, locationText: locationText, description: description, price: price, facilitiesIndexes: facilitiesIndexes, filterArray: filterArray, image: image, mainImageView: mainImageView, on: self)
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                    
                    
                case .unauthorizedToken, .methodNotAllowed, .internalServerError:
                    NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                case .unknown:
                    AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }
    }

    
}
