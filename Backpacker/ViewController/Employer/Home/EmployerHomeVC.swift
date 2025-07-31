//
//  EmployerHomeVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit

class EmployerHomeVC: UIViewController {

    @IBOutlet weak var header_Imahe: UIImageView!
    @IBOutlet weak var mainHeaderVwHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_NotificationCount: UILabel!
    @IBOutlet weak var notificatiobBadgeVw: UIView!
    @IBOutlet weak var BgVwNotification: UIView!
    @IBOutlet weak var cahtBgVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var headerIMg_Width: NSLayoutConstraint!
    @IBOutlet weak var tblVw: UITableView!
    let roleType = UserDefaults.standard.string(forKey: "UserRoleType")
    var sectionTitles = ["", "Accomodations", "Jobs"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if roleType == "2" {
            sectionTitles = ["", "Jobs"]
        }else if roleType == "3" {
            sectionTitles = ["", "Accomodations"]
        }else{
            sectionTitles = ["", "HangOuts"]
        }
        let nib = UINib(nibName: "HomeTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "HomeTVC")
#if BackpackerHire
        let Bnib = UINib(nibName: "EmployerJobTVC", bundle: nil)
        self.tblVw.register(Bnib, forCellReuseIdentifier: "EmployerJobTVC")
#endif
        
        tblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        tblVw.showsVerticalScrollIndicator = false
        tblVw.showsHorizontalScrollIndicator = false
        tblVw.contentInset = .zero
        tblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        cahtBgVw.addShadowAllSides()
        BgVwNotification.addShadowAllSides()
        self.lbl_MainHeader.font  =  FontManager.inter(.bold, size: 14.0)
        self.lbl_NotificationCount.font = FontManager.inter(.medium, size: 8.0)
    }
    
    func showTopView(isShow : Bool = false,title : String = "Employer"){
        if isShow == true{
            self.lbl_MainHeader.text = title
            cahtBgVw.isHidden = true
            BgVwNotification.isHidden = true
            self.headerIMg_Width.constant = 0.0
        }else{
            self.lbl_MainHeader.text = "Employer"
            cahtBgVw.isHidden = false
            BgVwNotification.isHidden = false
            self.headerIMg_Width.constant = 22.0
        }
    }

}

extension EmployerHomeVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else{
            return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                return UITableViewCell()
            }
            cell.isComeForHireDetailPage = false
    //        let sectionItems = itemsPerSection[indexPath.section]
            cell.configure(with: sectionTitles,section: indexPath.section)
            // Handle final callback here
                cell.onAddAccommodation = { [weak self] in
                    self?.moveToAddAccomodationVC()
                }
            
            cell.onTapAcceptJob = { index in
                print("Tapped index total: \(index)")
                self.HandleNavigationforAcceptDelinedJob(in: index)
            }

            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployerJobTVC", for: indexPath) as? EmployerJobTVC else {
                return UITableViewCell()
            }
    //        let sectionItems = itemsPerSection[indexPath.section]
           // cell.configure(with: sectionTitles,section: indexPath.section)
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
        if indexPath.section == 0  {
            return 360
        }else if   indexPath.section == 1  {
            return 400
            
        }else{
            return 160
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
    
    private func HandleNavigationforAcceptDelinedJob(in index: Int) {
        print("Button tapped in section \(index)")
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let accVC = storyboard.instantiateViewController(withIdentifier: "FavourateJobVC") as? FavourateJobVC {
            accVC.isComeFromAcceptDeclineJobs = true
            if index == 0 {
                accVC.selectedIndexHeader = 0
            }else if index == 1{
                accVC.selectedIndexHeader = 1
            }else{
                accVC.selectedIndexHeader = 0
            }
            self.navigationController?.pushViewController(accVC, animated: true)
        } else {
            print("❌ Could not instantiate AddNewAccomodationVC")
        }
    }
}
