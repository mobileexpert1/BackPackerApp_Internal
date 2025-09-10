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
    
    
    @IBOutlet weak var btn_AnotherSlot: UIButton!
    @IBOutlet weak var height_Table: NSLayoutConstraint!
    var onToggle: ((Bool) -> Void)?  // Callback to controller
    var onTapAnother: ((Bool) -> Void)?  // Callback to controller
    var slots: [Int] = []              // Active slot numbers
    
    var onSlotChanged: ((_ index: Int) -> Void)? // Pass the slot index

    var onSlotValueAdded: ((DayAvailability) -> Void)? // Notify VC when slot added/deleted
    var SlotsDay : DayAvailability?
    var isQuickSetupIsOn : Bool = false
    var totalHour = 8
    var parentViewController : UIViewController?
    var indexPathRow : Int?
    var onReload: ((_ index: Int) -> Void)? // Pass the slot index
    var isSlotAlreadyAdded : Bool = false
//    var SlotsDay: DayAvailability? {
//        didSet {
//            guard let _ = SlotsDay else { return }
//            table_VW.reloadData()
//            table_VW.layoutIfNeeded() // force height calculation
//            height_Table.constant = table_VW.contentSize.height
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
        table_VW.delegate = self
        table_VW.dataSource = self
        table_VW.separatorStyle = .none
        table_VW.register(UINib(nibName: "SlotTVC", bundle: nil), forCellReuseIdentifier: "SlotTVC")
        table_VW.isScrollEnabled = false
        table_VW.separatorStyle = .none
        table_VW.rowHeight = UITableView.automaticDimension
        table_VW.estimatedRowHeight = 120
       // btn_Switch.isOn = false
        btn_Switch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        self.handleTableHeight(istoogle: btn_Switch.isOn)
        self.VwAnotherSlot_Height.constant = 0.0
        self.btn_AnotherSlot.titleLabel?.font = FontManager.inter(.semiBold, size: 12.0)
        self.btn_AnotherSlot.isHidden = true
        self.btn_AnotherSlot.isUserInteractionEnabled = false
        print("SlotList",SlotsDay?.slots)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear old slots so reused cell won't show previous data
        SlotsDay = nil
        
        // Reset UI
        VwAnotherSlot_Height.constant = 0
        btn_AnotherSlot.isHidden = true
        btn_AnotherSlot.isUserInteractionEnabled = false
        height_Table.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setUpDataAlredyAddedSlot(){
        if isSlotAlreadyAdded ==  true{
            self.table_VW.delegate = self
            self.table_VW.dataSource = self
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
        }
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
                    DayAvailability(day: self.SlotsDay?.day ?? "", enabled: false, slots: [])
                   
                )
                self.SlotsDay?.slots.removeAll()
                self.SetUpToggleAction()
            }else{
                self.SlotsDay?.slots.removeAll()
                SetUpToggleAction()
            }
           
        }else{
            UserDefaults.standard.set(false, forKey: "setupQuickAction")
            self.onSlotValueAdded?(
                DayAvailability(day: self.SlotsDay?.day ?? "", enabled: false, slots: [])
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
        // Check current hours used
           let currentHours = calculateTotalHours()
           
           if currentHours >= totalHour {
               // Already reached 8 hr limit → show alert
               if let vc = self.parentViewController {
                   let alert = UIAlertController(title: "Limit Reached",
                                                 message: "You cannot add more slots as total exceeds \(totalHour) hours.",
                                                 preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default))
                   vc.present(alert, animated: true)
               }
               return
           }
           BgVw_AnotherSlot.isHidden = false
           VwAnotherSlot_Height.constant = 45// Or your desired height

           // Update day background just like switch
           BgVw_Day.backgroundColor = UIColor(hex: "#D8EEFF")
           BgVw_Day.layer.borderColor = UIColor(hex: "#299EF5").cgColor
           BgVw_Day.layer.borderWidth = 0.5
           self.lbl_ShortDay.textColor = UIColor(hex: "#299EF5")
           self.lbl_ShortDay.font = FontManager.inter(.semiBold, size: 10)

           // Show the time table
        guard let count = self.SlotsDay?.slots.count, count < 3 else { return }

        // Append an empty slot
        self.SlotsDay?.slots.append(Slot(start: "", end: "", enabled: false))
        self.onSlotValueAdded?(
            DayAvailability(day: self.SlotsDay?.day ?? "", enabled: true, slots:  self.SlotsDay?.slots ?? [])
           
        )
         // table_VW.reloadData()
          
        if  self.SlotsDay?.slots.count == 3 {
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
            print("Layput updated")
            height_Table.constant = table_VW.contentSize.height
        } else {
            height_Table.constant = 0
        }
    }
 
    

}
extension AvailibilityTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SlotsDay?.slots.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SlotTVC", for: indexPath) as? SlotTVC else {
                return UITableViewCell()
            }
        print("Slot Cell Called")
        cell.SlotsList = self.SlotsDay
            let row = indexPath.row + 1
        cell.slotIndexPath = indexPath.row
        cell.mainIndexPath = indexPathRow
        cell.parentController = self.parentViewController
        cell.lbl_timeSlot.text = "Time Slot \(row)"
        cell.prefilledDataSetup()
        cell.onTimeChanged = { [weak self] start, end in
            guard let self = self else { return }
            guard var slotsList = self.SlotsDay else { return }
                self.SlotsDay?.slots[indexPath.row].start = start
                self.SlotsDay?.slots[indexPath.row].end = end
              self.SlotsDay?.slots[indexPath.row].enabled = true
            self.onSlotValueAdded?(
                DayAvailability(day: self.SlotsDay?.day ?? "", enabled: true, slots: self.SlotsDay?.slots ?? [])
            )
        }

       
            // Use captured index
            cell.onDelete = { [weak self] in
                guard let self = self else { return }
                self.SlotsDay?.slots.remove(at: row - 1)
                if self.SlotsDay?.slots.count == 3 {
                    self.VwAnotherSlot_Height.constant = 0.0
                    BgVw_AnotherSlot.isHidden = true
                }else{
                    BgVw_AnotherSlot.isHidden = false
                    VwAnotherSlot_Height.constant = 45// Or your desired height
                }
                table_VW.reloadData()
                self.height_Table.constant = tableView.contentSize.height
                self.onSlotChanged?(indexPath.row)
                
            }

            return cell
    }
    func calculateTotalHours() -> Int {
        guard let timeSlots = self.SlotsDay?.slots else { return 0 }
        
        var total = 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        for slot in timeSlots {
            if let startDate = dateFormatter.date(from: slot.start),
               let endDate = dateFormatter.date(from: slot.end) {
                let diff = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour ?? 0
                total += max(diff, 0) // avoid negatives
            }
        }
        
        return total
    }


}

