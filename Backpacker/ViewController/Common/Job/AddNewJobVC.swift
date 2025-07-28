//
//  AddNewJobVC.swift
//  BackpackerHire
//
//  Created by Mobile on 28/07/25.
//

import UIKit
import CoreLocation
class AddNewJobVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var Main_Header: UILabel!
    
    @IBOutlet weak var header_Name: UILabel!
    
    @IBOutlet weak var btn_Remove: UIButton!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var BgVwName: UIView!
    
    
    @IBOutlet weak var header_Address: UILabel!
    
    @IBOutlet weak var BgVw_Address: UIView!
    
    @IBOutlet weak var txtFd_EndTine: UITextField!
    @IBOutlet weak var header_description: UILabel!
    @IBOutlet weak var txtFldAddress: UITextField!
    
    @IBOutlet weak var BgVw_AssignBackPacker: UIView!
    @IBOutlet weak var header_AssinBackpacker: UILabel!
    @IBOutlet weak var BgVw_Date: UIView!
    @IBOutlet weak var header_Date: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var BgVwLocation: UIView!
    @IBOutlet weak var header_Location: UILabel!
    @IBOutlet weak var BgVwEndTime: UIView!
    @IBOutlet weak var header_EndTime: UILabel!
    @IBOutlet weak var txtFld_StartTime: UITextField!
    @IBOutlet weak var BgVwStatrTime: UIView!
    @IBOutlet weak var headerStartTime: UILabel!
    @IBOutlet weak var txtFdDate: UITextField!
  
    @IBOutlet weak var BtnAssignBackPacker: UIButton!
    @IBOutlet weak var Btn_Cancle: UIButton!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var lbl_UploadImage: UILabel!
    @IBOutlet weak var placeHolderImg: UIImageView!
    @IBOutlet weak var bgVwPlacehder: UIView!
    @IBOutlet weak var main_ImgVw: UIImageView!
    @IBOutlet weak var bgVw_MainImge: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var BgVwlistHeight: NSLayoutConstraint!
    @IBOutlet weak var BgVw_listTable: UIView!
    @IBOutlet weak var heder_Date: UILabel!
    @IBOutlet weak var txtFld_Rate: UITextField!
    @IBOutlet weak var BgVwRate: UIView!
    @IBOutlet weak var header_Rate: UILabel!
    @IBOutlet weak var txtFld_Requirment: UITextField!
    @IBOutlet weak var BgVw_Reqirment: UIView!
    @IBOutlet weak var header_Requirment: UILabel!
    @IBOutlet weak var txtVw_Description: UITextView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var BgVwDescription: UIView!
    @IBOutlet weak var BgVwDate: UIView!
    @IBOutlet weak var txtFld_Backpacker: UITextField!
    private var datePicker: UIDatePicker!
    let BackPackerList = [
        "Leo",
        "Sam",
        "William",
        "Samson",
        "Joe",
        "Raymon","Scott"
    ]
    var mediaPicker: MediaPickerManager?
    private var timePicker: UIDatePicker!
    private var activeTextField: UITextField?
    private var oldDate: Date = Date() // Replace with your existing date
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        setupTimePicker()
        self.setupDatePicker()
        self.UpdateLocationTxtColor()
        // Do any additional setup after loading the view.
    }
 
    @IBAction func action_SetLoctaion(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC {
            settingVC.delegate = self
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
        
        
    }
   
    
    @IBAction func action_Remove(_ sender: Any) {
        self.main_ImgVw.image = nil
        self.main_ImgVw.image = UIImage(named: "BgUploadImage")
        self.setUpImagePlacehoder()
    }
    @IBAction func action_AssignBackpacker(_ sender: Any) {
        
        if self.BtnAssignBackPacker.tag == 0{
            self.BtnAssignBackPacker.tag = 1
        }else{
            self.BtnAssignBackPacker.tag = 0
        }
     
        self.ManageTableHeight()
    }
    
    @IBAction func action_Dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func action_UploadImage(_ sender: Any) {
        mediaPicker = MediaPickerManager(presentingVC: self)
    mediaPicker?.showMediaOptions { image in
        // Do something with the image
        print("Selected image: \(image)")
        self.main_ImgVw.image = image
        self.placeHolderImg.isHidden = true
        self.lbl_UploadImage.isHidden = true
        self.setUpImagePlacehoder()
    }
       
    }
}


