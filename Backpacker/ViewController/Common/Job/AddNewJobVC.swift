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
    var startDate = String()
    var endDate = String()
    var latitude = Double()
    var longitude = Double()
    let viewModelAuth = LogInVM()
    let viewModel = JobVM()
    var  selectedBackpackerData : [Backpacker] = []
    //Mic Outlets
    let speechManager = SpeechToTextManager()
    var currentActiveTextField: UITextField?
    var currentActiveTextVw: UITextView?
    var currentlyRecordingButton: UIButton?
    @IBOutlet weak var btn_name_Mic: UIButton!
    
    @IBOutlet weak var btn_requirmentMic: UIButton!
    @IBOutlet weak var btn_descritpion_mic: UIButton!
    @IBOutlet weak var btn_adress_mic: UIButton!
    var selectedBackPackerList: [BackpackerIdWrapper] = []
    var selectedBackPackerJSONString: String?

    @IBOutlet weak var btn_Mic: UIButton!
    //Edit
    var jobID : String?
    var isComeFromEdit : Bool = false
    var editName : String?
    var editHeadAddress : String?
    var editdescription : String?
    var editrequirment : String?
    var editrate : String?
    var editDate : String?
    var editEndDate : String?
    var editStartTime : String?
    var editEndTime : String?
    var editLocation : String?
    var removedImages : String?
    var editImagess : String?
    var editImageData: UIImage?
    var editLat : Double?
    var editLongitude : Double?
    var editBackPackersList : [JobRequest]?
    
    var selectedStatDate : Date?
    var selectedEndDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setupSpeechCallbacks()
        setupTimePicker()
        self.UpdateLocationTxtColor()
        self.setUpEditData()
        self.btn_Mic.tag = 0
        self.btn_Mic.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action_MicCommon(_ sender: UIButton) {
        if btn_Mic.tag == 0{
            btn_Mic.tag = 1
        }else{
            btn_Mic.tag = 0
        }
        self.setTxtFieldFocus()
    }
    
    
    private func setTxtFieldFocus(){
        if btn_Mic.tag == 1 {
            speechManager.startRecording()
            if txtFldName.text?.isEmpty ?? true {
                txtFldName.becomeFirstResponder()
            }
           else if txtFldAddress.text?.isEmpty ?? true {
                txtFldAddress.becomeFirstResponder()
            }
            else if txtVw_Description.text?.isEmpty ?? true {
                txtVw_Description.becomeFirstResponder()
            }
            else if txtFld_Requirment.text?.isEmpty ?? true {
                txtFld_Requirment.becomeFirstResponder()
            } else{
                txtFldName.becomeFirstResponder()
            }
        }else{
            speechManager.stopRecording()
            txtFldName.resignFirstResponder()
            txtVw_Description.resignFirstResponder()
            txtFld_Requirment.resignFirstResponder()
            txtFldAddress.resignFirstResponder()
        }
        }
    
    private func setUpEditData(){
        if isComeFromEdit == true{
            self.txtFldName.text = editName
            self.txtFldAddress.text = editHeadAddress
            self.txtVw_Description.text = editdescription
            self.txtFld_Requirment.text = editrequirment
            if let rate = editrate{
                self.txtFld_Rate.text = "$\(rate)"
            }
            if let date = editDate {
                if editEndDate != editDate, let end = editEndDate {
                    self.txtFdDate.text = formatDate(date) + " - " + formatDate(end)
                } else {
                    self.txtFdDate.text = formatDate(date)  // just single date
                }
            }

            self.txtFld_StartTime.text = editStartTime
            self.txtFd_EndTine.text = editEndTime
            self.lbl_Location.text = editLocation
            self.latitude = editLat ?? 0.0
            self.longitude = editLongitude ?? 0.0
            if let backpackers = editBackPackersList {
                let names = backpackers.map { $0.backpackerId.name }
                self.txtFld_Backpacker.text = names.joined(separator: ", ")
            }

            if let image = self.editImageData {
                self.main_ImgVw.image = image
                self.placeHolderImg.isHidden = true
                self.lbl_UploadImage.isHidden = true
                self.setUpImagePlacehoder()
            }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let editDate = editDate,
               let strtdate = formatter.date(from: editDate) {
                self.selectedStatDate = strtdate
                self.startDate = dateToString(strtdate)
            }

            if let editEndDate = editEndDate,
               let endDate = formatter.date(from: editEndDate) {
                self.selectedEndDate = endDate
                self.endDate = dateToString(endDate)
            }
           
        }
    }
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    @IBAction func action_SetLoctaion(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC {
            settingVC.delegate = self
            if isComeFromEdit == true {
                settingVC.initialCoordinate = CLLocationCoordinate2D(latitude: self.editLat ?? 0.0, longitude: self.editLongitude ?? 0.0)
            }
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
        
        
    }
    
    
    @IBAction func action_Remove(_ sender: Any) {
        if isComeFromEdit == true{
            self.removedImages = self.editImagess
            self.main_ImgVw.image = nil
            self.main_ImgVw.image = UIImage(named: "BgUploadImage")
            self.setUpImagePlacehoder()
        }else{
            self.main_ImgVw.image = nil
            self.main_ImgVw.image = UIImage(named: "BgUploadImage")
            self.setUpImagePlacehoder()
            
        }
       
    }
    @IBAction func action_AssignBackpacker(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        if let sarchVC = storyboard.instantiateViewController(withIdentifier: "CommonSearchVC") as? CommonSearchVC {
            if isComeFromEdit, let editList = editBackPackersList {
                for back in editList {
                    let obj = Backpacker(
                        id: back.backpackerId.id,   // adjust: confirm if `bac` is actually the ID
                        name:  "", // use JobRequest’s real property
                        email:  "",
                        countryCode:  "",
                        countryName:  "",
                        mobileNumber: "",
                        jobsCount:  0,
                        rating: 0
                    )
                    self.selectedBackpackerData.append(obj)
                }
            }
            sarchVC.selectedData = self.selectedBackpackerData
            sarchVC.delegate = self
            self.navigationController?.pushViewController(sarchVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
    }
    
    @IBAction func action_Dismiss(_ sender: Any) {
        currentlyRecordingButton = nil
        currentActiveTextField = nil
        currentActiveTextVw = nil
        speechManager.stopRecording()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func action_UploadImage(_ sender: Any) {
        mediaPicker = MediaPickerManager(presentingVC: self)
        mediaPicker?.showMediaOptions(isFromNewAccommodation: false) { image in
            print("Selected image: \(image)")
            
            if self.isComeFromEdit == true{
                self.removedImages = self.editImagess
                self.main_ImgVw.image = image
                self.placeHolderImg.isHidden = true
                self.lbl_UploadImage.isHidden = true
                self.setUpImagePlacehoder()
            }else{
                self.main_ImgVw.image = image
                self.placeHolderImg.isHidden = true
                self.lbl_UploadImage.isHidden = true
                self.setUpImagePlacehoder()
            }
            
           
        }
        
    }

    @IBAction func action_ShowCalendarPopUp(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        if let calendarVC = storyboard.instantiateViewController(withIdentifier: "CommonCalendarPopUpVC") as? CommonCalendarPopUpVC {
            let selectedDateVal = convertStringToDate(txtFdDate.text ?? "")
            calendarVC.isComeFromEdit = self.isComeFromEdit
            if isComeFromEdit == true{
                if selectedStatDate != selectedEndDate && selectedEndDate != nil {
                    calendarVC.startDate = selectedStatDate
                    calendarVC.endDate = selectedEndDate
                    calendarVC.selectedDate = nil
                }else{
                    calendarVC.selectedDate = selectedDateVal
                }
            }else{
                calendarVC.selectedDate = selectedDateVal
            }
           
            calendarVC.delegate = self
            calendarVC.modalPresentationStyle = .overCurrentContext
            calendarVC.modalTransitionStyle = .crossDissolve
            self.present(calendarVC, animated: true, completion: nil)
        }
        
    }
    func convertStringToDate(_ dateString: String, format: String = "dd/MM/yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }

    @IBAction func Btn_SaveData(_ sender: Any) {
        currentlyRecordingButton = nil
        currentActiveTextField = nil
        currentActiveTextVw = nil
        speechManager.stopRecording()
        let trimmedName = txtFldName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedAddress = txtFldAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedLocationText = lbl_Location.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedDescription = txtVw_Description.text?.trimmingCharacters(in: .whitespacesAndNewlines)  ?? ""
        let trimmedPrice = txtFld_Rate.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let imageData = self.main_ImgVw.image?.jpegData(compressionQuality: 0.8)
        let requiremt = self.txtFld_Requirment.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let startDate = convertDateIfNeeded(self.startDate.trimmingCharacters(in: .whitespacesAndNewlines))
        let endDate   = convertDateIfNeeded(self.endDate.trimmingCharacters(in: .whitespacesAndNewlines))
        
        
        let startTime = self.txtFld_StartTime.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let endTime = self.txtFd_EndTine.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        
        let isValid = validateHangoutFields(name: trimmedName, address: trimmedAddress, locationText: trimmedLocationText, description: trimmedDescription, requirment: requiremt, price: trimmedPrice, strtDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, request: ["iOs","iOS2"], image: imageData, latitude: self.latitude, longitude: self.longitude, on: self)
        
        if isValid {
            if isComeFromEdit == true {
                self.EditJob(name: trimmedName, address: trimmedAddress, locationText: trimmedLocationText, description: trimmedDescription, requirment: requiremt, price: trimmedPrice, strtDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, image: imageData, latitude:  self.latitude, longitude: self.longitude,jobId: self.jobID ?? "")
            }else{
                self.AddNewJob(name: trimmedName, address: trimmedAddress, locationText: trimmedLocationText, description: trimmedDescription, requirment: requiremt, price: trimmedPrice, strtDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, request: [], image: imageData, latitude:  self.latitude, longitude: self.longitude)
            }
           
        }else{
            AlertManager.showAlert(on: self, title: "Missing Field", message: "Please check all fields")
        }
    }
    
    func convertDateIfNeeded(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"   // expected input format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // stable parsing
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"//"dd-MM-yyyy"  // desired output
        
        if let date = inputFormatter.date(from: input) {
            // ✅ valid "dd/MM/yyyy", so convert
            return outputFormatter.string(from: date)
        } else {
            // ❌ not matching format, return original
            return input
        }
    }

    
    @IBAction func action_name_mic(_ sender: UIButton) {
       // handleMicTap(for: sender, textField: txtFldName, textView: nil)
   //
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
                    self?.txtFldAddress.resignFirstResponder()
                    self?.txtVw_Description.resignFirstResponder()
                    self?.txtFldName.resignFirstResponder()
                    self?.txtFld_Requirment.resignFirstResponder()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func action_address_mic(_ sender: UIButton) {
     //   handleMicTap(for: sender, textField: txtFldAddress, textView: nil)
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SpeechToTextVC") as? SpeechToTextVC {
            vc.currentActiveTextVw = nil
            vc.currentActiveTextField = txtFldAddress
            vc.onSaveText = { [weak self] text in
                let incomingText = text.trimmingCharacters(in: .whitespacesAndNewlines)

                if let existingText = self?.txtFldAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !existingText.isEmpty {
                    self?.txtFldAddress.text = existingText + " " + incomingText
                } else {
                    self?.txtFldAddress.text = incomingText
                }
                DispatchQueue.main.async {
                    self?.txtFldAddress.resignFirstResponder()
                    self?.txtVw_Description.resignFirstResponder()
                    self?.txtFldName.resignFirstResponder()
                    self?.txtFld_Requirment.resignFirstResponder()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func action_description_mic(_ sender: UIButton) {
        //handleMicTap(for: sender, textField: nil, textView: txtVw_Description)
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SpeechToTextVC") as? SpeechToTextVC {
            vc.currentActiveTextVw = txtVw_Description
            vc.currentActiveTextField = nil
            vc.onSaveText = { [weak self] text in
                let incomingText = text.trimmingCharacters(in: .whitespacesAndNewlines)

                if let existingText = self?.txtVw_Description.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !existingText.isEmpty {
                    self?.txtVw_Description.text = existingText + " " + incomingText
                } else {
                    self?.txtVw_Description.text = incomingText
                }
                DispatchQueue.main.async {
                    self?.txtFldAddress.resignFirstResponder()
                    self?.txtVw_Description.resignFirstResponder()
                    self?.txtFldName.resignFirstResponder()
                    self?.txtFld_Requirment.resignFirstResponder()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func action_requirment_mic(_ sender: UIButton) {
      //  handleMicTap(for: sender, textField: txtFld_Requirment, textView: nil)
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SpeechToTextVC") as? SpeechToTextVC {
            vc.currentActiveTextVw = nil
            vc.currentActiveTextField = txtFld_Requirment
            vc.onSaveText = { [weak self] text in
                let incomingText = text.trimmingCharacters(in: .whitespacesAndNewlines)

                if let existingText = self?.txtFld_Requirment.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !existingText.isEmpty {
                    self?.txtFld_Requirment.text = existingText + " " + incomingText
                } else {
                    self?.txtFld_Requirment.text = incomingText
                }
                DispatchQueue.main.async {
                    self?.txtFld_Requirment.resignFirstResponder()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
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
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == txtFld_Rate {
            // Current text after the change
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            
            // Always ensure it starts with "$"
            if !currentText.hasPrefix("$") && !currentText.isEmpty {
                textField.text = "$" + currentText.replacingOccurrences(of: "$", with: "")
                return false // we manually updated text
            }
        }
        return true
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Store active text field
        activeTextField = textField

        // Only validate if the tapped field is either start time or end time
        if textField == txtFld_StartTime || textField == txtFd_EndTine {
            if txtFdDate.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                AlertManager.showAlert(on: self, title: "Missing Field", message: "Please select a date first.")
                return false
            }
        }

        return true // allow editing
    }

}
extension AddNewJobVC : SetLocationDelegate{
    func didSelectLocation(locationName: String, fullAddress: String, coordinate: CLLocationCoordinate2D) {
        let Address = "\(locationName), \(fullAddress)"
        self.txtFldAddress.text = locationName
        self.lbl_Location.text = Address
        self.UpdateLocationTxtColor()
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}


extension AddNewJobVC {
    
    func setupTimePicker() {
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels

        // Force 24-hour format using a locale that defaults to 24-hour
        timePicker.locale = Locale(identifier: "en_GB")  // UK uses 24-hour format
        timePicker.calendar = Calendar(identifier: .gregorian)

        // Optional: This ensures the picker updates immediately to 24-hour style
        if #available(iOS 14.0, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)

        txtFld_StartTime.inputView = timePicker
        txtFd_EndTine.inputView = timePicker
        txtFld_StartTime.inputAccessoryView = toolbar
        txtFd_EndTine.inputAccessoryView = toolbar
        txtFld_StartTime.addTarget(self, action: #selector(startTimeEditingBegan), for: .editingDidBegin)
         txtFd_EndTine.addTarget(self, action: #selector(endTimeEditingBegan), for: .editingDidBegin)
     }

     @objc private func startTimeEditingBegan() {
         if let text = txtFld_StartTime.text, !text.isEmpty {
             let formatter = DateFormatter()
             formatter.dateFormat = "HH:mm"  // match your stored format
             if let date = formatter.date(from: text) {
                 timePicker.date = date
             }
         }
     }

     @objc private func endTimeEditingBegan() {
         if let text = txtFd_EndTine.text, !text.isEmpty {
             let formatter = DateFormatter()
             formatter.dateFormat = "HH:mm"
             if let date = formatter.date(from: text) {
                 timePicker.date = date
             }
         }
     }

    @objc func doneTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")

        guard let dateText = txtFdDate.text, !dateText.isEmpty else {
            AlertManager.showAlert(on: self, title: "Alert", message: "Please select a date first.")
            return
        }

        guard let field = activeTextField else { return }
        let selectedTime = formatter.string(from: timePicker.date)

        // Get Date objects for time comparison
        let selectedDate = timePicker.date

        if field == txtFld_StartTime {
            if let endText = txtFd_EndTine.text, !endText.isEmpty,
               let endDate = formatter.date(from: endText) {

                if Calendar.current.isDate(selectedDate, equalTo: endDate, toGranularity: .minute) {
                    AlertManager.showAlert(on: self, title: "Alert", message: "Start time and end time cannot be the same.")
                    return
                }

                if selectedDate > endDate {
                    AlertManager.showAlert(on: self, title: "Alert", message: "Start time cannot be after end time.")
                    return
                }
            }
        } else if field == txtFd_EndTine {
            if let startText = txtFld_StartTime.text, !startText.isEmpty,
               let startDate = formatter.date(from: startText) {

                if Calendar.current.isDate(selectedDate, equalTo: startDate, toGranularity: .minute) {
                    AlertManager.showAlert(on: self, title: "Alert", message: "End time and start time cannot be the same.")
                    return
                }

                if selectedDate < startDate {
                    AlertManager.showAlert(on: self, title: "Alert", message: "End time cannot be before start time.")
                    return
                }
            }
        }

        field.text = selectedTime
        field.resignFirstResponder()
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
extension AddNewJobVC: CommonSearchDelegate {
    
    func didSelectBackpacker(_ backpacker: [Backpacker]) {
        print("Received Backpacker: \(backpacker)")
      
        // Create the array: [{"backpackerId":"..."}]
        self.selectedBackpackerData = backpacker
        let wrappers = backpacker.map { BackpackerIdWrapper(backpackerId: $0.id) }

            // Encode to JSON string
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(wrappers),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                self.selectedBackPackerJSONString = jsonString
            }
        if backpacker.count == 1 {
            let nameOrPhone = backpacker.first?.name.isEmpty == false
                ? backpacker.first?.name
            : backpacker.first?.mobileNumber
            self.txtFld_Backpacker.text = nameOrPhone
        }
        else if backpacker.count > 1 {
            self.txtFld_Backpacker.text = backpacker.map {
                $0.name.isEmpty ? $0.id : $0.name
            }.joined(separator: ", ")
        }
        else {
            self.txtFld_Backpacker.text = ""
        }

    }
    func getSelectedBackpackersJSONString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(selectedBackPackerList)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("❌ Failed to encode backpacker list:", error)
            return nil
        }
    }

    
}
extension AddNewJobVC: CommonCalendarPopUpVCDelegate {
    func calendarDidSelectSingleDate(_ date: Date) {
        print("📌 Received single date:", date)
        let dateselected = "\(dateToString(date))"
        self.startDate = dateToStringhyphen(date)
        self.endDate = dateToStringhyphen(date)
        self.txtFdDate.text = dateselected
        self.selectedEndDate = nil
        self.selectedStatDate = nil
        // Handle single date
    }
    
    func calendarDidSelectRange(startDate: Date, endDate: Date) {
        print("📌 Received range:", startDate, "→", endDate)
        // Handle range
        let combineDate = "\(dateToString(startDate)) - \(dateToString(endDate))"
        self.startDate = dateToStringhyphen(startDate)
            self.endDate = dateToStringhyphen(endDate)
        self.txtFdDate.text = combineDate
        self.selectedEndDate = startDate
        self.selectedStatDate = endDate
    }
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    func dateToStringhyphen(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =   "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

extension AddNewJobVC {
    
    func validateHangoutFields(
        name: String,
        address: String,
        locationText: String,
        description: String,
        requirment: String,
        price: String,
        strtDate: String,
        endDate: String,
        startTime: String,
        endTime: String,
        request: [String],
        image: Data?,
        latitude: Double,
        longitude: Double,
        on viewController: UIViewController
    ) -> Bool {
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter name.")
            return false
        }
        
        if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter address.")
            return false
        }
        
        if locationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || locationText == "Current Location" {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter location.")
            return false
        }
        
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter description.")
            return false
        }
        
        if requirment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter requirement.")
            return false
        }
        
        if price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter price.")
            return false
        }
        
        if strtDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
           endDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please select at least one date (start or end).")
            return false
        }
        
        if startTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter start time.")
            return false
        }
        
        if endTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please enter end time.")
            return false
        }
        
        if request.isEmpty {
            AlertManager.showAlert(on: viewController, title: "Missing Field", message: "Please select at least one request.")
            return false
        }
        
        if isComeFromEdit == true{
            if self.main_ImgVw.image == UIImage(named: "BgUploadImage") || image == nil && editImagess?.isEmpty == true {
                AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please upload a valid image.")
                return false
            }
            
        }else{
            if self.main_ImgVw.image == UIImage(named: "BgUploadImage") || image == nil {
                AlertManager.showAlert(on: viewController, title: "Missing Image", message: "Please upload a valid image.")
                return false
            }
            
        }
        
       
        if latitude == 0.0 || longitude == 0.0 {
            AlertManager.showAlert(on: viewController, title: "Invalid Location", message: "Please select a valid location on map.")
            return false
        }
        
        return true
    }
    
    func AddNewJob(
        name: String,
        address: String,
        locationText: String,
        description: String,
        requirment: String,
        price: String,
        strtDate: String,
        endDate: String,
        startTime: String,
        endTime: String,
        request: [String],
        image: Data?,
        latitude: Double,
        longitude: Double
    ) {
        let image = self.main_ImgVw.image?.jpegData(compressionQuality: 0.8)
        LoaderManager.shared.show()
        let priceWithoutSymbol = price
            .replacingOccurrences(of: "$", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        viewModel.uploadNewJob(name: name, address: address, lat: latitude, long: longitude, locationText: locationText, description: description, requirement: requirment, price: priceWithoutSymbol, startDate: strtDate, endDate: endDate, startTime: startTime, endTime: endTime, selectedBackpackerJSONString: selectedBackPackerJSONString ?? "", image: image) { success, message ,statusCode in
            
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
                        AlertManager.showAlert(on: self, title: "Success", message: message ?? "Job Added."){
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
                            self.AddNewJob(name: name, address: address, locationText: locationText, description: description, requirment: requirment, price: price, strtDate: strtDate, endDate: endDate, startTime: startTime, endTime: endTime, request: request, image: image, latitude: latitude, longitude: longitude)
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
    func EditJob(
        name: String,
        address: String,
        locationText: String,
        description: String,
        requirment: String,
        price: String,
        strtDate: String,
        endDate: String,
        startTime: String,
        endTime: String,
        image: Data?,
        latitude: Double,
        longitude: Double,
        jobId:String
    ) {
        let image = self.main_ImgVw.image?.jpegData(compressionQuality: 0.8)
        LoaderManager.shared.show()
        let priceWithoutSymbol = price
            .replacingOccurrences(of: "$", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.editJob(name: name, address: address, lat: latitude, long: longitude, locationText: locationText, description: description, requirement: requirment, price: priceWithoutSymbol, startDate: strtDate, endDate: endDate, startTime: startTime, endTime: endTime, selectedBackpackerJSONString: selectedBackPackerJSONString ?? "", image: image, jobID: jobId) { success, message ,statusCode in
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
                        AlertManager.showAlert(on: self, title: "Success", message: message ?? "Job Added."){
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
                            self.EditJob(name: name, address: address, locationText: locationText, description: description, requirment: requirment, price: price, strtDate: strtDate, endDate: endDate, startTime: startTime, endTime: endTime, image: image, latitude:  self.latitude, longitude: self.longitude,jobId: self.jobID ?? "")
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
}
extension AddNewJobVC {
    private func setupSpeechCallbacks() {
        speechManager.onResult = { [weak self] text in
                DispatchQueue.main.async {
//                    if self?.btn_name_Mic.tag == 1 {
//                        self?.txtFldName.text = text
//                      
//                    }
//                    
//                    if self?.btn_adress_mic.tag == 1 {
//                        self?.txtFldAddress.text = text
//                       
//                        
//                    }
//                    
//                    if self?.btn_requirmentMic.tag == 1 {
//                        self?.txtFld_Requirment.text = text
//                    }
//                    if self?.btn_descritpion_mic.tag == 1 {
//                        self?.txtVw_Description.text = text
//                    }
                    
                    if self?.txtFldName.isFirstResponder == true {
                        print("Name field is focused")
                        self?.txtFldName.text = text
                    } else if self?.txtFldAddress.isFirstResponder == true {
                        print("Address field is focused")
                        self?.txtFldAddress.text = text
                    } else if self?.txtVw_Description.isFirstResponder == true {
                        print("Description field is focused")
                        self?.txtVw_Description.text = text
                    } else if self?.txtFld_Requirment.isFirstResponder == true {
                        print("Requirement field is focused")
                        self?.txtFld_Requirment.text = text
                    } else {
                        print("No field is focused")
                    }

                    
                }
            }

            speechManager.onError = { error in
                print("Speech error:", error.localizedDescription)
            }

       
     }
    func setUpTag(){
        self.btn_name_Mic.tag = 0
        self.btn_adress_mic.tag = 0
        self.btn_requirmentMic.tag = 0
        self.btn_descritpion_mic.tag = 0
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
struct BackpackerIdWrapper: Codable {
    let backpackerId: String
}
