//
//  NotificationVC.swift
//  Backpacker
//
//  Created by Sahil Sharma on 12/07/25.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var lbl_nodatafound: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblMainHeader: UILabel!
    var viewModel = NotificationViewModel()
    let viewModelAuth = LogInVM()
    let refreshControl = UIRefreshControl()
    var searchData: [NotificationItems] = []
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
    var isComFromSearch : Bool = false
    var jobId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_nodatafound.isHidden = true
        self.lbl_nodatafound.font = FontManager.inter(.medium, size: 16.0)
        self.lblMainHeader.font = FontManager.inter(.medium, size: 16.0)
        let nib = UINib(nibName: "NotificationTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "NotificationTVC")
        
        tblVw.delegate = self
        tblVw.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNotificationList()
    }
    @IBAction func action_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    // Number of sections in table (usually 1 unless grouping)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count // or your dataArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as? NotificationTVC else {
            return UITableViewCell()
        }

        let item = searchData[indexPath.row]
        cell.lbl_title.text = item.title
        cell.lblSubTitle.text = item.message
        if item.readStatus == true {
            cell.highLight_Vw.backgroundColor = UIColor(hex: "#00A925")
        }else{
            cell.highLight_Vw.backgroundColor = UIColor.red
        }
        return cell
    }


    // Row selection (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped row \(indexPath.row)")
        let item = searchData[indexPath.row]
         let id = item.id
        self.jobId = item.redirectId
        let status = item.readStatus ?? false
    //  self.MarkNotificationRead(id: id)
        self.navigateToDescriptionVC(status: status,notificationId: id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
       
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
                        self.getNotificationList()
                    }
                    
                }
            }
            
        }
    }
    func createTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tblVw.frame.width, height: 60))
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =  "Loading more notifications..." 
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
    func removeTableFooterView() {
        tblVw.tableFooterView = nil
    }
}
struct NotificationItem {
    let header: String
    let subheader: String
}

extension NotificationVC{
    
    private func getNotificationList(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            tblVw
            .reloadSections(IndexSet(integer: 0), with: .none)
        }
        viewModel.getBackpackerNotificationList(page: page, perPage: perPage,search: ""){ [weak self] (success: Bool, result: NotificationResponse?, statusCode: Int?) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                guard let statusCode = statusCode else {
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                    if self.searchData.count <= 0 {
                        self.lbl_nodatafound.isHidden = false
                    }else{
                        self.lbl_nodatafound.isHidden = true
                    }
                    return
                }
                let httpStatus = HTTPStatusCode(rawValue: statusCode)
                
                DispatchQueue.main.async {
                    
                    switch httpStatus {
                    case .ok, .created:
                        if success == true {
                            if success, let list = result?.data?.notificationList {
                                if self.page == 1 {
                                    if list.isEmpty {
                                        self.lbl_nodatafound.isHidden = false
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
                            self.lbl_nodatafound.isHidden = false
                        }else{
                            self.lbl_nodatafound.isHidden = true
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.searchData.count <= 0 {
                            self.lbl_nodatafound.isHidden = false
                        }else{
                            self.lbl_nodatafound.isHidden = true
                        }
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getNotificationList()
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
                        if self.searchData.count <= 0 {
                            self.lbl_nodatafound.isHidden = false
                        }else{
                            self.lbl_nodatafound.isHidden = true
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.searchData.count <= 0 {
                            self.lbl_nodatafound.isHidden = false
                        }else{
                            self.lbl_nodatafound.isHidden = true
                        }
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        if self.searchData.count <= 0 {
                            self.lbl_nodatafound.isHidden = false
                        }else{
                            self.lbl_nodatafound.isHidden = true
                        }
                    }
                }
            }
        }
        
    }
    
    private func MarkNotificationRead(id:String){
            LoaderManager.shared.show()
        viewModel.BackpackerNotificationRead(id: id){ [weak self] (success: Bool, result: NotificationResponse?, statusCode: Int?) in
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
                            //self.navigateToDescriptionVC()
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                         
                        }
                   
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                     
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.MarkNotificationRead(id: id)
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
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
    
    private func navigateToDescriptionVC(status : Bool = false,notificationId : String){
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
               jobDescriptionVC.JobId = self.jobId
               
               if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                   appDelegate.isComeFromNotification = true
               }
               jobDescriptionVC.isNotComeFromNotificationVw = status
               jobDescriptionVC.notificationId = notificationId
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
    }
}
