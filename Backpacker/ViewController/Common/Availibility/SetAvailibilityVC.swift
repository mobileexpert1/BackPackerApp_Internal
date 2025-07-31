//
//  SetAvailibilityVC.swift
//  Backpacker
//
//  Created by Mobile on 28/07/25.
//

import UIKit

class SetAvailibilityVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_QuickSetup: UILabel!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var BgVwWuickSetup: UIView!
    @IBOutlet weak var lbl_Main_Header: UILabel!
    var isQuickSetupTapped : Bool = false
    let weekDays = [
            ("Sun", "Sunday"),
            ("Mon", "Monday"),
            ("Tue", "Tuesday"),
            ("Wed", "Wednesday"),
            ("Thu", "Thursday"),
            ("Fri", "Friday"),
            ("Sat", "Saturday")
        ]
    var SlotsList = [DaySlot]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "setupQuickAction")
        self.setSlotDayData()
        self.setUPUI()
        self.setUpTable()
       
        
    }
    func setSlotDayData(){
        SlotsList.append(DaySlot(day: "Sunday", shortDay: "Sun", timeSlots: []))
        SlotsList.append(DaySlot(day: "Monday", shortDay: "Mon", timeSlots: []))
        SlotsList.append(DaySlot(day: "Tuesday", shortDay: "Tue", timeSlots: []))
        SlotsList.append(DaySlot(day: "Wednesday", shortDay: "Wed", timeSlots: []))
        SlotsList.append(DaySlot(day: "Thursday", shortDay: "Thu", timeSlots: []))
        SlotsList.append(DaySlot(day: "Friday", shortDay: "Fri", timeSlots: []))
        SlotsList.append(DaySlot(day: "Saturday", shortDay: "Sat", timeSlots: []))
        
    }

    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func action_QuickSetUp(_ sender: Any) {
      
            UserDefaults.standard.set(true, forKey: "setupQuickAction")
            SlotsList.removeAll()
            SlotsList.append(DaySlot(day: "Sunday", shortDay: "Sun", timeSlots: []))
            SlotsList.append(DaySlot(day: "Monday", shortDay: "Mon", timeSlots: [TimesSlot(startTime: "9:00 AM", endTime: "5:00 PM")]))
            SlotsList.append(DaySlot(day: "Tuesday", shortDay: "Tue", timeSlots: [TimesSlot(startTime: "9:00 AM", endTime: "5:00 PM")]))
            SlotsList.append(DaySlot(day: "Wednesday", shortDay: "Wed", timeSlots: [TimesSlot(startTime: "9:00 AM", endTime: "5:00 PM")]))
            SlotsList.append(DaySlot(day: "Thursday", shortDay: "Thu", timeSlots: [TimesSlot(startTime: "9:00 AM", endTime: "5:00 PM")]))
            SlotsList.append(DaySlot(day: "Friday", shortDay: "Fri", timeSlots: [TimesSlot(startTime: "9:00 AM", endTime: "5:00 PM")]))
            SlotsList.append(DaySlot(day: "Saturday", shortDay: "Sat", timeSlots: []))
        
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func action_setAvailibility(_ sender: Any) {
     
        print("Slot List Data",SlotsList)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension SetAvailibilityVC: UITableViewDelegate, UITableViewDataSource {

    private func setUPUI() {
        self.lbl_Main_Header.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_QuickSetup.font = FontManager.inter(.semiBold, size: 12.0)
        self.BgVwWuickSetup.layer.cornerRadius = 10.0
        self.BgVwWuickSetup.layer.borderColor = UIColor.black.cgColor
        self.BgVwWuickSetup.layer.borderWidth = 1.0
        self.btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16)
        applyGradientButtonStyle(to: self.btn_Save)
    }

    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AvailibilityTVC", bundle: nil), forCellReuseIdentifier: "AvailibilityTVC")
        tableView.separatorStyle = .none
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SlotsList.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailibilityTVC", for: indexPath) as? AvailibilityTVC else {
            return UITableViewCell()
        }//515024
        let isQuickActionSetup = UserDefaults.standard.bool(forKey: "setupQuickAction")
        if isQuickActionSetup == true{
            if indexPath.row != 0 && indexPath.row != 6{
                cell.btn_Switch.isOn = true
                cell.setSlotsOnlyNineToFive(isQuickSetUp: true)
            }
           
        }else{
//            cell.btn_Switch.isOn = false
//            cell.setSlotsOnlyNineToFive(isQuickSetUp: false)
        }
        let isOn =  cell.btn_Switch.isOn
        cell.lbl_ShortDay.text = SlotsList[indexPath.row].shortDay
        cell.lbl_Day.text = SlotsList[indexPath.row].day
        cell.lbl_AvailibityStatus.text = isOn ? "Available" : "Unavailable"
        cell.SlotsList = SlotsList[indexPath.row]
        // Handle toggle
           cell.onToggle = { isOn in
               cell.lbl_AvailibityStatus.text = isOn ? "Available" : "Unavailable"
               // Optional: Animate row height change
               UIView.animate(withDuration: 0.3) {
                   tableView.beginUpdates()
                   tableView.endUpdates()
               }
           }
        cell.onTapAnother = { isAdded in
           print("Another slot added: \(isAdded)")
           // Do something like reload cell or save state
            UIView.animate(withDuration: 0.3) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
        cell.onSlotChanged = { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
          
        }

        
        cell.onSlotValueAdded = { [weak self] newSlot in
            guard let self = self else { return }

            // Find the index of the matching day
            if let index = self.SlotsList.firstIndex(where: {
                $0.day == newSlot.day && $0.shortDay == newSlot.shortDay
            }) {
                // Replace the old slot times with the new ones
                self.SlotsList[index].timeSlots = newSlot.timeSlots
            } else {
                // If not found, add new day slot
                self.SlotsList.append(newSlot)
            }

            print("Updated Slot List:", self.SlotsList)
        }
        return cell
    }
    
}
