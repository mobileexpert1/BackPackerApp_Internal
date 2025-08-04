//
//  CompanyDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 04/08/25.
//

import UIKit

class CompanyDetailVC: UIViewController {

    @IBOutlet weak var lbl_CompanyLOgi: UILabel!
    @IBOutlet weak var lbl_Val_SelctedIndustry: UILabel!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var vw_Table_Height: NSLayoutConstraint!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vw_SelectIndustry: UIView!
    @IBOutlet weak var lbl_Industry: UILabel!
    @IBOutlet weak var bussinesName_Vw: CommonTxtFldLblVw!
    
    @IBOutlet weak var lbl_Placeholder: UILabel!
    @IBOutlet weak var placeholde_Img: UIImageView!
    @IBOutlet weak var selected_Image: UIImageView!
    
    @IBOutlet weak var MainVw_Industries: UIView!
    @IBOutlet weak var btn_Industry: UIButton!
    @IBOutlet weak var placeholder_Vw: UIView!
    let industries = [
        "Information Technology",
        "Software Development",
        "Cybersecurity",
        "Cloud Computing",
        "Artificial Intelligence",
        "Web Development",
        "Mobile App Development",
        "IT Support",
        "Restaurants",
        "Food Delivery",
        "Catering Services",
        "Food Processing",
        "Fast Food",
        "Bakery & Confectionery",
        "Beverage Manufacturing",
        "Hospitals",
        "Pharmaceuticals",
        "Medical Devices",
        "Mental Health Services",
        "Telemedicine",
        "Biotechnology",
        "Residential Construction",
        "Commercial Construction",
        "Architecture",
        "Real Estate Development",
        "Property Management",
        "Interior Design"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    }
    
    func setUpUI(){
        self.MainVw_Industries.layer.cornerRadius = 10.0
        self.MainVw_Industries.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.MainVw_Industries.layer.borderWidth = 1.0
        self.btn_Industry.tag  = 0
        self.bussinesName_Vw.setTitleLabel("Business Name")
        self.bussinesName_Vw.setPlaceholder("Name")
        self.bussinesName_Vw.setError("")
        self.lbl_Industry.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Val_SelctedIndustry.font = FontManager.inter(.regular, size: 14.0)
        lbl_CompanyLOgi.font = FontManager.inter(.medium, size: 14.0)
        self.setUpLblIndustryColor()
        self.manageHeight()
        self.vw_SelectIndustry.layer.cornerRadius = 10.0
        self.vw_SelectIndustry.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.vw_SelectIndustry.layer.borderWidth = 1.0
        self.lbl_Placeholder.font = FontManager.inter(.medium, size: 10.0)
        self.btn_remove.isHidden = true
        handleRemoveBtnVisibility()
        self.tblVw.register(UINib(nibName: "ReportIssueTVC", bundle: nil), forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }
    func setUpLblIndustryColor(){
        if lbl_Val_SelctedIndustry.text == "Select Industry"{
            
            self.lbl_Val_SelctedIndustry.textColor = UIColor(hex: "#9D9D9D")
        }else{
            self.lbl_Val_SelctedIndustry.textColor = UIColor.black
        }
    }
    @IBAction func action_remove(_ sender: Any) {
    }
    @IBAction func action_uploadImage(_ sender: Any) {
        
        
    }
    @IBAction func action_IsTapppedIndustry(_ sender: Any) {
        if  self.btn_Industry.tag  == 0{
            self.btn_Industry.tag = 1
        }else{
            self.btn_Industry.tag = 0
        }
        self.manageHeight()
    }
    
    func manageHeight(){
        if  self.btn_Industry.tag  == 0{
            self.vw_Table_Height.constant = 0.0
            self.tbl_Height.constant = 0.0
        }else{
            self.vw_Table_Height.constant = 190
            self.tbl_Height.constant = 176.0
        }
        
    }
    
    func handleRemoveBtnVisibility(){
        
    }
}

extension CompanyDetailVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return industries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportIssueTVC", for: indexPath) as? ReportIssueTVC else {
            return UITableViewCell()
        }

        cell.lbl_Issue.text = industries[indexPath.row] // assuming your cell has `lbl_title`
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIssue = industries[indexPath.row]
            print("Selected issue: \(selectedIssue)")
        self.lbl_Val_SelctedIndustry.text = selectedIssue
        self.btn_Industry.tag = 0
        self.manageHeight()
        self.setUpLblIndustryColor()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
}
