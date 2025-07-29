//
//  AvailibilityTVC.swift
//  Backpacker
//
//  Created by Mobile on 28/07/25.
//

import UIKit

class AvailibilityTVC: UITableViewCell {
    
    @IBOutlet weak var BgVw_AnotherSlot: UIView!
    
    @IBOutlet weak var img_DrpDown: UIImageView!
    @IBOutlet weak var btn_Switch: UISwitch!
    @IBOutlet weak var BgVw_Main_Cell: UIView!
    
    @IBOutlet weak var table_VW: UITableView!
    @IBOutlet weak var lbl_AvailibityStatus: UILabel!
    @IBOutlet weak var lbl_Day: UILabel!
    @IBOutlet weak var lbl_ShortDay: UILabel!
    @IBOutlet weak var BgVw_Day: UIView!
    
    @IBOutlet weak var VwAnotherSlot_Height: NSLayoutConstraint!
    @IBOutlet weak var Bg_Vw_Table: UIView!
    
    @IBOutlet weak var Ve_TableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btn_AnotherSlot: UIButton!
    @IBOutlet weak var height_Table: NSLayoutConstraint!
    var onToggle: ((Bool) -> Void)?  // Callback to controller
    var onTapAnother: ((Bool) -> Void)?  // Callback to controller
    var slots: [Int] = []              // Active slot numbers
    
    var onSlotChanged: (() -> Void)? // Notify VC when slot added/deleted
    var onSlotValueAdded: ((DaySlot) -> Void)? // Notify VC when slot added/deleted
    var SlotsList : DaySlot?
    var isQuickSetupIsOn : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
        table_VW.delegate = self
        table_VW.dataSource = self
        table_VW.separatorStyle = .none
        table_VW.register(UINib(nibName: "SlotTVC", bundle: nil), forCellReuseIdentifier: "SlotTVC")
        table_VW.isScrollEnabled = false
        table_VW.separatorStyle = .none
        btn_Switch.isOn = false
        Bg_Vw_Table.isHidden = true
        btn_Switch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        self.handleTableHeight(istoogle: btn_Switch.isOn)
        self.VwAnotherSlot_Height.constant = 0.0
        self.btn_AnotherSlot.titleLabel?.font = FontManager.inter(.semiBold, size: 12.0)
        self.btn_AnotherSlot.isHidden = true
        self.btn_AnotherSlot.isUserInteractionEnabled = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
    
    func setSlotsOnlyNineToFive(isQuickSetUp : Bool = false){
        if isQuickSetUp == true{
            handleTableHeight(istoogle: false)
            self.VwAnotherSlot_Height.constant =  0.0
            self.btn_AnotherSlot.isHidden = true
            setUpBgColor()
        }
    }
    
    @objc func switchToggled() {
        let isQuickActionSetup = UserDefaults.standard.bool(forKey: "setupQuickAction")
        if isQuickActionSetup == false{
            if btn_Switch.isOn == false {
                self.onSlotValueAdded?(
                    DaySlot(
                        day: self.SlotsList?.day ?? "",
                        shortDay: self.SlotsList?.shortDay ?? "",
                        timeSlots: []
                    )
                )
                self.SlotsList?.timeSlots.removeAll()
                self.SetUpToggleAction()
            }else{
                self.SlotsList?.timeSlots.removeAll()
                SetUpToggleAction()
            }
           
        }else{
            UserDefaults.standard.set(false, forKey: "setupQuickAction")
            self.onSlotValueAdded?(
                DaySlot(
                    day: self.SlotsList?.day ?? "",
                    shortDay: self.SlotsList?.shortDay ?? "",
                    timeSlots: []
                )
            )
            self.SetUpToggleAction()
        }
        
        
    }
   
    
    func SetUpToggleAction(){
        let isOn = btn_Switch.isOn
        BgVw_Day.backgroundColor = isOn ? UIColor(hex: "#D8EEFF") : UIColor(hex: "#EAEAEA")
        BgVw_Day.layer.borderColor = isOn ? UIColor(hex: "#299EF5").cgColor : UIColor.clear.cgColor
        BgVw_Day.layer.borderWidth = isOn ? 0.5 : 0.0
        self.lbl_ShortDay.textColor = isOn ? UIColor(hex: "#299EF5"): UIColor(hex: "#B3B3B3")
        self.lbl_ShortDay.font = isOn ? FontManager.inter(.semiBold, size: 10): FontManager.inter(.semiBold, size: 9)
        self.VwAnotherSlot_Height.constant = isOn ? 45 : 0.0
        self.btn_AnotherSlot.isHidden = isOn ? false : true
        self.btn_AnotherSlot.isUserInteractionEnabled = isOn ? true : false
        handleTableHeight(istoogle: isOn ? true : false)
        
        onToggle?(isOn)
    }
    
    
    func setUpBgColor(){
        BgVw_Day.backgroundColor = UIColor(hex: "#D8EEFF")
        BgVw_Day.layer.borderColor = UIColor(hex: "#299EF5").cgColor
        BgVw_Day.layer.borderWidth = 0.5
        self.lbl_ShortDay.textColor = UIColor(hex: "#299EF5")
        self.lbl_ShortDay.font = FontManager.inter(.semiBold, size: 10)
    }
    @IBAction func action_AddAnotherSlot(_ sender: Any) {
        // Show the "AnotherSlot" view
           BgVw_AnotherSlot.isHidden = false
           VwAnotherSlot_Height.constant = 45// Or your desired height

           // Update day background just like switch
           BgVw_Day.backgroundColor = UIColor(hex: "#D8EEFF")
           BgVw_Day.layer.borderColor = UIColor(hex: "#299EF5").cgColor
           BgVw_Day.layer.borderWidth = 0.5
           self.lbl_ShortDay.textColor = UIColor(hex: "#299EF5")
           self.lbl_ShortDay.font = FontManager.inter(.semiBold, size: 10)

           // Show the time table
         Bg_Vw_Table.isHidden = false
        guard let count = self.SlotsList?.timeSlots.count, count < 3 else { return }

        // Append an empty slot
        self.SlotsList?.timeSlots.append(TimesSlot(startTime: "", endTime: ""))

         // table_VW.reloadData()
          
        if  self.SlotsList?.timeSlots.count == 3 {
            self.VwAnotherSlot_Height.constant = 0.0
            BgVw_AnotherSlot.isHidden = true
        }else{
            BgVw_AnotherSlot.isHidden = false
            VwAnotherSlot_Height.constant = 45// Or your desired height
        }
        handleTableHeight(istoogle: true)
           onTapAnother?(true)
    }
    
   }
