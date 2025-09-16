//
//  ReportIssueVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class ReportIssueVC: UIViewController {
    let reportIssueList = [
        "Inappropriate Content",
        "Spam or Misleading",
        "Fake Information",
        "Scam or Fraud",
        "Copyright Violation",
        "Other"
    ]

    @IBOutlet weak var btn_Save: UIButton!
    
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var reoprtVw: UIView!
    @IBOutlet weak var btn_Expand: UIButton!
    
    @IBOutlet weak var lbl_HederComnts: UILabel!
    @IBOutlet weak var ttbl_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_IssueTitle: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var BgVw_Table: UIView!
    @IBOutlet weak var BgVwheight: NSLayoutConstraint!
    
    var viewModel = ReportIssueViewModel()
    var viewModelAuth = LogInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    private func setUpUI(){
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_title.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_HederComnts.font = FontManager.inter(.medium, size: 14.0)
        
        
        self.lbl_IssueTitle.text = "Reason"
        self.lbl_IssueTitle.font = FontManager.inter(.regular, size: 14.0)
        self.ttbl_HeightConstraint.constant = 0.0
        self.BgVw_Table.addShadowAllSides(radius:0.0)
        self.BgVwheight.constant = 0.0
        self.btn_Expand.tag = 0
        let nib = UINib(nibName: "ReportIssueTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "ReportIssueTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        txtVw.delegate = self
        txtVw.text = "Comments"
        txtVw.textColor = UIColor.lightGray
        txtVw.layer.cornerRadius = 8
        reoprtVw.layer.cornerRadius = 8
        reoprtVw.addShadowAllSides(radius:2)
        txtVw.addShadowAllSides(radius:2)
        //reoprtVw.clipsToBounds = true
        self.setUpButtons()
    }
    @IBAction func action_Expand(_ sender: Any) {
       
        if btn_Expand.tag == 0{
            self.btn_Expand.tag = 1
        }else{
            self.btn_Expand.tag = 0
        }
        self.manageHeightOfTable()
    }
    
    func manageHeightOfTable(){
        if self.btn_Expand.tag == 0{
            self.ttbl_HeightConstraint.constant = 0.0
            self.BgVw_Table.addShadowAllSides(radius:0.0)
            self.BgVwheight.constant = 0.0
        }else{
            self.ttbl_HeightConstraint.constant = 196.0
            self.BgVw_Table.addShadowAllSides(radius:1.5)
            self.BgVwheight.constant = 200.0
        }
    }
    @IBAction func action_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Save(_ sender: Any) {
        if self.lbl_IssueTitle.text?.isEmpty == true || self.lbl_IssueTitle.text == "Reason"{
            AlertManager.showAlert(on: self, title: "Reason", message: "Please choose the reason.")
        }else if txtVw.text.isEmpty == true || txtVw.text == "Comments" {
            AlertManager.showAlert(on: self, title: "Comments", message: "Please Add Comments")
        }else{
            self.CreateReportIssue()
        }
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated:  true)
    }
    private func setUpButtons(){
    applyGradientButtonStyle(to: btn_Save)
        btn_Cancel.titleLabel?.font = FontManager.inter(.semiBold, size: 14.0)
        btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 14.0)
        
        // Corner Radius
        btn_Cancel.layer.cornerRadius = 10.0
        btn_Save.layer.cornerRadius = 10.0
        btn_Cancel.clipsToBounds = true
        btn_Save.clipsToBounds = true
    }
}
extension ReportIssueVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportIssueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportIssueTVC", for: indexPath) as? ReportIssueTVC else {
            return UITableViewCell()
        }

        let item = reportIssueList[indexPath.row]
        
        // Assuming you have a UILabel called lbl_title in ReportIssueTVC
        cell.lbl_Issue.text = item

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIssue = reportIssueList[indexPath.row]
            print("Selected issue: \(selectedIssue)")
        self.lbl_IssueTitle.text = selectedIssue
        self.btn_Expand.tag = 0
        self.manageHeightOfTable()

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
extension ReportIssueVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = .label // default text color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Describe your issue..."
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView,
                      shouldChangeTextIn range: NSRange,
                      replacementText text: String) -> Bool {
            if text == "\n" { // user pressed return
                textView.resignFirstResponder() // dismiss keyboard
                return false // do not insert newline
            }
            return true
        }
}


extension ReportIssueVC {
    func CreateReportIssue(){
        LoaderManager.shared.show()
        let rawText =  self.txtVw.text ?? ""
        let cleanedText = rawText.replacingOccurrences(of: "\n", with: " ")
        let title = self.lbl_IssueTitle.text ?? ""
        let req = ReportRequest(title: title, desc: cleanedText, reason: "")
        viewModel.createSupportTicket(request: req) { success, message ,statusCode in
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
                            self.CreateReportIssue()
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
    
}
