//
//  MessageLisVC.swift
//  Backpacker
//
//  Created by Mobile on 15/07/25.
//

import UIKit

class MessageLisVC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btn_Admin: UIButton!
    @IBOutlet weak var btn_Employer: UIButton!
    @IBOutlet weak var Vw_Admin: UIView!
    @IBOutlet weak var Vw_Employer: UIView!
    @IBOutlet weak var lbl_Admin: UILabel!
    @IBOutlet weak var lbl_Employer: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    // MARK: - Sample Array
    var userList: [MessageUser] = [
        MessageUser(userId: UUID().uuidString, name: "John Doe", subHeader: "Hey, got your message!", seenTime: "29 Mar"),
        MessageUser(userId: UUID().uuidString, name: "Jane Smith", subHeader: "Let's catch up tomorrow.", seenTime: "25 Mar"),
        MessageUser(userId: UUID().uuidString, name: "Admin Team", subHeader: "Your request was approved.", seenTime: "29 Feb"),
        MessageUser(userId: UUID().uuidString, name: "Michael Scott", subHeader: "Meeting rescheduled to 3 PM", seenTime: "25 Feb"),
        MessageUser(userId: UUID().uuidString, name: "Pam Beesly", subHeader: "Artwork is ready!", seenTime: "20 Jan")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUpUI(){
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.txtFldSearch.font = FontManager.inter(.regular, size: 14.0)
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        self.searchVw.layer.borderWidth = 1.0
        self.lbl_Employer.text = "Employer"
        self.lbl_Admin.text = "Admin"
        let nib = UINib(nibName: "EmployerTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "EmployerTVC")
        self.btn_Employer.tag = 1
        self.btn_Admin.tag = 0
        self.lbl_Admin.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Employer.font = FontManager.inter(.medium, size: 14.0)
        txtFldSearch.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor(hex:"#000000"),                     // Placeholder color
                .font: FontManager.inter(.regular, size: 14.0)             // Replace with your custom font if needed
            ]
        )
        

        self.UpdateBtnAppearance()
    }
    
    
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func UpdateBtnAppearance(){
        if btn_Employer.tag == 1{
            self.lbl_MainHeader.text = "Messages"
            self.Vw_Employer.backgroundColor = UIColor(named: "themeColor")
            self.Vw_Employer.layer.cornerRadius = 10.0
            self.lbl_Employer.textColor = .white
            self.Vw_Admin.backgroundColor = .clear
            self.lbl_Admin.textColor = .black
        }else{
            self.lbl_MainHeader.text = "Chat"
            self.Vw_Admin.backgroundColor = UIColor(named: "themeColor")
            self.Vw_Admin.layer.cornerRadius = 10.0
            self.lbl_Admin.textColor = .white
            self.Vw_Employer.backgroundColor = .clear
            self.lbl_Employer.textColor = .black
        }
    }
    
    @IBAction func action_AdminToggle(_ sender: Any) {
        self.btn_Admin.tag = 1
        self.btn_Employer.tag =  0
        
        self.UpdateBtnAppearance()
    }
    
    @IBAction func action_EmplyerToggle(_ sender: Any) {
        self.btn_Admin.tag = 0
        self.btn_Employer.tag =  1
        
        self.UpdateBtnAppearance()
    }
}


extension MessageLisVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployerTVC", for: indexPath) as? EmployerTVC else {
                return UITableViewCell()
            }
            let user = userList[indexPath.row]
        cell.lblHeader.text = user.name
        cell.lbl_Subheader.text = user.subHeader
        cell.lbl_SeenTime.text = user.seenTime
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
               self.navigationController?.pushViewController(settingVC, animated: true)
           } else {
               print("- Could not instantiate SettingVC")
           }
    }
    
}
struct MessageUser {
    let userId: String
    let name: String
    let subHeader: String
    let seenTime: String
}

