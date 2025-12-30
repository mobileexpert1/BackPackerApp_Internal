//
//  CompanyListVC.swift
//  Backpacker
//
//  Created by Mobile on 31/10/25.
//

import UIKit

class CompanyListVC: UIViewController {

    @IBOutlet weak var _noCompany: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    private var companies: [CompanyList] = []
    var page = 1
    let perPage = 10
    var totalAccomodations = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    let viewModel = ProfileVM()
    let viewModelAuth = LogInVM()
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var isComFromSearch : Bool = false
    var lastContentOffset: CGFloat = 0
    var selectedComapnyId : String?
    var objComapny : CompanyList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuPUI()
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.setupPullToRefresh()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCompaniesList()
    }
    private func setuPUI(){
        self._noCompany.isHidden = true
        self._noCompany.text = "Please add company first."
        self._noCompany.font = FontManager.inter(.medium, size: 12.0)
        let nib = UINib(nibName: "CommonCompanyTVC", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "CommonCompanyTVC")
    }

    @IBAction func action_add_company(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailVC") as? CompanyDetailVC {
            settingVC.isComeFromUpdate = false
               self.navigationController?.pushViewController(settingVC, animated: true)
           } else {
               print("- Could not instantiate SettingVC")
           }
        
    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshCollectionData), for: .valueChanged)
        self.tblVw.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionData() {
        // Reset pagination and loading flags

        self.page = 1
        self.isAllDataLoaded = false
        self.isLoadingMoreData = false
        self.isLoading = true
        
        // Start refreshing UI
       
        isComeFromPullTorefresh = true
        // Fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.getCompaniesList()
        }

        
    }
}
extension CompanyListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCompanyTVC", for: indexPath) as! CommonCompanyTVC
        let companyName = companies[indexPath.row]
        cell.lbl_company.text = companyName.name
        cell.lbl_location.text = companyName.industryType.name
        let baseURL1 = ApiConstants.API.API_IMAGEURL
        let baseURL2 = ApiConstants.API.API_IMAGEURL

        let imageURLString = companyName.logo.hasPrefix("http") ? companyName.logo : baseURL1 + companyName.logo
        cell.imgVw.sd_setImage(
            with: URL(string: imageURLString),
            placeholderImage: UIImage(named: "img_Placehodler")
        ) { image, _, _, _ in
            if image == nil { // First attempt failed
                let fallbackURL = companyName.logo.hasPrefix("http") ? companyName.logo : baseURL2 + companyName.logo
                cell.imgVw.sd_setImage(
                    with: URL(string: fallbackURL),
                    placeholderImage: UIImage(named: "img_Placehodler")
                )
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCompany = companies[indexPath.row]
        print("Selected Company: \(selectedCompany)")
        self.selectedComapnyId = selectedCompany.id
        self.objComapny = selectedCompany
        // Navigate to detail VC if needed
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "CompanyDetailVC") as? CompanyDetailVC {
            detailVC.isComeFromUpdate = true
            detailVC.selectedCompanyId = self.selectedComapnyId
            detailVC.objComapny = self.objComapny
            // Pass data
            // detailVC.company = selectedCompany
            navigationController?.pushViewController(detailVC, animated: true)
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
                        self.getCompaniesList()
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
        label.text = "Loading..."
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


extension CompanyListVC {
    
    private func getCompaniesList(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            self.tblVw.reloadSections(IndexSet(integer: 0), with: .none)
        }
            viewModel.GETComapnyList(page: page, perPage: perPage,search: self.lastSearchedText){ [weak self] (success: Bool, result: CompanyListResponse?, statusCode: Int?) in
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
                                let newAccommodations = result?.data.company ?? []
                                
                                if self.page == 1 {
                                    if newAccommodations.isEmpty {
                                        if self.isComFromSearch == false{
                                            AlertManager.showAlert(
                                                on: self,
                                                title: "No Results",
                                                message: "Please add company first."
                                            )
                                        }
                                        self._noCompany.isHidden = false
                                        self.companies.removeAll()
                                       self.companies = newAccommodations
                                        self.tblVw.isHidden = true
                                    } else {
                                        self.isLoading = false
                                        self.tblVw.isHidden = false
                                        self._noCompany.isHidden = true
                                       self.companies = newAccommodations
                                    }
                                } else {
                                    self.isLoading = false
                                    self.companies.append(contentsOf: newAccommodations)
                                }
                                self.totalAccomodations = result?.data.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = newAccommodations.count < self.perPage
                                
                              
                                self.isComeFromPullTorefresh = false
                                self.isLoadingMoreData = false
                                self.tblVw.reloadData()
                                self.refreshControl.endRefreshing()
                                self.removeTableFooterView()
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                self.refreshControl.endRefreshing()
                                self.tblVw.setContentOffset(.zero, animated: true)
                                self.isLoading = false
                                self.isLoadingMoreData = false
                                self.isComeFromPullTorefresh = false
                                LoaderManager.shared.hide()
                                self.removeTableFooterView()
                            }
                            
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.getCompaniesList()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.refreshControl.endRefreshing()
                                    self.isLoading = false
                                    self.isComeFromPullTorefresh = false
                                    self.tblVw.setContentOffset(.zero, animated: true)
                                    self.removeTableFooterView()
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.tblVw.setContentOffset(.zero, animated: true)
                            self.removeTableFooterView()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.tblVw.setContentOffset(.zero, animated: true)
                            self.removeTableFooterView()
                            AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            self.removeTableFooterView()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            self.removeTableFooterView()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
        
    }
    
}
