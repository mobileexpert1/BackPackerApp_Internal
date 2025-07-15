//
//  JobPostVC.swift
//  Backpacker
//
//  Created by Mobile on 08/07/25.
//

import UIKit

class JobPostVC: UIViewController {

    @IBOutlet weak var Vw_Setting: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var seacrhVw: UIView!
    @IBOutlet weak var description_ContainerVW: UIView!
    @IBOutlet weak var lblBackPacker: UILabel!
    @IBOutlet weak var lbl_Jobs: UILabel!
    @IBOutlet weak var vW_BackPacker: UIView!
    @IBOutlet weak var vW_Jobs: UIView!
    @IBOutlet weak var btn_BackPacker: UIButton!
    @IBOutlet weak var btn_Jobs: UIButton!
    var firstVC: JobCollectionVC!
    var secondVC: BackPackerListVC!

    @IBOutlet weak var Vw_RatingHeight: NSLayoutConstraint!
    @IBOutlet weak var Vw_RatingDistance: CommonRatingDistanceView!
    var currentChildVC: UIViewController?
   
    var designationsJobs : [JobsDesignation] = [
        JobsDesignation(Name: "Software Engineer", star: "5 Star",distance: "10 Km"),
        JobsDesignation(Name: "UI/UX Designer", star: "2 Star",distance: "2 Km"),
        JobsDesignation(Name: "Product Manager", star: "3 Star",distance: "5 Km"),
        JobsDesignation(Name: "Data Analyst", star: "4 Star",distance: "10 Km"),
        JobsDesignation(Name: "Mobile Developer", star: "5 Star",distance: "15 Km"),
        JobsDesignation(Name: "QA Tester", star: "3 Star",distance: "10 Km"),
        JobsDesignation(Name: "DevOps Engineer", star: "1 Star",distance: "25 Km"),
        JobsDesignation(Name: "Project Coordinator", star: "22 Star",distance: "10 Km"),
        JobsDesignation(Name: "Backend Developer", star: "4 Star",distance: "20 Km"),
        JobsDesignation(Name: "Technical Lead", star: "4 Star",distance: "10 Km"),
    ]
    var backpackers: [BackPackers] = [
        BackPackers(name: "John Smith", country: "Australia", completedJobs: 5),
        BackPackers(name: "Emma Johnson", country: "Canada", completedJobs: 8),
        BackPackers(name: "Liam Brown", country: "UK", completedJobs: 3),
        BackPackers(name: "Olivia Davis", country: "Germany", completedJobs: 10)
    ]
    var filteredBackPackerList : [BackPackers] = []
    var filteredDesignations: [JobsDesignation] = []
    
