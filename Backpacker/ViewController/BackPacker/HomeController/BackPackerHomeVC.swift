//
//  BackPackerHomeVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import CoreLocation
class BackPackerHomeVC: UIViewController {
    
    @IBOutlet weak var homeTblVw: UITableView!
    @IBOutlet weak var txtFldVw: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_NotificationCount: UILabel!
    @IBOutlet weak var notifictionCountBgVw: UIView!
    @IBOutlet weak var VW_Noitication: UIView!
    @IBOutlet weak var Vw_Chat: UIView!
    @IBOutlet weak var lblMainHeader: UILabel!
    
    @IBOutlet weak var vw_searchBtm: NSLayoutConstraint!
    @IBOutlet weak var img_placeholde_Search: UIImageView!
    @IBOutlet weak var Vw_SearchHeight: NSLayoutConstraint!
    @IBOutlet weak var mainHeaderImgWidth: NSLayoutConstraint!
    var refreshControl: UIRefreshControl?
    var sectionTitles = ["","Accommodations","Backpackers Hangout","Jobs"]
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    private let viewModel = BackPackerHomeVM()
    private let viewModelAuth = LogInVM()
    private var homeData: BackpackerHomeResponseModel?
    var activeSections: [SectionType] {
        var sections: [SectionType] = []
        if let banners = homeData?.banners, !banners.isEmpty {
            sections.append(.banner)
        }
        if let accommodations = homeData?.accommodationList, !accommodations.isEmpty {
            sections.append(.accommodations)
        }
        if let hangouts = homeData?.hangoutList, !hangouts.isEmpty {
            sections.append(.hangouts)
        }
        if let jobs = homeData?.jobslist, !jobs.isEmpty {
            sections.append(.jobs)
        }
        
        return sections
    }
    var lat : Double?
    var long : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPullToRefresh()
//        LocationManager.shared.delegate = self
//        LocationManager.shared.requestLocationPermission()
//        LocationManager.shared.startUpdatingLocation()
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
        Vw_SearchHeight.constant = 0.0
        txtFldVw.isHidden = true
        img_placeholde_Search.isHidden = true
        self.vw_searchBtm.constant = 5.0
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if Backapacker
        
        self.HomeApiCall()
#endif
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
#if Backapacker
        let count = activeSections.count
        if count == 0{
            return 0
        }else{
            return count
        }
       
#else
        return sectionTitles.count
        
#endif
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
#if BackpackerHire
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesmentTVC", for: indexPath) as? AdvertiesmentTVC else {
                return UITableViewCell()
            }
            let adsData = homeData?.banners
            if let adsData  = adsData {
                cell.ads = adsData
            }
            return cell
        }
        else  if indexPath.section == 1 || indexPath.section == 2 {
            
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
        }else{
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
#else
        let sectionType = activeSections[indexPath.section]
        
        switch sectionType {
        case .banner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesmentTVC", for: indexPath) as? AdvertiesmentTVC else {
                return UITableViewCell()
            }
            let adsData = homeData?.banners
            if let adsData  = adsData {
                cell.ads = adsData
            }
            return cell
            
        case .jobs:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                return UITableViewCell()
            }
            cell.configure(with: sectionTitles,section: indexPath.section)
            cell.isComeFromJob = true
            cell.isComeForHireDetailPage = false
            // Handle final callback here
            cell.onAddAccommodation = { [weak self] in
            }
            cell.jobList = homeData?.jobslist  ?? []
            cell.activeSections = activeSections
            return cell
            
        case .hangouts:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                return UITableViewCell()
            }
            cell.configure(with: sectionTitles,section: indexPath.section)
            cell.isComeFromJob = false
            cell.isComeForHireDetailPage = false
            // Handle final callback here
            cell.onAddAccommodation = { [weak self] in
            }
            cell.hangoutList = homeData?.hangoutList  ?? []
            cell.activeSections = activeSections
            return cell
            
        case .accommodations:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                return UITableViewCell()
            }
            cell.configure(with: sectionTitles,section: indexPath.section)
            cell.isComeFromJob = false
            cell.isComeForHireDetailPage = false
            // Handle final callback here
            cell.onAddAccommodation = { [weak self] in
            }
            cell.accomodationList = homeData?.accommodationList  ?? []
            cell.activeSections = activeSections
            return cell
        }
