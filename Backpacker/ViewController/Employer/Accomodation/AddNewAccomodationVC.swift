//
//  AddNewAccomodationVC.swift
//  BackpackerHire
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class AddNewAccomodationVC: UIViewController {

    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var addressVw: CommonTxtFldLblVw!
    @IBOutlet weak var nameVw: CommonTxtFldLblVw!
    
    @IBOutlet weak var tblVw: UITableView!
    
    @IBOutlet weak var btn_Cancle: UIButton!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var BgVwDescription: UIView!
    @IBOutlet weak var txtVwDescription: UITextView!
    @IBOutlet weak var lbl_description: UILabel!
    
    @IBOutlet weak var lbl_Requirnement: UILabel!
    
    @IBOutlet weak var bgVwRequirnment: UIView!
    @IBOutlet weak var TxtVw_Requirnment: UITextView!
    
    
    //VisaType Outlets
    
    @IBOutlet weak var lblSelecVisaType: UILabel!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_TitleVisaType: UILabel!
    @IBOutlet weak var btnVisa: UIButton!
    
    @IBOutlet weak var BgVwVisa: UIView!
    //UploadImage outlets
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var mainBgVw: UIView!
    @IBOutlet weak var lbl_UploadImg: UILabel!
    @IBOutlet weak var placeholderImg: UIImageView!
    @IBOutlet weak var uploadImgVw: UIView!
    var mediaPicker: MediaPickerManager?
    
    @IBOutlet weak var vWHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var BgVwTbl: UIView!
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
        self.setupui()
        self.manageHeightOfTable()
        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    private func setupui(){
        self.btnVisa.tag = 0
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.nameVw.setTitleLabel("Name")
        self.nameVw.setPlaceholder("Name")
        self.nameVw.lblErrorVisibility(val: true)
        self.addressVw.setTitleLabel("Address")
        self.addressVw.setPlaceholder("Address")
        self.addressVw.lblErrorVisibility(val: true)
        self.nameVw.txtFld.delegate = self
        self.addressVw.txtFld.delegate = self
        self.txtVwDescription.delegate = self
        self.TxtVw_Requirnment.delegate = self
        self.nameVw.setError("dfs")
        self.addressVw.setError("sffjl")
        self.lbl_description.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Requirnement.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_TitleVisaType.font = FontManager.inter(.medium, size: 14.0)
        self.lblSelecVisaType.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_UploadImg.font = FontManager.inter(.medium, size: 13.0)
        
        
        self.bgVwRequirnment.layer.cornerRadius = 10.0
        self.bgVwRequirnment.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.bgVwRequirnment.layer.borderWidth = 1.0
        
        self.BgVwDescription.layer.cornerRadius = 10.0
        self.BgVwDescription.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwDescription.layer.borderWidth = 1.0
        self.BgVwVisa.layer.cornerRadius = 10.0
        self.BgVwVisa.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.BgVwVisa.layer.borderWidth = 1.0
        self.addDottedBorder(to: self.mainBgVw, color: UIColor(hex: "#93A3C3"), cornerRadius: 10)
        applyGradientButtonStyle(to: self.btn_Save)
    }
    
   
    
    
    @IBAction func action_BtnAssignBackpacker(_ sender: Any) {
        if self.btnVisa.tag == 0{
            self.btnVisa.tag = 1
        }else{
            self.btnVisa.tag = 0
        }
        self.manageHeightOfTable()
    }
    
    
    
    
    func addDottedBorder(to view: UIView, color: UIColor = .black, cornerRadius: CGFloat = 8.0) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4] // 4 points drawn, 4 points space
        shapeLayer.fillColor = nil
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.frame = view.bounds
        
        // Remove previous if exists
        view.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

        view.layer.addSublayer(shapeLayer)
    }
    
    
    @IBAction func action_Save(_ sender: Any) {
    }
    
    
    @IBAction func action_Cancle(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func action_UploadImage(_ sender: Any) {
        mediaPicker = MediaPickerManager(presentingVC: self)
    mediaPicker?.showMediaOptions { image in
        // Do something with the image
        print("Selected image: \(image)")
        self.uploadedImage.image = image
        self.placeholderImg.isHidden = true
        self.lbl_UploadImg.isHidden = true
    }
        
    }
}



extension AddNewAccomodationVC : UITableViewDelegate,UITableViewDataSource{
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
        self.lblSelecVisaType.text = selectedIssue
        self.btnVisa.tag = 0
        self.manageHeightOfTable()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func manageHeightOfTable(){
        if self.btnVisa.tag == 0{
            self.tblHeight.constant = 0.0
            self.vWHeightContraint.constant = 0.0
            self.BgVwTbl.layer.cornerRadius = 0.0
            self.BgVwTbl.layer.borderColor = UIColor.clear.cgColor
                self.BgVwTbl.layer.borderWidth = 0.0
        }else{
            self.BgVwTbl.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
            self.BgVwTbl.layer.cornerRadius = 10.0
                self.BgVwTbl.layer.borderWidth = 1.0
            self.tblHeight.constant = 176.0
            self.vWHeightContraint.constant = 190.0
        }
    }
}
extension AddNewAccomodationVC: UITextFieldDelegate, UITextViewDelegate {

    // Dismiss keyboard when Return is pressed in UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Dismiss keyboard when Return is pressed in UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
