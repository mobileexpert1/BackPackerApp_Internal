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
    let weekDays = [
            ("Sun", "Sunday"),
            ("Mon", "Monday"),
            ("Tue", "Tuesday"),
            ("Wed", "Wednesday"),
            ("Thu", "Thursday"),
            ("Fri", "Friday"),
            ("Sat", "Saturday")
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUPUI()
                self.setUpTable()
    }
    

    @IBAction func action_Back(_ sender: Any) {
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
        return weekDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvailibilityTVC", for: indexPath) as? AvailibilityTVC else {
            return UITableViewCell()
        }

        let day = weekDays[indexPath.row]
        cell.lbl_ShortDay.text = day.0
        cell.lbl_Day.text = day.1
        cell.lbl_AvailibityStatus.text = "Available" // Or set based on model later
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
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        cell.onSlotChanged = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }

        return cell
    }
    
}
