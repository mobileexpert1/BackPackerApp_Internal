//
//  SlotTVC.swift
//  Backpacker
//
//  Created by Mobile on 28/07/25.
//

import UIKit

class SlotTVC: UITableViewCell {
    @IBOutlet weak var lbl_timeSlot: UILabel!
    
    @IBOutlet weak var Bg_VwEndTime: UIView!
    @IBOutlet weak var BgVw_StartTime: UIView!
    @IBOutlet weak var Bg_MainVw: UIView!
    @IBOutlet weak var txtFld_EndTime: UITextField!
    @IBOutlet weak var txtFld_StartTime: UITextField!
    @IBOutlet weak var lbl_EndTime: UILabel!
    @IBOutlet weak var lbl_Start_Time: UILabel!
    @IBOutlet weak var vw_Active: UIView!
    var onDelete: (() -> Void)? // Closure to notify deletion
    private var startTimePicker: UIDatePicker?
    private var endTimePicker: UIDatePicker?
    private let timeFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "h:mm a" // Show AM/PM
          formatter.locale = Locale(identifier: "en_US")
          return formatter
      }()
    var onTimeChanged: ((_ startTime: String, _ endTime: String) -> Void)?
    var parentController : UIViewController?
    var SlotsList : DayAvailability?
    override func awakeFromNib() {
           super.awakeFromNib()
           setUpUI()
           configureTimePickers()
       }
    
    @objc private func startTimeChanged(_ sender: UIDatePicker) {
        let newStart = sender.date
        
        // If end time already chosen, validate
        if let endText = txtFld_EndTime.text,
           let endDate = timeFormatter.date(from: endText) {
            
            if Calendar.current.compare(newStart, to: endDate, toGranularity: .minute) == .orderedSame {
                txtFld_StartTime.text = ""
                showValidationAlert(message: "Start time and End time cannot be the same.")
                return
            }
            
            if newStart > endDate {
                txtFld_StartTime.text = ""
                showValidationAlert(message: "Start time must be earlier than End time.")
                return
            }
        }
        
        txtFld_StartTime.text = timeFormatter.string(from: newStart)
        onTimeChanged?(txtFld_StartTime.text ?? "", txtFld_EndTime.text ?? "")
    }

    @objc private func endTimeChanged(_ sender: UIDatePicker) {
        // ✅ Ensure Start Time exists
        guard let startText = txtFld_StartTime.text, !startText.isEmpty,
              let startRaw = timeFormatter.date(from: startText) else {
            txtFld_EndTime.text = ""
            showValidationAlert(message: "Please choose Start Time first.")
            return
        }
        
        let calendar = Calendar.current
        
        // Extract hour/minute only
        let startComponents = calendar.dateComponents([.hour, .minute], from: startRaw)
        let endComponents = calendar.dateComponents([.hour, .minute], from: sender.date)
        
        // Normalize both to "today"
        let today = Date()
        guard let startDate = calendar.date(bySettingHour: startComponents.hour ?? 0,
                                            minute: startComponents.minute ?? 0,
                                            second: 0, of: today),
              let endDate = calendar.date(bySettingHour: endComponents.hour ?? 0,
                                          minute: endComponents.minute ?? 0,
                                          second: 0, of: today) else {
            return
        }
        
        // 1️⃣ Same time
        if calendar.isDate(startDate, equalTo: endDate, toGranularity: .minute) {
            txtFld_EndTime.text = ""
            showValidationAlert(message: "Start time and End time cannot be the same.")
            return
        }
        
        // 2️⃣ End must be later
        if endDate < startDate {
            txtFld_EndTime.text = ""
            showValidationAlert(message: "End time must be later than Start time.")
            return
        }
        
        // ✅ Valid case
        txtFld_EndTime.text = timeFormatter.string(from: sender.date)
        onTimeChanged?(txtFld_StartTime.text ?? "", txtFld_EndTime.text ?? "")
    }




       @objc private func doneButtonTapped() {
           txtFld_StartTime.resignFirstResponder()
           txtFld_EndTime.resignFirstResponder()
       }
       
    @IBAction func action_cross(_ sender: Any) {
        onDelete?()
    }
   

    private func showValidationAlert(message: String) {
        guard let vc = parentController else { return }  // make sure parent exists
        let alert = UIAlertController(title: "Invalid Time",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true)
    }

}


extension SlotTVC {
    
    func setUpUI() {
        Bg_MainVw.layer.cornerRadius = 10.0
        Bg_MainVw.layer.borderColor = UIColor(hex: "#B7B7B7").cgColor
        Bg_MainVw.layer.borderWidth = 0.8
        
        BgVw_StartTime.layer.cornerRadius = 8.0
        BgVw_StartTime.layer.borderColor = UIColor(hex: "#B7B7B7").cgColor
        BgVw_StartTime.layer.borderWidth = 0.7
        
        Bg_VwEndTime.layer.cornerRadius = 8.0
        Bg_VwEndTime.layer.borderColor = UIColor(hex: "#B7B7B7").cgColor
        Bg_VwEndTime.layer.borderWidth = 0.7
        
        lbl_timeSlot.font = FontManager.inter(.medium, size: 14.0)
        lbl_Start_Time.font = FontManager.inter(.medium, size: 12.0)
        lbl_EndTime.font = FontManager.inter(.medium, size: 12.0)
    }
    

    
    func configureTimePickers() {
        let startPicker = createTimePicker(selector: #selector(startTimeChanged(_:)))
        txtFld_StartTime.inputView = startPicker
        txtFld_StartTime.inputAccessoryView = createToolbar(for: txtFld_StartTime)

        let endPicker = createTimePicker(selector: #selector(endTimeChanged(_:)))
        txtFld_EndTime.inputView = endPicker
        txtFld_EndTime.inputAccessoryView = createToolbar(for: txtFld_EndTime)
    }
    
    private func createTimePicker(selector: Selector) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "en_US") // Show AM/PM
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 5
        picker.addTarget(self, action: selector, for: .valueChanged)
        
        // Set minimum and maximum time: 9:00 AM to 5:00 PM
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        picker.minimumDate = calendar.date(from: components)
        components.hour = 17
        components.minute = 0
        picker.maximumDate = calendar.date(from: components)
        
        return picker
    }
    
    private func createToolbar(for textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        done.tintColor = UIColor.systemBlue
        
        toolbar.setItems([flex, done], animated: false)
        return toolbar
    }

}