    @IBOutlet weak var btn_Filter: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUPBtns()
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Vw_RatingHeight.constant = 0
        self.Vw_RatingDistance.isHidden = true
        Vw_RatingDistance.layer.cornerRadius = 10 // adjust as needed
        Vw_RatingDistance.layer.shadowColor = UIColor.black.cgColor
        Vw_RatingDistance.layer.shadowOpacity = 0.2
        Vw_RatingDistance.layer.shadowOffset = CGSize(width: 0, height: 0) // all sides
        Vw_RatingDistance.layer.shadowRadius = 4 // smooth shadow
        Vw_RatingDistance.layer.masksToBounds = false
        self.Vw_RatingDistance.filterItemSelected = { selectedItem in
            print("👉 Main Controller selected value: \(selectedItem)")
            self.filterActions(item: selectedItem)
            // Do something with the selected item
        }
    }
    private func setUpUI(){
        self.Vw_Setting.addShadowAllSides()
        self.lblHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.seacrhVw.layer.cornerRadius = 25.0
        self.seacrhVw.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.seacrhVw.layer.borderWidth = 1.0
        filteredDesignations = designationsJobs  // Initialize with full data
        filteredBackPackerList = backpackers
        txtFldSearch.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)] // Or any color you want
        )
        txtFldSearch.font = FontManager.inter(.regular, size: 14.0)
        txtFldSearch.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        firstVC = storyboard.instantiateViewController(withIdentifier: "JobCollectionVC") as? JobCollectionVC
        secondVC = storyboard.instantiateViewController(withIdentifier: "BackPackerListVC") as? BackPackerListVC
        self.btn_Filter.tag = 0
      
    }
    
    private func setUPBtns(){
        self.btn_BackPacker.tag = 0
        self.btn_Jobs.tag = 1
        self.vW_Jobs.layer.cornerRadius = 10
        self.vW_Jobs.layer.cornerRadius = 10
        self.vW_Jobs.backgroundColor  = UIColor(named: "themeColor")
        self.lblBackPacker.text = "BackPacker"
        self.lbl_Jobs.text = "Jobs"
        self.lbl_Jobs.textColor = .white
        self.lbl_Jobs.font = FontManager.inter(.medium, size: 14.0)
        self.lblBackPacker.textColor = .black
        self.lblBackPacker.font = FontManager.inter(.medium, size: 14.0)
        self.showChild(firstVC)
    }

    @IBAction func action_btnBackPacker(_ sender: Any) {
        self.btn_BackPacker.tag = 0
        self.btn_Jobs.tag = 1
        if btn_Jobs.tag == 1 {
            self.vW_BackPacker.backgroundColor = UIColor(named: "themeColor")
            self.vW_BackPacker.layer.cornerRadius = 10.0
            self.vW_Jobs.backgroundColor = .clear
            self.lbl_Jobs.textColor = .black
            self.lbl_Jobs.font = FontManager.inter(.medium, size: 14.0)
            self.lblBackPacker.textColor = .white
            self.lblBackPacker.font = FontManager.inter(.medium, size: 14.0)
        }
        self.setBtnTitle()
        self.showChild(secondVC)
    }
    @IBAction func action_BtnJobs(_ sender: Any) {
        
        self.btn_BackPacker.tag = 1
        self.btn_Jobs.tag = 0
        if btn_BackPacker.tag == 1 {
            self.vW_Jobs.backgroundColor = UIColor(named: "themeColor")
            self.vW_Jobs.layer.cornerRadius = 10.0
            self.vW_BackPacker.backgroundColor = .clear
            self.lblBackPacker.textColor = .black
            self.lblBackPacker.font = FontManager.inter(.medium, size: 14.0)
            self.lbl_Jobs.textColor = .white
            self.lbl_Jobs.font = FontManager.inter(.medium, size: 14.0)
        }
        self.setBtnTitle()
        self.showChild(firstVC)
    }
    
    private func setBtnTitle(){
        self.lbl_Jobs.text = "Jobs"
        self.lblBackPacker.text = "BackPacker"
    }
    
    
    @objc func searchTextChanged() {
        let text = txtFldSearch.text ?? ""
        
        if currentChildVC == firstVC {
            // 🔹 Filter designations for JobCollectionVC
            if text.isEmpty {
                filteredDesignations = designationsJobs
            } else {
                filteredDesignations = designationsJobs.filter { $0.Name.lowercased().contains(text.lowercased()) }

            }
            firstVC.updateDesignations(filteredDesignations)
            
        } else {
            // 🔹 Filter backpackers for BackPackerListVC
            let search = text.lowercased()
            let filtered = search.isEmpty
            ? backpackers
                : backpackers.filter { $0.name.lowercased().contains(search) }
            secondVC.updateDesignations(filtered)
        }
    }

    
    @IBAction func actionFilter(_ sender: Any) {
        self.filterActions(item: "")
        
    }
    
    private func filterActions(item:String){
        if self.btn_Filter.tag == 0 {
             self.btn_Filter.tag = 1
         }else{
             self.btn_Filter.tag = 0
         }
        if btn_Filter.tag == 1{
            self.Vw_RatingHeight.constant = 250
            self.Vw_RatingDistance.isHidden = false
        }else{
            self.Vw_RatingHeight.constant = 0
            self.Vw_RatingDistance.isHidden = true
        }
        // ✅ Force layout update
           UIView.animate(withDuration: 0.2) {
               self.Vw_RatingDistance.layoutIfNeeded()
           }
        filterDesignations(by: item)
    }
    func filterDesignations(by item: String) {
        if item.contains("Star") {
            // It's a star filter
         let ByStar  =  filterByStar(starStr: item)
            if ByStar.count > 0{
                firstVC.updateDesignations(ByStar)
            }
        }
        if item.contains("Km") {
            // It's a distance filter
          let byDistnance =   filterByDistance(distanceStr: item)
            if byDistnance.count > 0{
                firstVC.updateDesignations(byDistnance)
            }
        }
    }

    private func showChild(_ newVC: UIViewController) {
        // Remove current child if any
        if let currentVC = currentChildVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }

        // Add new child
        addChild(newVC)
        newVC.view.frame = description_ContainerVW.bounds // ✅ Corrected line
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        description_ContainerVW.addSubview(newVC.view)
        newVC.didMove(toParent: self)

        // Update current
        currentChildVC = newVC
        if currentChildVC == firstVC {
            firstVC.updateDesignations(filteredDesignations)
        }else{
            secondVC.updateDesignations(filteredBackPackerList)
        }
    }
    
    
    @IBAction func action_Setting(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
           if let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC {
               self.navigationController?.pushViewController(settingVC, animated: true)
           } else {
               print("❌ Could not instantiate SettingVC")
           }
    }
    
    
    
}
extension JobPostVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // hides the keyboard
        return true
    }
    func extractNumber(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    func filterByDistance(distanceStr: String) -> [JobsDesignation] {
        guard let maxDistance = extractNumber(from: distanceStr) else {
            return []
        }
        
        return designationsJobs.filter { job in
            if let jobDistance = extractNumber(from: job.distance) {
                return jobDistance <= maxDistance
            }
            return false
        }
    }
    func filterByStar(starStr: String) -> [JobsDesignation] {
        guard let minStar = extractNumber(from: starStr) else {
            return []
        }
        
        return designationsJobs.filter { job in
            if let jobStar = extractNumber(from: job.star) {
                return jobStar >= minStar
            }
            return false
        }
    }

}