#endif
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
#if Backapacker
        let sectionType = activeSections[section]
        switch sectionType {
        case .banner:
            return nil // ✅ Don’t return header view for banner
        default:
            break
        }
#endif
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.section = section
        header.contentView.backgroundColor = .white
        
#if Backapacker
        switch sectionType {
        case .accommodations:
            header.titleLaBLE.text = "Accommodations"
        case .hangouts:
            header.titleLaBLE.text = "Backpacker Hangout"
        case .jobs:
            header.titleLaBLE.text = "Jobs"
        default:
            break
        }
#else
        header.titleLaBLE.text = sectionTitles[section]
#endif
        
        header.onButtonTap = { [weak self] tappedSection in
            self?.handleHeaderButtonTap(in: tappedSection)
        }
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
#if Backapacker
        let sectionType = activeSections[section]
        switch sectionType {
        case .banner:
            return 0
        case .accommodations, .hangouts, .jobs:
            return 40
        }
#else
        if section == 0 {
            return 0.0
        }
        return 40
#endif
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
            let sectionType = activeSections[indexPath.section]
            switch sectionType {
            case .banner:
                return 160
            case .accommodations:
                return 230
            case  .hangouts:
                return 190
            case .jobs :
                return 180
            }
           
#endif
        }else if indexPath.section == 2 {
            let sectionType = activeSections[indexPath.section]
            switch sectionType {
            case .banner:
                return 160
            case .accommodations:
                return 230
            case  .hangouts:
                return 205
            case .jobs :
                return 180
            }
           
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
    
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
           refreshControl?.attributedTitle = NSAttributedString(string: "Refresh")
           refreshControl?.tintColor = .gray
           refreshControl?.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        homeTblVw.refreshControl = refreshControl
    }

    @objc private func refreshTableData() {
        // Call your API
#if Backapacker
        
        self.HomeApiCall()
#endif
      
    }

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
extension BackPackerHomeVC : LocationManagerDelegate {
    func didFailWithError(_ error: Error) {
            print("❌ Failed to get location: \(error.localizedDescription)")
        }
    
    func didUpdateLocation(_ location: CLLocation) {
          let latitude = location.coordinate.latitude
          let longitude = location.coordinate.longitude
          print("📍 ViewController Received Location: \(latitude), \(longitude)")
        self.lat = latitude
        self.long =  longitude
          // You can now use latitude and longitude here
      }

    
}
extension BackPackerHomeVC {
    
#if Backapacker
    
    func HomeApiCall(){
        if let lat = LocationManager.shared.latitude,
           let long = LocationManager.shared.longitude {
            print("Controller accessed lat: \(lat), long: \(long)")
            self.lat = lat
            self.long = long
        } else {
            print("Location not yet available")
        }
        LoaderManager.shared.show()
        
        viewModel.getBackpackerHomeData(lat: self.lat ?? 0.0, long: self.long ?? 0.0) { [weak self] success, data, message, statusCode in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                guard let statusCode = statusCode else {
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                    return
                }
                let httpStatus = HTTPStatusCode(rawValue: statusCode)
                
                DispatchQueue.main.async {
                    
                    switch httpStatus {
                    case .ok, .created:
                        if success == true {
                            self.homeData = data
                            DispatchQueue.main.async {
                                self.homeTblVw.reloadData()
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                            self.refreshControl?.endRefreshing()
                            self.homeTblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.HomeApiCall()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                                
                            }
                        }
                        
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.HomeApiCall()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                        
                        
                    case .unauthorizedToken, .methodNotAllowed, .internalServerError:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
#endif
}
