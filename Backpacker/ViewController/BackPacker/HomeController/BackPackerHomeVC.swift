//
//  BackPackerHomeVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import CoreLocation
import SkeletonView
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
    
    private let viewModelEmpAccomodationHome = AccommodationViewModel()
    
    private var accomdationEmpHomeData: EmployerAccommodationData?
    private let viewModelEmpHangoutHome = HangoutViewModel()
    private var hangoutEmpHomeData: EmployerHangoutData?
    var isLoading: Bool = true // true while loading, false once data is ready
    var jobId = String()
    
    var activeSections: [SectionType] {
        var sections: [SectionType] = []
        
#if BackpackerHire
        if role == "3"{
            if let banners = accomdationEmpHomeData?.banners, !banners.isEmpty {
                sections.append(.banner)
            }
            if let accommodations = accomdationEmpHomeData?.accommodationList, !accommodations.isEmpty {
                sections.append(.accommodations)
            }
        }
        
        
        if role == "4"{
            if let banners = hangoutEmpHomeData?.banners, !banners.isEmpty {
                sections.append(.banner)
            }
            if let accommodations = hangoutEmpHomeData?.hangoutList, !accommodations.isEmpty {
                sections.append(.hangouts)
            }
        }
       
       
        
        
        #else
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
        
#endif
       
        
        return sections
    }
    var lat : Double?
    var long : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPullToRefresh()
        Vw_SearchHeight.constant = 0.0
        txtFldVw.isHidden = true
        img_placeholde_Search.isHidden = true
        self.vw_searchBtm.constant = 5.0
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
        
        let nib4 = UINib(nibName: "SkeltonTVC", bundle: nil)
        self.homeTblVw.register(nib4, forCellReuseIdentifier: "SkeltonTVC")
        
        let nib5 = UINib(nibName: "SkeltonCollectionTVC", bundle: nil)
        self.homeTblVw.register(nib5, forCellReuseIdentifier: "SkeltonCollectionTVC")
        
        
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
        self.setUpUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if Backapacker
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            LoaderManager.shared.show()
            self.HomeApiCall()
        }
#endif
        
        
#if BackpackerHire
        if role == "3"{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                LoaderManager.shared.show()
                self.EmployerAccomodationHome()
            }
            
           
        }
        
        if role == "4"{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                LoaderManager.shared.show()
                self.EmployerHangoutApiCall()
            }
            
           
        }
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
        
           if isLoading {
            return 4 // Show 5 skeleton cells (or however many you want)
        } else {
        let count = activeSections.count
        if count == 0{
            return 0
        }else{
            return count
        }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            if indexPath.section == 0{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SkeltonTVC", for: indexPath) as? SkeltonTVC else {
                    return UITableViewCell()
                }
                return cell
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SkeltonCollectionTVC", for: indexPath) as? SkeltonCollectionTVC else {
                    return UITableViewCell()
                }
                return cell
                
            }
        }else{
            
    #if BackpackerHire
            let sectionType = activeSections[indexPath.section]
            
            switch sectionType {
            case .banner:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertiesmentTVC", for: indexPath) as? AdvertiesmentTVC else {
                    return UITableViewCell()
                }
                if role == "3"{
                    let adsData = accomdationEmpHomeData?.banners
                    if let adsData  = adsData {
                        cell.ads = adsData
                    }
                }
                
                if role == "4"{
                    let adsData = hangoutEmpHomeData?.banners
                    if let adsData  = adsData {
                        cell.ads = adsData
                    }
                }
                return cell
                
            case .jobs:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                cell.configure(with: sectionTitles,section: indexPath.section)
                cell.isComeFromJob = false
                cell.isComeForHireDetailPage = false
                // Handle final callback here
                cell.onAddAccommodation = { [weak self] val  in
                    
                    
                }
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
                cell.onHangOut = { [weak self] val  in
                    print("ASccomodation Item",val)
                    let id = self?.hangoutEmpHomeData?.hangoutList[val].id
                    self?.moveToDetailPage(id: id ?? "", isComeFromHangOut: true)
                }
                cell.hangoutList = hangoutEmpHomeData?.hangoutList
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
                cell.onAddAccommodation = { [weak self] val  in
                    print("ASccomodation Item",val)
                    let id = self?.accomdationEmpHomeData?.accommodationList[val].id
                    self?.moveToDetailPage(id: id ?? "", isComeFromHangOut: false)
                }
                cell.accomodationList = accomdationEmpHomeData?.accommodationList
                cell.activeSections = activeSections
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
//                cell.onAddAccommodation = { [weak self] in
//                    
//                  
//                }
                cell.onTap  = { [weak self] val in
                    if let id =  self?.homeData?.jobslist[val].id {
                        print("Cell tapped at index: \(id)")
                        self?.jobId = id
                        self?.navigateToDescriptionVC()
                    }
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
                cell.onHangOut = { [weak self] val in
                    print("Hangout Item",val)
                    let id = self?.homeData?.hangoutList[val].id
                    self?.moveToDetailPage(id: id ?? "", isComeFromHangOut: true)
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
                cell.onAddAccommodation = { [weak self] val in
                    print("ASccomodation Item",val)
                    let id = self?.homeData?.accommodationList[val].id
                    self?.moveToDetailPage(id: id ?? "", isComeFromHangOut: false)
                  
                }
                cell.accomodationList = homeData?.accommodationList  ?? []
                cell.activeSections = activeSections
                return cell
            }
    #endif
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionType = activeSections[section]
        switch sectionType {
        case .banner:
            return nil // ✅ Don’t return header view for banner
        default:
            break
        }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.section = section
        header.contentView.backgroundColor = .white
        header.headerButton.isUserInteractionEnabled = false
        header.headerButton.isHidden = true
        switch sectionType {
        case .accommodations:
            header.titleLaBLE.text = "Accommodations"
        case .hangouts:
#if BackpackerHire
            header.titleLaBLE.text = "Hangouts"
#else
            header.titleLaBLE.text = "Backpacker Hangout"
            
#endif
            
        case .jobs:
            header.titleLaBLE.text = "Jobs"
        default:
            break
        }
        header.onButtonTap = { [weak self] tappedSection in
            self?.handleHeaderButtonTap(in: tappedSection,title: header.titleLaBLE.text ?? "")
        }
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 0.0
        }else{
        let sectionType = activeSections[section]
        switch sectionType {
        case .banner:
            return 0
        case .accommodations, .hangouts, .jobs:
            return 40
        }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading == true  {
            if indexPath.section == 0 {
                return 160
            }else{
                return 200
            }
           
            
        }else{
            if indexPath.section == 0 {
#if BackpackerHire
                    let sectionType = activeSections[indexPath.section]
                    switch sectionType {
                    case .banner:
                        return 160
                    case .accommodations:
                        return 230
                    case  .hangouts:
                        return 210
                    case .jobs :
                        return 180
                    }
                #else
                let sectionType = activeSections[indexPath.section]
                switch sectionType {
                case .banner:
                    return 160
                case .accommodations:
                    return 230
                case  .hangouts:
                    return 210
                case .jobs :
                    return 180
                }
#endif
              
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
                    return 210
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
                    return 210
                case .jobs :
                    return 180
                }
               
            }
            else{
                return 195
            }
            
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
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.HomeApiCall()
        }
        #else
        if role == "3"{
            self.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                self.EmployerAccomodationHome()
            }
        }
        if role == "4"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                LoaderManager.shared.show()
                self.EmployerHangoutApiCall()
            }
        }
       
