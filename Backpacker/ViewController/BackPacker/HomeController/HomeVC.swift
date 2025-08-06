//
//  HomeVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit
import SkeletonView
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
    
    let viewModel = JobVM()
    let viewModelAuth = LogInVM()
    var isLoading: Bool = true // true while loading, false once data is ready
    private var JobData: JobListResponse?
    var activeSections: [SectionTypeList] {
        var sections: [SectionTypeList] = []
        if let currentJobslist = JobData?.data.currentJobslist, !currentJobslist.isEmpty {
            sections.append(.currentJob)
        }
        if let newJobslist = JobData?.data.newJobslist, !newJobslist.isEmpty {
            sections.append(.upcomingJob)
        }
      
        if let declineJobslist = JobData?.data.declinedJobslist, !declineJobslist.isEmpty {
            sections.append(.declinedJobs)
        }
        return sections
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setUpUI()
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
        let nib5 = UINib(nibName: "SkeltonCollectionTVC", bundle: nil)
        self.home_TblVw.register(nib5, forCellReuseIdentifier: "SkeltonCollectionTVC")
#if BackpackerHire
        print("BackpackerHire logic")
#else
        print("Backpacker  logic")
#endif
   
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getListOfAll()
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
                cell.isComeFromJob = true
                cell.isComeForHireDetailPage = false
                cell.isComeFromJobListSeeAll = true
                cell.onTap = { [weak self] in
                        guard let self = self else { return }
                        print("Cell tapped at index: \(indexPath.item)")
                        // Navigate or perform any action
                    self.navigateToDescriptionVC()
                    }
                cell.currentJobslist = JobData?.data.currentJobslist
                cell.activeSectionsList = self.activeSections
                return cell
                
            case .upcomingJob:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                let sectionItems = itemsPerSection[indexPath.section]
                cell.configure(with: sectionItems,section: indexPath.section)
                cell.isComeFromJob = true
                cell.isComeFromJobListSeeAll = true
                cell.isComeForHireDetailPage = false
                cell.onTap = { [weak self] in
                        guard let self = self else { return }
                        print("Cell tapped at index: \(indexPath.item)")
                        // Navigate or perform any action
                    self.navigateToDescriptionVC()
                    }
                cell.newjobList = JobData?.data.newJobslist
                cell.activeSectionsList = self.activeSections
                return cell
                
            case .declinedJobs:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
                    return UITableViewCell()
                }
                let sectionItems = itemsPerSection[indexPath.section]
                cell.configure(with: sectionItems,section: indexPath.section)
                cell.isComeFromJob = true
                cell.isComeForHireDetailPage = false
                cell.isComeFromJobListSeeAll = true
                cell.onTap = { [weak self] in
                        guard let self = self else { return }
                        print("Cell tapped at index: \(indexPath.item)")
                        // Navigate or perform any action
                    self.navigateToDescriptionVC()
                    }
                cell.declinedjobList = JobData?.data.declinedJobslist
                cell.activeSectionsList = self.activeSections
                return cell
                
            }
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
        if isLoading {
            return 0.0
        }else{
            return 40
        }
      
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 200
    }
    
    private func handleHeaderButtonTap(in section: Int) {
        print("Button tapped in section \(section)")
    }
    
    private func navigateToDescriptionVC(){
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
               
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.getListOfAll()
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
                    case .badRequest:
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfAll()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isLoading = false
                                self.home_TblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                        
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfAll()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isLoading = false
                                self.home_TblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                            }
                        }
                        
                        
                    case .unauthorizedToken, .methodNotAllowed, .internalServerError:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.isLoading = false
                        self.home_TblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.isLoading = false
                        self.home_TblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            }
    }
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
