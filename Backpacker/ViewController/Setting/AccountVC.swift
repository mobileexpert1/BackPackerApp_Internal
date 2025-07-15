//
//  AccountVC.swift
//  Backpacker
//
//  Created by Mobile on 09/07/25.
//
import Foundation
import UIKit

class AccountVC: UIViewController {

   
    @IBOutlet weak var Vw_Name: CommonTextfieldView!
    @IBOutlet weak var Vw_PhoneNumber: CommonTextfieldView!
    @IBOutlet weak var Vw_Area: CommonTextfieldView!
    @IBOutlet weak var Vw_Country: CommonTextfieldView!
    @IBOutlet weak var Vw_State: CommonTextfieldView!
    @IBOutlet weak var Vw_Email: CommonTextfieldView!
    
    @IBOutlet weak var titleVisa: UILabel!
    @IBOutlet weak var vWHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVw_Visa: UITableView!
    @IBOutlet weak var btn_drpdwn: UIButton!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var lbl_VisaTitle: UILabel!
    let visaTypes = [
        "Tourist Visa",
        "Business Visa",
        "Student Visa",
        "Work Visa",
        "Transit Visa",
        "Spouse/Partner Visa",
        "Diplomatic Visa",
        "Refugee Visa",
        "Permanent Residency",
        "Investor Visa"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        Vw_Name.setKeyboardType(.default)
        Vw_Name.setPlaceholder("Enter Name")
        Vw_Name.setTitle("Name")
        Vw_Name.showError("Please enter Name Field.")
        
        Vw_PhoneNumber.setKeyboardType(.numberPad)
        Vw_PhoneNumber.setPlaceholder("Enter Phone Number")
        Vw_PhoneNumber.setTitle("Phone Number")

        
        Vw_Email.setKeyboardType(.emailAddress)
        Vw_Email.setPlaceholder("Enter Email")
        Vw_Email.setTitle("Email")

        
        
        Vw_State.setKeyboardType(.default)
        Vw_State.setPlaceholder("Enter State")
        Vw_State.setTitle("Sate")

        
        Vw_Country.setKeyboardType(.default)
        Vw_Country.setPlaceholder("Enter Country")
        Vw_Country.setTitle("Country")

        
        Vw_Area.setKeyboardType(.default)
        Vw_Area.setPlaceholder("Enter Area")
        Vw_Area.setTitle("Area")

        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw_Visa.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw_Visa.delegate = self
        self.tblVw_Visa.dataSource = self
        self.titleVisa.font = FontManager.inter(.medium, size: 12.0)
        
        self.btn_drpdwn.tag = 0
        self.manageHeightOfTable()
        self.lbl_VisaTitle.font = FontManager.inter(.regular, size: 14.0)
        self.tblVwHeight.constant = 0.0
        applyGradientButtonStyle(to: btn_Save)
    }
    
    func manageHeightOfTable(){
        if self.btn_drpdwn.tag == 0{
            self.tblVwHeight.constant = 0.0
            self.vWHeightContraint.constant = 0.0
            
        }else{
            self.tblVwHeight.constant = 190.0
            self.vWHeightContraint.constant = 190.0
        }
    }
   
    @IBAction func actionDrpDwn(_ sender: Any) {
        if btn_drpdwn.tag == 0{
            self.btn_drpdwn.tag = 1
        }else{
            self.btn_drpdwn.tag = 0
        }
        self.manageHeightOfTable()
    }
    
}
extension AccountVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visaTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportIssueTVC", for: indexPath) as? ReportIssueTVC else {
            return UITableViewCell()
        }

        cell.lbl_Issue.text = visaTypes[indexPath.row] // assuming your cell has `lbl_title`
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIssue = visaTypes[indexPath.row]
            print("Selected issue: \(selectedIssue)")
        self.lbl_VisaTitle.text = selectedIssue
        self.btn_drpdwn.tag = 0
        self.manageHeightOfTable()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
