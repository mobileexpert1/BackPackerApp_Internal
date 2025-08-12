//
//  JobAllListVC.swift
//  Backpacker
//
//  Created by Mobile on 06/08/25.
//

import UIKit

class JobAllListVC: UIViewController {

    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var seacrhVw: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var mainHeader: UILabel!
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

        self.setUpUI()
        self.setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getListOfAll()
    }
  
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension JobAllListVC: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.onTap = { [weak self] val  in
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
            cell.onTap = { [weak self] val in
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
            cell.onTap = { [weak self] val in
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
        self.tblVw.refreshControl = refreshControl
    }
    
    @objc private func refreshTableData() {
        // Show the default spinner, reload after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tblVw.reloadData()
            self.refreshControl.endRefreshing() // Hide the spinner
            self.tblVw.setContentOffset(.zero, animated: true)
        }
    }

    func setUpUI(){
        self.mainHeader.text = "Jobs"
        self.mainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.seacrhVw.layer.cornerRadius = 25.0
        self.seacrhVw.layer.borderWidth = 0.8
        self.seacrhVw.layer.borderColor = UIColor(hex: "#000000").cgColor
        txtFldSearch.delegate = self
        txtFldSearch.attributedPlaceholder = NSAttributedString(
            string: "Search Jobs",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: FontManager.inter(.regular, size: 14.0)
            ])
        let nib = UINib(nibName: "HomeTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "HomeTVC")
        tblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        tblVw.showsVerticalScrollIndicator = false
        tblVw.showsHorizontalScrollIndicator = false
        tblVw.contentInset = .zero
        tblVw.sectionHeaderTopPadding = 0 // for iOS 15+
    }

}



extension JobAllListVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFldSearch.resignFirstResponder()
        return true
    }
}


extension JobAllListVC {
    
    
    
    func getListOfAll(){
        let trimmedSearch = txtFldSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        LoaderManager.shared.show()
        viewModel.getJobListSeeAll(page: 1, perPage: 10, search: trimmedSearch ?? "")  { [weak self] (success: Bool, result: JobListResponse?, statusCode: Int?) in
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
                            self.tblVw.reloadData()
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfAll()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.tblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.tblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.tblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                }
            }
            }
    }
}
