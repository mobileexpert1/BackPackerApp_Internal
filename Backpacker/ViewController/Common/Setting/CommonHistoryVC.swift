//
//  CommonHistoryVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit

class CommonHistoryVC: UIViewController {

//    @IBOutlet weak var lbl_ManHeader: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    var selectedIndex : Int = 0
    var sectionTitles = ["Accepted", "Rejected"]
    var viewModel = HistoryViewModel()
    let viewModelAuth = LogInVM()
    var isLoading : Bool = true
    var page = 1
    let perPage = 10
    var totalJobs = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var lastContentOffset: CGFloat = 0
    private let refreshControl = UIRefreshControl()
    var searchData: [EmpBackpacker] = []
    var jobsearchData: [EmpJob] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_NoDataFound.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_NoDataFound.text = "No Data Found"
        self.lbl_NoDataFound.isHidden = true
        tblVw.showsVerticalScrollIndicator = false
        tblVw.showsHorizontalScrollIndicator = false
        tblVw.contentInset = .zero
        tblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        let nib = UINib(nibName: "CommonEmpListTVC", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "CommonEmpListTVC")
        
        let nib2 = UINib(nibName: "CommonHistoryTVC", bundle: nil)
        tblVw.register(nib2, forCellReuseIdentifier: "CommonHistoryTVC")
        tblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        self.setUpRefreshControl()
        if selectedIndex == 0 {
            self.getBackpackerList()
        }else{
            self.getCompletedJObsList()
        }
      
    }
    func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tblVw.refreshControl = refreshControl
    }
    @objc func handleRefresh() {
        self.page = 1
        self.isAllDataLoaded = false
        self.isLoadingMoreData = false
        self.isLoading = true
        
        // Start refreshing UI
        self.refreshControl.beginRefreshing()
        isComeFromPullTorefresh = true
        removeTableFooterView()
        // Fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            if self.selectedIndex == 0 {
                self.getBackpackerList()
            }else{
                self.getCompletedJObsList()
            }
        }
        
    }
    func removeTableFooterView() {
        tblVw.tableFooterView = nil
    }
    func createTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tblVw.frame.width, height: 60))
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading more backpackers..."
        label.font = FontManager.inter(.medium, size: 12.0)
        label.textColor = .gray
        
        footerView.addSubview(spinner)
        footerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            // Spinner centered horizontally at the top
            spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            
            // Label below spinner
            label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            
            // Footer bottom anchor tied to label
            label.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])
        
        
        return footerView
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension CommonHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedIndex == 1{
            return 1// or your dataArray.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return self.searchData.count
        }else{
            return 1
        }
          
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if selectedIndex == 0{
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonEmpListTVC", for: indexPath) as? CommonEmpListTVC else {
                   return UITableViewCell()
               }
                   let backpacker = searchData[indexPath.row]
                   if backpacker.name.isEmpty == true{
                       cell.lbl_Name.text = backpacker.mobileNumber
                       let digit = firstDigit(of: backpacker.mobileNumber)
                       cell.lbl_FrstLetter.text = digit
                   }else{
                       cell.lbl_Name.text = backpacker.name
                       let initials = getInitials(from: backpacker.name)
                       cell.lbl_FrstLetter.text = initials
                   }
               cell.lbl_CompletedJobs.text = "Job Completed - \(backpacker.totalJobs)"
               cell.cosmosVw.rating = Double(backpacker.averageRating)
               return cell
           }else{
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonHistoryTVC", for: indexPath) as? CommonHistoryTVC else {
                   return UITableViewCell()
               }
               cell.jobdata = self.jobsearchData
               return cell
           }
          
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           // Perform navigation or action here
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == 1  {
            let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 49
            return UIScreen.main.bounds.height - tabBarHeight - 20
        }else{
            return UITableView.automaticDimension
        }
      
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            return
        }
        
        // Detect scroll direction
        let isScrollingDown = scrollView.contentOffset.y > lastContentOffset
        lastContentOffset = scrollView.contentOffset.y
        
        // Only proceed if scrolling down
        guard isScrollingDown else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
     
        if offsetY > contentHeight - frameHeight - 300 {
            if isComeFromPullTorefresh == false{
                if !isLoading && !isLoadingMoreData && !isAllDataLoaded {
                    isLoadingMoreData = true
                    page += 1
                    tblVw.tableFooterView = createTableFooterView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ){
                        if self.selectedIndex == 0{
                            self.getBackpackerList()
                        }else{
                            self.getCompletedJObsList()
                        }
                        
                    }
                    
                }
            }
            
        }
    }
    func firstDigit(of number: String) -> String {
        return number.first.map { String($0) } ?? ""
    }
    func getInitials(from name: String) -> String {
        return name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .compactMap { $0.first?.uppercased() }
            .joined()
    }
}


extension CommonHistoryVC {
    
    func getBackpackerList(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            tblVw.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        viewModel.getEmpBackpackersList(page: page, perPage: perPage) { [weak self] (success: Bool, result: EmpBackpackerListResponse?, statusCode: Int?) in
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
                            if success, let list = result?.data?.backpackers {
                                if self.page == 1 {
                                    if list.isEmpty {
                                        self.lbl_NoDataFound.isHidden = false
                                        self.searchData.removeAll()
                                        self.searchData = list
                                    } else {
                                        
                                        self.isLoading = false
                                        self.searchData = list
                                    }
                                } else {
                                    
                                    self.isLoading = false
                                    self.searchData.append(contentsOf: list)
                                }
                                self.totalJobs = result?.data?.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = list.count < self.perPage
                                if self.isAllDataLoaded == true {
                                    self.removeTableFooterView()
                                }
                                self.isComeFromPullTorefresh = false
                                self.isLoadingMoreData = false
                                self.tblVw.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                           
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                        if self.searchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                        self.removeTableFooterView()
                        self.tblVw.reloadData()
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.searchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getBackpackerList()
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
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                        if self.searchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.searchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.searchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    }
                }
            }
        }
    }
    func getCompletedJObsList(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            tblVw.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        viewModel.getEmpCompletedJobs(page: page, perPage: perPage) { [weak self] (success: Bool, result: EmpJobsListResponse?, statusCode: Int?) in
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
                            if success, let list = result?.data?.jobs {
                                if self.page == 1 {
                                    if list.isEmpty {
                                        self.lbl_NoDataFound.isHidden = false
                                        self.jobsearchData.removeAll()
                                        self.jobsearchData = list
                                    } else {
                                        
                                        self.isLoading = false
                                        self.jobsearchData = list
                                    }
                                } else {
                                    
                                    self.isLoading = false
                                    self.jobsearchData.append(contentsOf: list)
                                }
                                self.totalJobs = result?.data?.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = list.count < self.perPage
                                if self.isAllDataLoaded == true {
                                    self.removeTableFooterView()
                                }
                                self.isComeFromPullTorefresh = false
                                self.isLoadingMoreData = false
                                self.tblVw.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                           
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                        if self.jobsearchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                        self.removeTableFooterView()
                        self.tblVw.reloadData()
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.jobsearchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getCompletedJObsList()
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
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                        if self.jobsearchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.jobsearchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.jobsearchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
                    }
                }
            }
        }
    }
}
