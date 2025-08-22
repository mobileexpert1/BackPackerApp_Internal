//
//  EmployerHomeVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit
import SkeletonView
class EmployerHomeVC: UIViewController {

    @IBOutlet weak var lblnodataFound: UILabel!
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
    let viewModel = EmployerHomeVM()
    let viewModelAuth = LogInVM()
    var homeData : EmployerHomeData?
    var refreshControl: UIRefreshControl?
    var isLoading : Bool = true
    var jobID = String()
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    var activeSections: [SectionType] {
        var sections: [SectionType] = []
        
#if BackpackerHire
        if role == "2"{
            sections.append(.banner)
            if let accommodations = homeData?.jobslist, !accommodations.isEmpty {
                sections.append(.jobs)
            }
        }
#endif
        return sections
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblnodataFound.isHidden = true
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
        let nib4 = UINib(nibName: "SkeltonTVC", bundle: nil)
        self.tblVw.register(nib4, forCellReuseIdentifier: "SkeltonTVC")
        
        let nib5 = UINib(nibName: "SkeltonCollectionTVC", bundle: nil)
        self.tblVw.register(nib5, forCellReuseIdentifier: "SkeltonCollectionTVC")
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
        self.setupPullToRefresh()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if BackpackerHire
        if roleType == "2"{
            self.HomeApi()
        }
        if roleType == "4"{
            self.HomeApi()
        }
#endif
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
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
           refreshControl?.attributedTitle = NSAttributedString(string: "Refresh")
           refreshControl?.tintColor = .gray
           refreshControl?.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tblVw.refreshControl = refreshControl
    }

    @objc private func refreshTableData() {
        // Call your API
#if BackpackerHire
        self.isLoading = true
        LoaderManager.shared.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.HomeApi()
        }
#endif
    }
   
}

extension EmployerHomeVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading == true {
            return 4
        }else{
//            return sectionTitles.count
            let count = activeSections.count
            if count == 0{
                return 0
            }else{
                return count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading == true {
            
            return 1
        }else{
            
            let sectionType = activeSections[section]
            
            switch sectionType {
            case .banner:
                return 1
            case .jobs:
                return 1
                
            case .hangouts:
                return 1
                
            case .accommodations:
                return 1
            }
            
            
            
        }
        
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
            let sectionType = activeSections[indexPath.section]
            
            switch sectionType {
            case .banner:
                if roleType == "2"{
                    
              //      if indexPath.section == 0  {
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                            return UITableViewCell()
                        }
                        cell.isComeForHireDetailPage = false
                //        let sectionItems = itemsPerSection[indexPath.section]
                        cell.configure(with: sectionTitles,section: indexPath.section)
                        // Handle final callback here
                            cell.onAddAccommodation = { [weak self] val  in
                                self?.moveToAddAccomodationVC()
                            }
                        
                        cell.onTapAcceptJob = { index in
                            print("Tapped index total: \(index)")
                      //      self.HandleNavigationforAcceptDelinedJob(in: index)
                        }
                        cell.totalJobCount = homeData?.totalJobs ?? 0
                        cell.declinedJobCount = homeData?.declinedJobs ?? 0
                        cell.acceptedJobCount = homeData?.acceptedJobs ?? 0
                    cell.activeSections = activeSections
                        return cell
                   
                }else{
                    if indexPath.section == 0 || indexPath.section == 1 {
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                            return UITableViewCell()
                        }
                        cell.isComeForHireDetailPage = false
                //        let sectionItems = itemsPerSection[indexPath.section]
                        cell.configure(with: sectionTitles,section: indexPath.section)
                        // Handle final callback here
                            cell.onAddAccommodation = { [weak self] val  in
                                self?.moveToAddAccomodationVC()
                            }
                        
                        cell.onTapAcceptJob = { index in
                            print("Tapped index total: \(index)")
                            self.HandleNavigationforAcceptDelinedJob(in: index)
                        }
                        cell.activeSections = activeSections
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
                
                
            case .jobs:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                if role == "2"{
                    cell.isComeForHireDetailPage = false
            //        let sectionItems = itemsPerSection[indexPath.section]
                    cell.employerJobList = self.homeData?.jobslist
                    cell.configure(with: sectionTitles,section: indexPath.section)
                    // Handle final callback here
                        cell.onAddAccommodation = { [weak self] val  in
                            self?.moveToAddAccomodationVC()
                        }
                    
                    cell.onTapAcceptJob = { index in
                        print("Tapped index total: \(index)")
                        self.HandleNavigationforAcceptDelinedJob(in: index)
                    }
                    
                    cell.onTap = { index in
                        print("Tapped index total: \(index)")
                        let id = self.homeData?.jobslist?[index].id
                        self.jobID = id ?? ""
                        self.navigateToDescriptionVC()
                    }
                    cell.activeSections = activeSections
                }else{
                    cell.isComeForHireDetailPage = false
            //        let sectionItems = itemsPerSection[indexPath.section]
                    cell.configure(with: sectionTitles,section: indexPath.section)
                    // Handle final callback here
                        cell.onAddAccommodation = { [weak self] val  in
                            self?.moveToAddAccomodationVC()
                        }
                    
                    cell.onTapAcceptJob = { index in
                        print("Tapped index total: \(index)")
                        self.HandleNavigationforAcceptDelinedJob(in: index)
                    }
                    cell.activeSections = activeSections
                }
               
                return cell
                
                
            case .hangouts:
                break
                
            case .accommodations:
                
                break
            }
        }
        
        
        return UITableViewCell()
        
        
       
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.titleLaBLE.text = sectionTitles[section]
        header.section = section
        header.contentView.backgroundColor = .white // prevent background flicker
#if BackpackerHire
        
        if roleType == "2"{
           
            header.headerButton.isHidden = true
            header.headerButton.isUserInteractionEnabled = false
        }
#endif
        header.onButtonTap = { [weak self] tappedSection in
            
            self?.handleHeaderButtonTap(in: tappedSection)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading{
            return 0.0
        }
        if section == 0 {
            return 0.0
        }
        if self.homeData?.jobslist?.count ?? 0 > 0 {
            return 40
        }else{
            return 0
        }
       
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            if isLoading {
                return 180
            }
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
extension EmployerHomeVC{
    
    func HomeApi(){
        LoaderManager.shared.show()
        
        viewModel.getEmployerHomeData() { [weak self] success, data, message, statusCode in
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
                            if data != nil {
                                
                                self.homeData = data
                                
                                    self.isLoading = false
                            }else{
                                self.showNoData(isShow: true)
                            }
                           
                            if self.homeData?.name?.isEmpty == true && self.homeData?.email?.isEmpty == true{
                                self.showForceUpdatePopUp()
                            }
                            DispatchQueue.main.async {
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.tblVw.setContentOffset(.zero, animated: true)
                                self.tblVw.reloadData()
                            }
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                        self.refreshControl?.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.HomeApi()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl?.endRefreshing()
                                self.tblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.tblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl?.endRefreshing()
                        self.tblVw.setContentOffset(.zero, animated: true)
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
}
extension  EmployerHomeVC: SkeletonTableViewDataSource {
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
    
    private func showNoData(isShow : Bool = false){
        if isShow == true{
            self.lblnodataFound.isHidden = false
        }else{
            self.lblnodataFound.isHidden = true
        }
    }
    private func navigateToDescriptionVC(){
        if self.jobID.isEmpty == false{
            let storyboard = UIStoryboard(name: "Job", bundle: nil)
            if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
                jobDescriptionVC.JobId = self.jobID
                // Optional: pass selected job title
                self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
            }
        }
    }
}