extension AddNewJobVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BackPackerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportIssueTVC", for: indexPath) as? ReportIssueTVC else {
            return UITableViewCell()
        }

        let item = BackPackerList[indexPath.row]
        
        // Assuming you have a UILabel called lbl_title in ReportIssueTVC
        cell.lbl_Issue.text = item

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIssue = BackPackerList[indexPath.row]
            print("Selected issue: \(selectedIssue)")
        self.txtFld_Backpacker.text = selectedIssue
        self.BtnAssignBackPacker.tag = 0
        self.ManageTableHeight()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}


extension AddNewJobVC : UITextFieldDelegate,UITextViewDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
          activeTextField = textField
      }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder() // hide keyboard
          return true
      }

      func textView(_ textView: UITextView,
                    shouldChangeTextIn range: NSRange,
                    replacementText text: String) -> Bool {
          if text == "\n" { // Detect "return" key
              textView.resignFirstResponder() // hide keyboard
              return false
          }
          return true
      }
}
extension AddNewJobVC : SetLocationDelegate{
    func didSelectLocation(locationName: String, fullAddress: String, coordinate: CLLocationCoordinate2D) {
        let Address = "\(locationName), \(fullAddress)"
        self.lbl_Location.text = Address
        self.UpdateLocationTxtColor()
           print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")
       }
}


extension AddNewJobVC {
    func setupDatePicker() {
           // 1. Initialize date picker
           datePicker = UIDatePicker()
           datePicker.datePickerMode = .date
           datePicker.preferredDatePickerStyle = .inline // shows calendar-style
           datePicker.date = oldDate // <-- set your old date here

           // 2. Toolbar with Done button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicker))
           let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([flex, done], animated: false)

           // 3. Assign to inputView & inputAccessoryView
        txtFdDate.inputView = datePicker
        txtFdDate.inputAccessoryView = toolbar

           // 4. (Optional) Show formatted default in the text field
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
        txtFdDate.text = formatter.string(from: oldDate)
       }

       @objc func doneDatePicker() {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy" // <-- your desired format
           txtFdDate.text = formatter.string(from: datePicker.date)
           txtFdDate.resignFirstResponder()
       }
    func setupTimePicker() {
            // 1. Create and configure UIDatePicker
            timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.preferredDatePickerStyle = .wheels // Shows from bottom
            timePicker.locale = Locale(identifier: "en_US") // 24-hour or "en_US" for AM/PM
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([flexSpace, doneButton], animated: false)
        // Assign picker and toolbar to both text fields
        txtFld_StartTime.inputView = timePicker
        txtFd_EndTine.inputView = timePicker

        txtFld_StartTime.inputAccessoryView = toolbar
        txtFd_EndTine.inputAccessoryView = toolbar
        }

  

