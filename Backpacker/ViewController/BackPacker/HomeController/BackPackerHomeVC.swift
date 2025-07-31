//
//  BackPackerHomeVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class BackPackerHomeVC: UIViewController {

    @IBOutlet weak var homeTblVw: UITableView!
    @IBOutlet weak var txtFldVw: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_NotificationCount: UILabel!
    @IBOutlet weak var notifictionCountBgVw: UIView!
    @IBOutlet weak var VW_Noitication: UIView!
    @IBOutlet weak var Vw_Chat: UIView!
    @IBOutlet weak var lblMainHeader: UILabel!
    
    @IBOutlet weak var mainHeaderImgWidth: NSLayoutConstraint!
    var sectionTitles = ["","Accommodations","Backpackers Hangout","Jobs"]
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    override func viewDidLoad() {
        super.viewDidLoad()
#if BackpackerHire
        if role == "2" {
            sectionTitles = ["","Jobs"]
        }else if role == "3" {
            sectionTitles = ["","Accommodations"]
            self.showTopView(isShow: true,title: "Backpackers Accommodations")
        }else if role == "4" {
            sectionTitles = ["","Hangout"]
            self.showTopView(isShow: true,title: "Backpackers Hangout")
        }else{
            sectionTitles = ["","Accommodations","Backpackers Hangout","Jobs"]
            self.showTopView(isShow: false,title: "Backpackers Hangout")
        }
        #else
        sectionTitles = ["","Accommodations","Backpackers Hangout","Jobs"]
        #endif
        
       
        self.setUpUI()
        let nib = UINib(nibName: "HomeTVC", bundle: nil)
        self.homeTblVw.register(nib, forCellReuseIdentifier: "HomeTVC")
        let nib2 = UINib(nibName: "AdvertiesmentTVC", bundle: nil)
        self.homeTblVw.register(nib2, forCellReuseIdentifier: "AdvertiesmentTVC")
        let nib3 = UINib(nibName: "EmployerJobTVC", bundle: nil)
        self.homeTblVw.register(nib3, forCellReuseIdentifier: "EmployerJobTVC")
        homeTblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        txtFldVw.attributedPlaceholder = NSAttributedString(
                   string: "Search",
                   attributes: [
                    .foregroundColor: UIColor.black,
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        
        
        txtFldVw.delegate = self
    }
    func showTopView(isShow : Bool = false,title : String = "Employer"){
        if isShow == true{
            self.lblMainHeader.text = title
          
            Vw_Chat.isHidden = true
            notifictionCountBgVw.isHidden = true
            VW_Noitication.isHidden = true
            self.mainHeaderImgWidth.constant = 22.0
        }else{
            self.lblMainHeader.text = "Employer"
            Vw_Chat.isHidden = false
            notifictionCountBgVw.isHidden = false
            VW_Noitication.isHidden = false
            self.mainHeaderImgWidth.constant = 22.0
        }
    }

    func setUpUI(){
        self.lblMainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.homeTblVw.delegate = self
        self.homeTblVw.dataSource = self
        self.searchVw.layer.cornerRadius = 22.5
        self.searchVw.layer.borderWidth = 1.0
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        homeTblVw.showsVerticalScrollIndicator = false
        homeTblVw.showsHorizontalScrollIndicator = false
        homeTblVw.contentInset = .zero
        homeTblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        self.lbl_NotificationCount.font = FontManager.inter(.medium, size: 8)
        self.VW_Noitication.addShadowAllSides(radius: 2.0)
        self.Vw_Chat.addShadowAllSides(radius: 2.0)
        self.txtFldVw.delegate = self
    }
    
    @IBAction func action_Chat(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "MessageLisVC") as? MessageLisVC {
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
        
    }
    @IBAction func action_Notification(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC {
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
        
    }  
    
}
extension  BackPackerHomeVC : UITableViewDelegate,UITableViewDataSource{
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return sectionTitles.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesmentTVC", for: indexPath) as? AdvertiesmentTVC else {
                       return UITableViewCell()
                   }

                   cell.ads = [
                    Advertisement(name: "Flat 50%", address: "New York", image: UIImage(named: "advertiesment")!),
                    Advertisement(name: "Flat 70%", address: "Los Angeles", image: UIImage(named: "advertiesment")!),
                   ]

                   return cell
            }
          else  if indexPath.section == 1 || indexPath.section == 2 {
#if BackpackerHire
              guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                  return UITableViewCell()
              }
              cell.configure(with: sectionTitles,section: indexPath.section)
            cell.isComeFromJob = false
            cell.isComeForHireDetailPage = false
              // Handle final callback here
                  cell.onAddAccommodation = { [weak self] in
                  }
              return cell
              #else
              
              guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                  return UITableViewCell()
              }
              cell.configure(with: sectionTitles,section: indexPath.section)
            cell.isComeFromJob = false
            cell.isComeForHireDetailPage = false
              // Handle final callback here
                  cell.onAddAccommodation = { [weak self] in
                  }
              return cell
#endif
               
            }else{
                //guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployerJobTVC", for: indexPath) as? EmployerJobTVC else {
//                    return UITableViewCell()
//                }
//        //        let sectionItems = itemsPerSection[indexPath.section]
//               // cell.configure(with: sectionTitles,section: indexPath.section)
//                return cell
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                cell.configure(with: sectionTitles,section: indexPath.section)
                cell.isComeFromJob = true
               cell.isComeForHireDetailPage = false
                // Handle final callback here
                    cell.onAddAccommodation = { [weak self] in
                    }
                return cell
            }
           
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
                return nil
            }
            
            header.titleLaBLE.text = sectionTitles[section]
            header.section = section
            header.contentView.backgroundColor = .white // prevent background flicker
            header.onButtonTap = { [weak self] tappedSection in
                
                self?.handleHeaderButtonTap(in: tappedSection)
            }
            return header
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if section == 0 {
                return 0.0
            }
            return 40
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 0 {
                return 160
            }else if  indexPath.section == 1  {
#if BackpackerHire
                if role == "4"   {
                    return 420
                }else if role == "3"{
                    return 470
                }else if role == "2"{
                    return 470
                    
                } else{
                    return 380
                }
#else
                return 230
#endif
            }else if indexPath.section == 2 {
                return 230
            }
            else{
                return 180
            }
          
        }
        private func moveToAddAccomodationVC() {
            let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "AddNewAccomodationVC") as? AddNewAccomodationVC {
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("❌ Could not instantiate AddNewAccomodationVC")
            }
        }

    //    private func setupPullToRefresh() {
    //        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
    //        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
    //        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
    //        self.home_TblVw.refreshControl = refreshControl
    //    }
        
    //    @objc private func refreshTableData() {
    //        // Show the default spinner, reload after delay
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    //            self.tblVw.reloadData()
    //            self.refreshControl.endRefreshing() // Hide the spinner
    //            self.tblVw.setContentOffset(.zero, animated: true)
    //        }
    //    }
        private func handleHeaderButtonTap(in section: Int) {
            print("Button tapped in section \(section)")
        }
        
        
    

}


extension BackPackerHomeVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // hides keyboard
        return true
    }

}
