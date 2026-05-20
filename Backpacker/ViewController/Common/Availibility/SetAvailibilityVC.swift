//  SetAvailibilityVC.swift
//  Backpacker
//  Created by Mobile on 28/07/25.

import UIKit

class SetAvailibilityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_QuickSetup: UILabel!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var BgVwWuickSetup: UIView!
    @IBOutlet weak var lbl_Main_Header: UILabel!
    
    var isQuickSetupTapped : Bool = false
    var totalHours = 8
    var josnBody : AvailabilityRequest?
    var responseAvaiability : GetAvailabilityResponse?
    let weekDays = [
        ("Sun", "Sunday"),
        ("Mon", "Monday"),
        ("Tue", "Tuesday"),
        ("Wed", "Wednesday"),
        ("Thu", "Thursday"),
        ("Fri", "Friday"),
        ("Sat", "Saturday")
    ]
    var SlotsListMain: [DayAvailability] = []
    let viewModel = SetAvailabilityViewModel()
    let viewModelAuth = LogInVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "setupQuickAction")
        self.setSlotDayData()
        self.setUPUI()
        self.setUpTable()
        self.getUserAvailabilityApiCall()
    }
    
    func setSlotDayData() {
        let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        for day in weekDays {
            SlotsListMain.append(DayAvailability(day: day, enabled: true, slots: []))
        }
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_QuickSetUp(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "setupQuickAction")
        SlotsListMain.removeAll()
        let weekDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        SlotsListMain.append(
            DayAvailability(
                day: "Sunday",
                enabled: true,
                slots: []
            )
        )
        for day in weekDays {
            SlotsListMain.append(
                DayAvailability(
                    day: day,
                    enabled: true,
                    slots: [Slot(start: "9:00 AM", end: "5:00 PM", enabled: true)]
                )
            )
        }
        SlotsListMain.append(
            DayAvailability(
                day: "Saturday",
                enabled: true,
                slots: []
            )
        )
        self.tableView.reloadData()
    }
    
    @IBAction func action_setAvailibility(_ sender: Any) {
        
        print("Slot List Data",SlotsListMain)
        self.setAvailabilityapiCall()
        //self.navigationController?.popViewController(animated: true)
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
        return SlotsListMain.count
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
        }
        
        cell.indexPathRow = indexPath.row
        cell.lbl_ShortDay.text = SlotsListMain[indexPath.row].day
        cell.lbl_Day.text = SlotsListMain[indexPath.row].day
        //     cell.btn_Switch.isOn = SlotsListMain[indexPath.row].enabled
        if  SlotsListMain[indexPath.row].slots.count > 0 {
            cell.btn_Switch.isOn = true
            cell.isSlotAlreadyAdded = true
        } else {
            cell.btn_Switch.isOn = false
            cell.isSlotAlreadyAdded = false
        }
        cell.SlotsDay = SlotsListMain[indexPath.row]
        let isOn =  cell.btn_Switch.isOn
        cell.lbl_AvailibityStatus.text = isOn ? "Available" : "Unavailable"
        
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
        
        cell.onSlotChanged = { index in
            print("Slot at index \(index) was deleted")
            // Handle any additional logic
            self.SlotsListMain[indexPath.row].slots.remove(at: index)
            print("List After delete", self.SlotsListMain)
            UIView.animate(withDuration: 0.3) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
        cell.onReload = { index in
            print("Row called on reload",index)
            UIView.animate(withDuration: 0.3) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
        cell.onSlotValueAdded = { [weak self] newSlot in
            guard let self = self else { return }
            
            // Find the index of the matching day
            if let index = self.SlotsListMain.firstIndex(where: {
                $0.day == newSlot.day
            }) {
                // Replace the old slot times with the new ones
                self.SlotsListMain[index].slots = newSlot.slots
            } else {
                // If not found, add new day slot
                self.SlotsListMain.append(newSlot)
            }
            
            print("Updated Slot List:", self.SlotsListMain)
        }
        cell.parentViewController = self
        cell.setUpDataAlredyAddedSlot()
        return cell
    }
}

extension SetAvailibilityVC {
    
    func setAvailabilityapiCall(){
        LoaderManager.shared.show()
        let req = AvailabilityRequest(overallAvailability: true, days: self.SlotsListMain)
        viewModel.setAvailability(request: req) { success, message ,statusCode in
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
                        AlertManager.showAlert(on: self, title: "Success", message: message ?? "Availability updated successfully"){
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
                            self.setAvailabilityapiCall()
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                }
            }
        }
    }
    
    func getUserAvailabilityApiCall() {
        LoaderManager.shared.show()
        viewModel.getUserAvailability { [weak self] (success: Bool, result: GetAvailabilityResponse?, statusCode: Int?) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                guard let statusCode = statusCode else {
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                    return
                }
                let httpStatus = HTTPStatusCode(rawValue: statusCode)
                
                DispatchQueue.main.async {
                    
                    switch httpStatus {
                    case .ok, .created:
                        if success == true {
                            if let availability = result {   //  already decoded object
                                self.responseAvaiability = availability
                                if let avai = self.responseAvaiability?.data?.days {
                                    print("Availability assigned:", availability)
                                    self.setUpFunctionalityData(data: availability)
                                }else{
                                    print("Availability assigned: Daya not found ", availability)
                                }
                                
                            } else {
                                AlertManager.showAlert(on: self, title: "Success", message: "No availability data found.")
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            LoaderManager.shared.hide()
                        }
                        
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getUserAvailabilityApiCall()
                            } else {
                                LoaderManager.shared.hide()
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                            }
                        }
                        
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .methodNotAllowed:
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                    }
                }
            }
        }
    }
    
    func setUpFunctionalityData(data: GetAvailabilityResponse) {
        guard let apiDays = data.data?.days else { return }
        
        for i in 0..<SlotsListMain.count {
            let localDay = SlotsListMain[i].day
            
            if let matchingApiDay = apiDays.first(where: { $0.day.caseInsensitiveCompare(localDay) == .orderedSame }) {
                
                var slots: [Slot] = []
                
                for apiSlot in matchingApiDay.slots {
                    // Only append if both start and end are not empty
                    if !apiSlot.start.isEmpty && !apiSlot.end.isEmpty {
                        let slot = Slot(start: apiSlot.start, end: apiSlot.end, enabled: apiSlot.enabled)
                        slots.append(slot)
                    }
                }
                
                SlotsListMain[i].slots = slots
                SlotsListMain[i].enabled = matchingApiDay.enabled
            }
        }
        print("Slot list main after filtering:", SlotsListMain)
        self.tableView.reloadData()
    }
}
