//
//  HomeVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit
import SkeletonView
class HomeVC: UIViewController {
    
   let sectionTitles = ["Current Jobs","New Jobs","Declined Jobs"]
    
    @IBOutlet weak var lbl_noJobs: UILabel!
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
    
    let viewModel = JobVM()
    let viewModelAuth = LogInVM()
    var isLoading: Bool = true // true while loading, false once data is ready
    var jobId = String()
    private var JobData: JobListResponse?
    private var EmployerJobData: EmployerJobsResponse?
    var activeSections: [SectionTypeList] {
        var sections: [SectionTypeList] = []
#if BackpackerHire
        if let currentJobslist = EmployerJobData?.data?.currentJobslist, !currentJobslist.isEmpty {
            sections.append(.currentJob)
        }
        if let newJobslist = EmployerJobData?.data?.upcomingJobList, !newJobslist.isEmpty {
            sections.append(.upcomingJob)
        }
      
        if let declineJobslist = EmployerJobData?.data?.postedJobList, !declineJobslist.isEmpty {
            sections.append(.declinedJobs)
        }
#else
        if let currentJobslist = JobData?.data.currentJobslist, !currentJobslist.isEmpty {
            sections.append(.currentJob)
        }
        if let newJobslist = JobData?.data.newJobslist, !newJobslist.isEmpty {
            sections.append(.upcomingJob)
        }
      
        if let declineJobslist = JobData?.data.declinedJobslist, !declineJobslist.isEmpty {
            sections.append(.declinedJobs)
        }
#endif
        
        
        
        
       
        return sections
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setUpUI()
        //  LoaderManager.shared.show()
        self.setupPullToRefresh()
        self.lbl_noJobs.font = FontManager.inter(.medium, size: 15.0)
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
        let nib5 = UINib(nibName: "SkeltonCollectionTVC", bundle: nil)
        self.home_TblVw.register(nib5, forCellReuseIdentifier: "SkeltonCollectionTVC")
        self.lbl_noJobs.isHidden = true
#if BackpackerHire
        self.getEmployerJobList()
        
#else
        self.getListOfAll()
#endif
       
   
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        self.home_TblVw.refreshControl = refreshControl
    }
    