extension AvailibilityTVC {
    
    func setUpUi(){
        self.BgVw_Main_Cell.layer.cornerRadius = 10.0
        self.BgVw_Main_Cell.addShadowAllSides(radius: 2.0)
        self.lbl_ShortDay.font = FontManager.inter(.semiBold, size: 9)
        self.lbl_Day.font = FontManager.inter(.semiBold, size: 12)
        self.lbl_AvailibityStatus.font = FontManager.inter(.regular, size: 12)
    }
    func removeDottedBorder(from view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0.name == "DottedBorder" })
    }
    func handleTableHeight(istoogle: Bool = false) {
        if istoogle {
            table_VW.reloadData()
            table_VW.layoutIfNeeded()
            height_Table.constant = table_VW.contentSize.height
            Ve_TableHeight.constant = height_Table.constant + 10
        } else {
            height_Table.constant = 0
            Ve_TableHeight.constant = 0
        }
    }

    

}
extension AvailibilityTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SlotsList?.timeSlots.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlotTVC", for: indexPath) as? SlotTVC else {
                return UITableViewCell()
            }

            let row = indexPath.row + 1
        cell.lbl_timeSlot.text = "Time Slot \(row)"
        cell.onTimeChanged = { [weak self] start, end in
            guard let self = self else { return }
            guard var slotsList = self.SlotsList else { return }
            
            // Update the correct index, not append
            if row < slotsList.timeSlots.count {
                self.SlotsList?.timeSlots[row].startTime = start
                self.SlotsList?.timeSlots[row].endTime = end
            } else {
                let timeSlot = TimesSlot(startTime: start, endTime: end)
                self.SlotsList?.timeSlots.append(timeSlot)
            }
            
            self.onSlotValueAdded?(
                DaySlot(
                    day: self.SlotsList?.day ?? "",
                    shortDay: self.SlotsList?.shortDay ?? "",
                    timeSlots: self.SlotsList?.timeSlots ?? []
                )
            )
        }

       
            // Use captured index
            cell.onDelete = { [weak self] in
                guard let self = self else { return }
                self.SlotsList?.timeSlots.remove(at: row - 1)
                if self.SlotsList?.timeSlots.count == 3 {
                    self.VwAnotherSlot_Height.constant = 0.0
                    BgVw_AnotherSlot.isHidden = true
                }else{
                    BgVw_AnotherSlot.isHidden = false
                    VwAnotherSlot_Height.constant = 45// Or your desired height
                }
                table_VW.reloadData()
                self.height_Table.constant = tableView.contentSize.height
                self.Ve_TableHeight.constant = tableView.contentSize.height + 10
                self.onSlotChanged?()
                
            }

            return cell
    }

}

struct TimesSlot {
    var startTime : String
    var endTime : String
}

struct DaySlot {
    
    var day : String
    var shortDay : String
    var timeSlots : [TimesSlot]
    
}
