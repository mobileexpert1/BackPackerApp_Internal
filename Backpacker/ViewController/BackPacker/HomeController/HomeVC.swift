//
//  HomeVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit

class HomeVC: UIViewController {
    
    let sectionTitles = ["Current Jobs", "New Jobs", "Declined Jobs"]
    let itemsPerSection = [
        ["Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa"],
        ["Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh"],
        ["Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai"] // 👈 Add a third section here
    ]
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var home_TblVw: UITableView!
    
    //HeaderOutLets
    @IBOutlet weak var Vw_Chat: UIView!
    
    @IBOutlet weak var mainVw_Settings: UIView!
    @IBOutlet weak var lbl_BckPAcker: UILabel!
    
    @IBOutlet weak var mainVew_Notification: UIView!
    @IBOutlet weak var Vw_Ntification: UIView!
    
    @IBOutlet weak var lbl_Notification: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        //  LoaderManager.shared.show()
        self.setupPullToRefresh()
        LocationManager.shared.requestLocationPermission()
        let nib = UINib(nibName: "HomeTVC", bundle: nil)
        self.home_TblVw.register(nib, forCellReuseIdentifier: "HomeTVC")
        home_TblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        self.home_TblVw.delegate = self
        self.home_TblVw.dataSource = self
        home_TblVw.showsVerticalScrollIndicator = false
        home_TblVw.showsHorizontalScrollIndicator = false
        home_TblVw.contentInset = .zero
        home_TblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        Vw_Chat.addShadowAllSides()
#if BackpackerHire
        print("BackpackerHire logic")
#else
        print("Backpacker  logic")
#endif
   
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // LoaderManager.shared.show()
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
    //            LoaderManager.shared.hide()
    //        }
}
private func setUpUI(){
    self.lbl_BckPAcker.font = FontManager.inter(.bold, size: 14.0)
    self.lbl_Notification.font = FontManager.inter(.medium, size: 8.0)
    Vw_Ntification.backgroundColor = #colorLiteral(red: 1, green: 0.1491003036, blue: 0, alpha: 1)
    self.mainVw_Settings.addShadowAllSides()
    self.mainVew_Notification.addShadowAllSides()
}
@IBAction func actionNotification(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Setting", bundle: nil)
    if let settingVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC {
        self.navigationController?.pushViewController(settingVC, animated: true)
    } else {
        print("❌ Could not instantiate SettingVC")
    }
}
@IBAction func action_Settings(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Setting", bundle: nil)
    if let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC {
        self.navigationController?.pushViewController(settingVC, animated: true)
    } else {
        print("❌ Could not instantiate SettingVC")
    }
}

@IBAction func action_Chat(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Chat", bundle: nil)
    if let settingVC = storyboard.instantiateViewController(withIdentifier: "MessageLisVC") as? MessageLisVC {
        self.navigationController?.pushViewController(settingVC, animated: true)
    } else {
        print("❌ Could not instantiate SettingVC")
    }
    
}
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
            return UITableViewCell()
        }
        let sectionItems = itemsPerSection[indexPath.section]
        cell.configure(with: sectionItems,section: indexPath.section)
        return cell
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
        return 40
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        self.home_TblVw.refreshControl = refreshControl
    }
    
    @objc private func refreshTableData() {
        // Show the default spinner, reload after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.home_TblVw.reloadData()
            self.refreshControl.endRefreshing() // Hide the spinner
            self.home_TblVw.setContentOffset(.zero, animated: true)
        }
    }
    private func handleHeaderButtonTap(in section: Int) {
        print("Button tapped in section \(section)")
    }
}
