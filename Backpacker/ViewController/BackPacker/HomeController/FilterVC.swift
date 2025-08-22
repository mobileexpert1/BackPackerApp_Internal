//
//  FilterVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btn_ClearAll: UIButton!
    @IBOutlet weak var lbl_ValDistance: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var scroolViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TblVw: UITableView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var slider: UISlider!
    let header = ["Facilities","Sort by"]
    let filterArrya = ["Free WiFi","Swimming Pool","Parking","Elevator","Fitness Center","24-hours Open"]
    

    let SortrArrya = ["Price (lowest first)","Price (highest first)"]
    var selectedFilterIndexes: Set<Int> = []

    var selectedSortIndex: Int?
    var sortByPrice : String?
    var radius : String?
    var facilities : String?
    var onApplyFilters: ((_ facilities: String?, _ sortBy: String?, _ radius: String?) -> Void)?

    
    var initialFacilities: String?
    var initialSortBy: String?
    var initialRadius: String?
    var isComeFromHangOut : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setUpUI()
        self.applyInitialSelections()
    }
    func applyInitialSelections() {
        // Facilities
        if isComeFromHangOut == false {
            if let facilitiesStr = initialFacilities {
                let selected = facilitiesStr.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
                for (index, facility) in filterArrya.enumerated() {
                    if selected.contains(facility) {
                        selectedFilterIndexes.insert(index)
                    }
                }
            }

            // Sort by
            if let sort = initialSortBy {
                if sort.lowercased() == "asc" {
                    selectedSortIndex = SortrArrya.firstIndex(where: { $0.contains("lowest") })
                } else if sort.lowercased() == "desc" {
                    selectedSortIndex = SortrArrya.firstIndex(where: { $0.contains("highest") })
                }
            }
        }
      

        // Radius
        if let radiusStr = initialRadius, let radiusFloat = Float(radiusStr) {
            slider.value = radiusFloat
            let distance = "\(Int(radiusFloat))"
            let maxDistance = "\(Int(slider.maximumValue))"
            lbl_ValDistance.text = "\(distance) to \(maxDistance) km"
        }
        self.TblVw.reloadData()
    }

    func setUpUI(){
        self.lbl_Distance.font = FontManager.inter(.medium, size: 14)
        self.lbl_ValDistance.font = FontManager.inter(.medium, size: 14)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.ViewHeight.constant = UIScreen.main.bounds.height / 2
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainView.clipsToBounds = true
        applyGradientButtonStyle(to: self.btn_Submit)
        let nib = UINib(nibName: "FacilityTVC", bundle: nil)
        self.TblVw.register(nib, forCellReuseIdentifier: "FacilityTVC")
        let nib2 = UINib(nibName: "SortTByVC", bundle: nil)
        self.TblVw.register(nib2, forCellReuseIdentifier: "SortTByVC")
        
        self.TblVw.delegate = self
        self.TblVw.dataSource = self
        TblVw.showsVerticalScrollIndicator = false
        TblVw.showsHorizontalScrollIndicator = false
        TblVw.contentInset = .zero
        TblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 20.0)
        TblVw.isScrollEnabled = false // Disable scrolling
           TblVw.reloadData()
        if isComeFromHangOut == false{
            DispatchQueue.main.async {
                self.TblVw.layoutIfNeeded()
                let sortArrCount = self.SortrArrya.count
                let filterarr = self.filterArrya.count
                let adddON = (sortArrCount + filterarr) * 30
                self.scroolViewHeight.constant = CGFloat(adddON) + 280
            }
        }else{
            DispatchQueue.main.async {
                self.TblVw.layoutIfNeeded()
                self.TblVw.contentSize.height = 0.0
                self.TblVw.isHidden = true
                self.scroolViewHeight.constant = 180
                self.ViewHeight.constant = 250
            }
        }
         
        slider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
            slider.minimumTrackTintColor = UIColor(hex: "#299EF5") // Start color"#299EF5"
            slider.maximumTrackTintColor = UIColor(hex: "#E8EDF0") // End color
        self.btn_Submit.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        slider.minimumValue = 100
        slider.maximumValue = 500
        slider.value = 100
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        let maxDistance = "\(Int(slider.maximumValue))"
        let minDistance = "\(Int(slider.minimumValue))"
        self.lbl_ValDistance.text = "\(minDistance) to \(maxDistance) km"
        self.btn_ClearAll.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
    }
    @objc func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 10
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue

        let distance = "\(Int(roundedValue))"
        let maxDistance = "\(Int(sender.maximumValue))"

        lbl_ValDistance.text = "\(distance) to \(maxDistance) km"
    }


    @IBAction func acion_Cross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
 
    @IBAction func action_ClearAllFilter(_ sender: Any) {
        onApplyFilters?("", "", "100")

        // Dismiss the filter screen
        self.dismiss(animated: true)
    }
    @IBAction func action_submit(_ sender: Any) {
    
        var facilitiesString = ""
           if !selectedFilterIndexes.isEmpty {
               let selectedFacilities = selectedFilterIndexes.map { filterArrya[$0] }
               facilitiesString = selectedFacilities.joined(separator: ", ")
           }

           // Prepare sort value
           var sortValue = ""
           if let index = selectedSortIndex {
               let selectedSort = SortrArrya[index]
               sortValue = selectedSort.contains("lowest") ? "asc" : "desc"
           }

           // Prepare radius
           var radiusString = ""
           if slider.value > slider.minimumValue {
               radiusString = String(format: "%.0f", slider.value)
           }

           // Call the callback
           onApplyFilters?(facilitiesString, sortValue, radiusString)

           // Dismiss the filter screen
           self.dismiss(animated: true)
    }
    
}


extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isComeFromHangOut == true{
            return 0// 2 sections: "Filter", "Sort by"
        }else{
            return header.count // 2 sections: "Filter", "Sort by"
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComeFromHangOut == true{
            return 0// 2 sections: "Filter", "Sort by"
        }else{
            if section == 0 {
                return filterArrya.count
            } else if section == 1 {
                return SortrArrya.count
            }
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white // Customize background here

            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = header[section]
            titleLabel.font = FontManager.inter(.medium, size: 14.0) // Customize font here
            titleLabel.textColor = UIColor(hex: "#171725") // Customize text color here

            headerView.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])

            return headerView
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityTVC", for: indexPath) as! FacilityTVC
            cell.lblTitle.text = filterArrya[indexPath.row]

            if selectedFilterIndexes.contains(indexPath.row) {
                cell.imgCheckBox.image = UIImage(named: "Checkbox2")
            } else {
                cell.imgCheckBox.image = UIImage(named: "Checkbox")
            }
            return cell

         } else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "SortTByVC", for: indexPath) as! SortTByVC
             cell.lblTitle.text = SortrArrya[indexPath.row]
             
             if selectedSortIndex == indexPath.row {
                 cell.imgVwSort.image = UIImage(named: "RadioButton4")
             } else {
                 cell.imgVwSort.image = UIImage(named: "RadioButton3")
             }
             return cell
         }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
                // Toggle selection for filter section
            if selectedFilterIndexes.contains(indexPath.row) {
                   selectedFilterIndexes.remove(indexPath.row)
               } else {
                   selectedFilterIndexes.insert(indexPath.row)
               }
            } else if indexPath.section == 1 {
                // Toggle selection for sort section
                if selectedSortIndex == indexPath.row {
                    selectedSortIndex = nil
                } else {
                    selectedSortIndex = indexPath.row
                }
            }
        facilities = selectedFilterIndexes.map { filterArrya[$0] }.joined(separator: ", ")
        sortByPrice = selectedSortIndex != nil ? SortrArrya[selectedSortIndex!] : nil

        TblVw.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}