    @objc private func refreshTableData() {
        // Show the default spinner, reload after delay
        self.isLoading = true
        self.refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
#if BackpackerHire
        self.getEmployerJobList()
        
#else
        self.getListOfAll()
#endif
        }
        
       
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
        if isLoading {
         return 4 // Show 5 skeleton cells (or however many you want)
        }else{
            //#if Backapacker
     let count = activeSections.count
     if count == 0{
         return 0
     }else{
         return count
     }
      
//#else
//        return sectionTitles.count
//        
//#endif
        }

        
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SkeltonCollectionTVC", for: indexPath) as? SkeltonCollectionTVC else {
                    return UITableViewCell()
                }
                return cell
             

        }else{
            
            let sectionType = activeSections[indexPath.section]
            
            switch sectionType {
            case .currentJob:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                let sectionItems = itemsPerSection[indexPath.section]
                cell.configure(with: sectionItems,section: indexPath.section)
                
#if BackpackerHire
                
                cell.isComeFromJob = true
                cell.isComeForHireDetailPage = false
                cell.isComeFromJobListSeeAll = true
                cell.empCurrentJobslist = EmployerJobData?.data?.currentJobslist
                cell.activeSectionsList = self.activeSections
                cell.onTap = { [weak self] val in
                        guard let self = self else { return }
                        print("Cell tapped at index----------: \(indexPath.item)")
                        // Navigate or perform any action
                    if let id =  EmployerJobData?.data?.currentJobslist?[val].id {
                        print("Cell tapped at index: \(id)")
                        self.jobId = id
                        self.navigateToDescriptionVC()
                    }
                   
                    }
#else
                cell.isComeFromJob = true
                cell.isComeForHireDetailPage = false
                cell.isComeFromJobListSeeAll = true
                cell.currentJobslist = JobData?.data.currentJobslist
                cell.activeSectionsList = self.activeSections
                cell.onTap = { [weak self] val in
                        guard let self = self else { return }
                        print("Cell tapped at index----------: \(indexPath.item)")
                        // Navigate or perform any action
                    if let id = JobData?.data.currentJobslist[val].id {
                        print("Cell tapped at index: \(id)")
                        self.jobId = id
                        self.navigateToDescriptionVC()
                    }
                   
                    }
                
#endif
                
               
                return cell
                
            case .upcomingJob:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                let sectionItems = itemsPerSection[indexPath.section]
                cell.configure(with: sectionItems,section: indexPath.section)
#if BackpackerHire
                cell.isComeFromJob = true
                cell.isComeFromJobListSeeAll = true
                cell.isComeForHireDetailPage = false
                cell.empNewjobList = EmployerJobData?.data?.upcomingJobList
                cell.activeSectionsList = self.activeSections
                cell.onTap = { [weak self] val in
                        guard let self = self else { return }
                        print("Cell tapped at index----------: \(indexPath.item)")
                        // Navigate or perform any action
                    if let id = EmployerJobData?.data?.upcomingJobList?[val].id {
                        print("Cell tapped at index: \(id)")
                        self.jobId = id
                        self.navigateToDescriptionVC()
                    }
                   
                    }
                
#else
                cell.isComeFromJob = true
                cell.isComeFromJobListSeeAll = true
                cell.isComeForHireDetailPage = false
                cell.onTap = { [weak self] val in
                        guard let self = self else { return }
                        print("Cell tapped at index------------: \(indexPath.item)")
                        // Navigate or perform any action
                    if let id = JobData?.data.newJobslist[val].id {
                        print("Cell tapped at index: \(id)")
                        self.jobId = id
                        self.navigateToDescriptionVC()
                    }
                    }
                cell.newjobList = JobData?.data.newJobslist
                cell.activeSectionsList = self.activeSections
#endif
                
                
             
                return cell
                
            case .declinedJobs:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                let sectionItems = itemsPerSection[indexPath.section]
                cell.configure(with: sectionItems,section: indexPath.section)
#if BackpackerHire
                cell.isComeFromJob = true
                cell.isComeForHireDetailPage = false
                cell.isComeFromJobListSeeAll = true
                cell.empPostedjobList = EmployerJobData?.data?.postedJobList
                cell.activeSectionsList = self.activeSections
                cell.onTap = { [weak self] val in
                        guard let self = self else { return }
                        print("Cell tapped at index----------: \(indexPath.item)")
                        // Navigate or perform any action
                    if let id =  EmployerJobData?.data?.postedJobList?[val].id {
                        print("Cell tapped at index: \(id)")
                        self.jobId = id
                        self.navigateToDescriptionVC()
                    }
                   
                    }
                
                
#else
                cell.isComeFromJob = true
                cell.isComeForHireDetailPage = false
                cell.isComeFromJobListSeeAll = true
                cell.onTap = { [weak self] val in
                        guard let self = self else { return }
                        print("Cell tapped at index----------: \(indexPath.item)")
                        // Navigate or perform any action
                    if let id = JobData?.data.declinedJobslist[val].id {
                        print("Cell tapped at index: \(id)")
                        self.jobId = id
                        self.navigateToDescriptionVC()
                    }
                    }
                cell.declinedjobList = JobData?.data.declinedJobslist
                cell.activeSectionsList = self.activeSections
                
                
#endif
                
               
                return cell
                
            }
        }
     
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.section = section
        header.contentView.backgroundColor = .white
        let sectionType = activeSections[section]
        switch sectionType {
        case .currentJob:
#if BackpackerHire
            header.titleLaBLE.text = "Current Jobs"
#else
            header.titleLaBLE.text = "Current Jobs"
#endif
        case .upcomingJob:
#if BackpackerHire
            header.titleLaBLE.text = "Upcoming"
#else
            header.titleLaBLE.text = "New Jobs"
#endif
          
        case .declinedJobs:
#if BackpackerHire
            header.titleLaBLE.text = "Posted"
#else
            header.titleLaBLE.text = "Declined Jobs"
#endif
            
        default:
            break
        }
        header.onButtonTap = { [weak self] tappedSection in
            self?.handleHeaderButtonTap(in: tappedSection,title: header.titleLaBLE.text ?? "")
        }
        
        return header
    }
    
    private func handleHeaderButtonTap(in section: Int,title:String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
#if BackpackerHire
        if title == "Current Jobs" {
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromJobSections = true
                settingVC.isComeFromHomeAccomodation = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            
        }else if title == "Upcoming"{
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromHomeHangout = true
                settingVC.isComeFromJobSections = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            
        }else if title == "Posted"{
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromJobSections = true
                settingVC.isComeFromHomeJob = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
        }
        
#else
        if title == "Current Jobs" {
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromJobSections = true
                settingVC.isComeFromHomeAccomodation = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            
        }else if title == "New Jobs"{
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromHomeHangout = true
                settingVC.isComeFromJobSections = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
            
        }else if title == "Declined Jobs"{
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "CommonGridVC") as? CommonGridVC {
                settingVC.isComeFromJobSections = true
                settingVC.isComeFromHomeJob = true
                self.navigationController?.pushViewController(settingVC, animated: true)
            }
        }