#endif
      
    }

    private func handleHeaderButtonTap(in section: Int,title:String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if title == "Accommodations" {
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromHomeAccomodation = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            
        }else if title == "Backpacker Hangout"{
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromHomeHangout = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            
        }else if title == "Jobs"{
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "JobAllListVC") as? JobAllListVC {
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
        }
    }
   private func moveToDetailPage(id:String,isComeFromHangOut: Bool = false){
        if id.isEmpty == false {
            if isComeFromHangOut == false {
                let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
                if let accVC = storyboard.instantiateViewController(withIdentifier: "AccomodationDetailVC") as? AccomodationDetailVC {
                    accVC.accomodationID = id
                    self.navigationController?.pushViewController(accVC, animated: true)
                } else {
                    print("❌ Could not instantiate AddNewAccomodationVC")
                }
            }else{
                let storyboard = UIStoryboard(name: "HangOut", bundle: nil)
                if let accVC = storyboard.instantiateViewController(withIdentifier: "HangOutDetailVC") as? HangOutDetailVC {
                    accVC.hangoutID = id
                    self.navigationController?.pushViewController(accVC, animated: true)
                } else {
                    print("❌ Could not instantiate AddNewAccomodationVC")
                }
            }
            
           
        }
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
                            if self.homeData?.name.isEmpty == true && self.homeData?.email.isEmpty == true{
                                self.showForceUpdatePopUp()
                            }
                            DispatchQueue.main.async {
                                self.isLoading = false
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                self.homeTblVw.reloadData()
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                            self.refreshControl?.endRefreshing()
                            self.homeTblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
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
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    }
                }
            }
        }
    }
    
#endif
}


extension  BackPackerHomeVC: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
           return 2 // Or your actual section count
       }

       func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }

       func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
           if indexPath.section == 2 {
               return "SkeltonCollectionTVC"
           } else {
               return "SkeltonTVC"
           }
       }
    
    
    func showForceUpdatePopUp(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForceUpdateVC") as! ForceUpdateVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    private func navigateToDescriptionVC(){
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
               jobDescriptionVC.JobId = self.jobId
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
    }
}

extension BackPackerHomeVC {
#if BackpackerHire
    func EmployerAccomodationHome(){
        LoaderManager.shared.show()
        viewModelEmpAccomodationHome.getEmployerAccommodationHomeData() { [weak self] success, data, message, statusCode in
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
                            self.accomdationEmpHomeData = data
                            if self.accomdationEmpHomeData?.name.isEmpty == true && self.accomdationEmpHomeData?.email.isEmpty == true{
                                self.showForceUpdatePopUp()
                            }
                            DispatchQueue.main.async {
                                self.isLoading = false
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                self.homeTblVw.reloadData()
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                            self.refreshControl?.endRefreshing()
                            self.homeTblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.EmployerAccomodationHome()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    }
                }
            }
        }
    }
    
    
    func EmployerHangoutApiCall(){
        LoaderManager.shared.show()
        viewModelEmpHangoutHome.getEmployerHangOutHomeData() { [weak self] success, data, message, statusCode in
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
                            self.hangoutEmpHomeData = data
                            if self.hangoutEmpHomeData?.name.isEmpty == true && self.hangoutEmpHomeData?.email.isEmpty == true{
                                self.showForceUpdatePopUp()
                            }
                            DispatchQueue.main.async {
                                self.isLoading = false
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                self.homeTblVw.reloadData()
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                            self.refreshControl?.endRefreshing()
                            self.homeTblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.EmployerHangoutApiCall()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.homeTblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.homeTblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    }
                }
            }
        }
        
        
    }
    
    #endif
    
    private func moveToDetail(id : String){
        if id.isEmpty == false {
            let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "AccomodationDetailVC") as? AccomodationDetailVC {
                accVC.accomodationID = id
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("❌ Could not instantiate AddNewAccomodationVC")
            }
        }
    }
}
