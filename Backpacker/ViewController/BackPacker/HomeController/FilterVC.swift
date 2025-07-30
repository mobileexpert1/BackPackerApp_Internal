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
    
    @IBOutlet weak var lbl_ValDistance: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var scroolViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TblVw: UITableView!
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var slider: UISlider!
    let header = ["Filter","Sort by"]
    let filterArrya = ["Free Wifi","Swimming Pool","Laundary","TV"]
    let SortrArrya = ["Price (lowest first)","Price (highest first)"]
    var selectedFilterIndexes: Set<Int> = []

    var selectedSortIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
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
           DispatchQueue.main.async {
               self.TblVw.layoutIfNeeded()
               let sortArrCount = self.SortrArrya.count
               let filterarr = self.filterArrya.count
               let adddON = (sortArrCount + filterarr) * 30
               self.scroolViewHeight.constant = self.TblVw.contentSize.height + CGFloat(adddON)
           }
        slider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
            slider.minimumTrackTintColor = UIColor(hex: "#299EF5") // Start color"#299EF5"
            slider.maximumTrackTintColor = UIColor(hex: "#E8EDF0") // End color
        self.btn_Submit.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
    }
    
    @IBAction func acion_Cross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
 

}


extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count // 2 sections: "Filter", "Sort by"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filterArrya.count
        } else if section == 1 {
            return SortrArrya.count
        }
        return 0
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
            
        TblVw.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}