#endif
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 0.0
        }else{
            return 40
        }
      
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 185
    }
    
    private func handleHeaderButtonTap(in section: Int) {
        print("Button tapped in section \(section)")
    }
    
    private func navigateToDescriptionVC(){
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
               jobDescriptionVC.JobId = self.jobId
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
    }
    
 
    func setUpUI(){
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
    }

}
extension HomeVC {
    
#if Backapacker
    func getListOfAll(){
        let trimmedSearch = ""
        
        LoaderManager.shared.show()
        viewModel.getJobListSeeAll(page: 1, perPage: 10, search: trimmedSearch)  { [weak self] (success: Bool, result: JobListResponse?, statusCode: Int?) in
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
                            self.JobData = result
                            self.isLoading = false
                            self.home_TblVw.reloadData()
                            self.refreshControl.endRefreshing()
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.home_TblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                        if self.JobData?.data.currentJobslist.count == 0 &&  self.JobData?.data.declinedJobslist.count == 0 &&
                            self.JobData?.data.newJobslist.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.JobData?.data.currentJobslist.count == 0 &&  self.JobData?.data.declinedJobslist.count == 0 &&
                            self.JobData?.data.newJobslist.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfAll()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.home_TblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.home_TblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.home_TblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                        if self.JobData?.data.currentJobslist.count == 0 &&  self.JobData?.data.declinedJobslist.count == 0 &&
                            self.JobData?.data.newJobslist.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.JobData?.data.currentJobslist.count == 0 &&  self.JobData?.data.declinedJobslist.count == 0 &&
                            self.JobData?.data.newJobslist.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.JobData?.data.currentJobslist.count == 0 &&  self.JobData?.data.declinedJobslist.count == 0 &&
                            self.JobData?.data.newJobslist.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    }
                }
            }
            }
    }
    
#endif
   
    
#if BackpackerHire
    
    func getEmployerJobList(){
        LoaderManager.shared.show()
        viewModel.getEmployerJobListSeeAll()  { [weak self] (success: Bool, result: EmployerJobsResponse?, statusCode: Int?) in
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
                            self.EmployerJobData = result
                            self.isLoading = false
                            self.home_TblVw.reloadData()
                            self.refreshControl.endRefreshing()
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.home_TblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                        if self.EmployerJobData?.data?.currentJobslist?.count == 0 &&  self.EmployerJobData?.data?.postedJobList?.count == 0 &&
                            self.EmployerJobData?.data?.upcomingJobList?.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.EmployerJobData?.data?.currentJobslist?.count == 0 &&  self.EmployerJobData?.data?.postedJobList?.count == 0 &&
                            self.EmployerJobData?.data?.upcomingJobList?.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getEmployerJobList()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.home_TblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.home_TblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.home_TblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                        if self.EmployerJobData?.data?.currentJobslist?.count == 0 &&  self.EmployerJobData?.data?.postedJobList?.count == 0 &&
                            self.EmployerJobData?.data?.upcomingJobList?.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.EmployerJobData?.data?.currentJobslist?.count == 0 &&  self.EmployerJobData?.data?.postedJobList?.count == 0 &&
                            self.EmployerJobData?.data?.upcomingJobList?.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.EmployerJobData?.data?.currentJobslist?.count == 0 &&  self.EmployerJobData?.data?.postedJobList?.count == 0 &&
                            self.EmployerJobData?.data?.upcomingJobList?.count == 0 {
                            self.lbl_noJobs.isHidden = false
                        }else{
                            self.lbl_noJobs.isHidden = true
                        }
                    }
                }
            }
            }
    }
    
#endif
}
extension  HomeVC: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
           return 2 // Or your actual section count
       }

       func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }

       func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
               return "SkeltonCollectionTVC"
          
       }
}

enum SectionTypeList {
    case currentJob
    case upcomingJob
    case declinedJobs
}