      @objc func doneTapped() {
          let formatter = DateFormatter()
          formatter.timeStyle = .short
          
          if let field = activeTextField {
              field.text = formatter.string(from: timePicker.date)
              field.resignFirstResponder()
          }
      }
    private func setUpUI(){
        self.main_ImgVw.image = UIImage(named: "BgUploadImage")
        self.setUpImagePlacehoder()
        self.Main_Header.font = FontManager.inter(.semiBold, size: 16.0)
        lbl_Location.font = FontManager.inter(.medium, size: 13)
        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.BtnAssignBackPacker.tag = 0
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.header_Name.font = FontManager.inter(.medium, size: 14.0)
        self.BgVwName.layer.cornerRadius = 10.0
        self.BgVwName.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwName.layer.borderWidth = 1.0
        
        self.header_Address.font = FontManager.inter(.medium, size: 14.0)
        self.BgVw_Address.layer.cornerRadius = 10.0
        self.BgVw_Address.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVw_Address.layer.borderWidth = 1.0
        
        self.header_description.font = FontManager.inter(.medium, size: 14.0)
        self.BgVwDescription.layer.cornerRadius = 10.0
        self.BgVwDescription.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwDescription.layer.borderWidth = 1.0
        
        self.header_Requirment.font = FontManager.inter(.medium, size: 14.0)
        self.BgVw_Reqirment.layer.cornerRadius = 10.0
        self.BgVw_Reqirment.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVw_Reqirment.layer.borderWidth = 1.0
        
        self.header_Rate.font = FontManager.inter(.medium, size: 14.0)
        self.BgVwRate.layer.cornerRadius = 10.0
        self.BgVwRate.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwRate.layer.borderWidth = 1.0
        
        self.headerStartTime.font = FontManager.inter(.medium, size: 14.0)
        self.BgVwStatrTime.layer.cornerRadius = 10.0
        self.BgVwStatrTime.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwStatrTime.layer.borderWidth = 1.0
        
        self.header_EndTime.font = FontManager.inter(.medium, size: 14.0)
        self.BgVwEndTime.layer.cornerRadius = 10.0
        self.BgVwEndTime.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwEndTime.layer.borderWidth = 1.0
        
        
        self.header_Location.font = FontManager.inter(.medium, size: 14.0)
        self.BgVwLocation.layer.cornerRadius = 10.0
        self.BgVwLocation.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwLocation.layer.borderWidth = 1.0
        
        
        self.header_AssinBackpacker.font = FontManager.inter(.medium, size: 14.0)
        self.BgVw_AssignBackPacker.layer.cornerRadius = 10.0
        self.BgVw_AssignBackPacker.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVw_AssignBackPacker.layer.borderWidth = 1.0
        
        lbl_UploadImage.font = FontManager.inter(.medium, size: 13.0)
        applyGradientButtonStyle(to: self.btn_Save)
        self.BgVwDate.layer.cornerRadius = 10.0
        self.BgVwDate.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwDate.layer.borderWidth = 1.0
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16)
        self.Btn_Cancle.titleLabel?.font = FontManager.inter(.medium, size: 16)
        self.ManageTableHeight()
        self.setUpTxtFlds()
    }
    private func setUpTxtFlds(){
        self.txtFld_Backpacker.isUserInteractionEnabled = false
        txtFldName.attributedPlaceholder = NSAttributedString(
                   string: "Name",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldName.delegate = self
        txtFldAddress.attributedPlaceholder = NSAttributedString(
                   string: "Address",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldAddress.delegate = self
        
        txtFld_Requirment.attributedPlaceholder = NSAttributedString(
                   string: "Requirment",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFld_Requirment.delegate = self
        txtFld_Rate.attributedPlaceholder = NSAttributedString(
                   string: "Rate per hour",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFld_Rate.delegate = self
        
        txtFdDate.attributedPlaceholder = NSAttributedString(
                   string: "Date",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFdDate.delegate = self
        txtFld_StartTime.attributedPlaceholder = NSAttributedString(
                   string: "Start Time",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFld_StartTime.delegate = self
        txtFd_EndTine.attributedPlaceholder = NSAttributedString(
                   string: "End Time",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFd_EndTine.delegate = self
        txtFld_Backpacker.attributedPlaceholder = NSAttributedString(
                   string: "Select Backpacker",
                   attributes: [
                    .foregroundColor: UIColor(hex: "#9D9D9D"),
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        txtFld_Backpacker.isUserInteractionEnabled = false
        txtFld_Backpacker.delegate = self
        txtVw_Description.delegate = self
            self.UpdateLocationTxtColor()
       
    }
    func setUpImagePlacehoder(){
        if self.main_ImgVw.image == UIImage(named: "BgUploadImage"){
            self.main_ImgVw.layer.cornerRadius = 0.0
            self.btn_Remove.isHidden = true
            self.btn_Remove.isUserInteractionEnabled = false
            self.placeHolderImg.isHidden = false
            self.lbl_UploadImage.isHidden = false
        }else{
            self.main_ImgVw.layer.cornerRadius = 10.0
            self.btn_Remove.isHidden = false
            self.btn_Remove.isUserInteractionEnabled = true
            self.placeHolderImg.isHidden = true
            self.lbl_UploadImage.isHidden = true
        }
    }
    private func UpdateLocationTxtColor(){
        self.lbl_Location.font = FontManager.inter(.regular, size: 14.0)
        if lbl_Location.text == "Current Location"{
            self.lbl_Location.textColor = UIColor(hex: "#9D9D9D")
        }else{
            self.lbl_Location.textColor = UIColor.black
        }
    }
    private func ManageTableHeight(){
        if self.BtnAssignBackPacker.tag == 0{
            self.BgVw_listTable.isHidden = true
            self.BgVw_listTable.layer.cornerRadius  = 0
            self.tblHeight.constant = 0
            self.BgVwlistHeight.constant = 0.0
        } else{
            self.BgVw_listTable.isHidden = false
            self.BgVw_listTable.layer.cornerRadius  = 10.0
            self.BgVw_listTable.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
            self.BgVw_listTable.layer.borderWidth = 1.0
            self.tblHeight.constant = 200
            self.BgVwlistHeight.constant = 190
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
}
