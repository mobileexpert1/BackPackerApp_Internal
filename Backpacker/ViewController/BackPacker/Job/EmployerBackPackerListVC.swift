//
//  EmployerBackPackerListVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class EmployerBackPackerListVC: UIViewController {
    
    @IBOutlet weak var lbl_NoDataFound: UILabel!
    @IBOutlet weak var btn_Close: UIButton!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var tbaleView: UITableView!
    var iscomeFromEmployer : Bool = false
    
    
    var fullData: [Backpacker] = []
    var  selectedData : [Backpacker] = []
    var searchData: [Backpacker] = []
    let viewModel = JobVM()
    private let refreshControl = UIRefreshControl()
    weak var delegate: CommonSearchDelegate?
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isComeFromPullTorefresh = false
        self.btn_Close.isHidden = true
        
    }
    func setUpUI(){
        self.lbl_NoDataFound.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_NoDataFound.isHidden = true
        tbaleView.delegate = self
        tbaleView.dataSource = self
        self.searchVw.layer.borderWidth = 1.0
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        tbaleView.register(UINib(nibName: "CommonEmpListTVC", bundle: nil), forCellReuseIdentifier: "CommonEmpListTVC")
        txtFldSearch.delegate = self
        
        self.updateSearchtext()
        self.setUpRefreshControl()
        self.backpackerListApiCall()
    }
    func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tbaleView.refreshControl = refreshControl
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
            self.backpackerListApiCall()
        }
        
    }
    
    @IBAction func action_ClearTxtFkd(_ sender: Any) {
        txtFldSearch.text = ""
        lastSearchedText = ""
        page = 1
        txtFldSearch.resignFirstResponder()
        self.btn_Close.isHidden = true
        backpackerListApiCall()
        
        
        
    }
    func updateSearchtext(){
        if iscomeFromEmployer {
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Employer",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
        } else {
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Backpacker",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
        }
    }
}
extension EmployerBackPackerListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count // or your dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonEmpListTVC", for: indexPath) as? CommonEmpListTVC else {
            return UITableViewCell()
        }
        print("iscomeForm",iscomeFromEmployer)
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
        if iscomeFromEmployer ==  false{
            cell.lbl_CompletedJobs.text = "Job Completed - \(backpacker.jobsCount)"
        }
        cell.cosmosVw.rating = Double(backpacker.rating)
        
        cell.setupConstraint(iscomeFormEmloyeeee: iscomeFromEmployer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
#if BackpackerHire
        
        let storyboard = UIStoryboard(name: "EmployerHome", bundle: nil)
        if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "BackPackerDetailVC") as? BackPackerDetailVC {
            //  jobDescriptionVC.isComeFrom = iscomeFromEmployer
            // Optional: pass selected job title
            self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
        }
#else
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "EmployerDetailVC") as? EmployerDetailVC {
            jobDescriptionVC.isComeFrom = iscomeFromEmployer
            // Optional: pass selected job title
            self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
        }
#endif
        
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
                    tbaleView.tableFooterView = createTableFooterView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ){
                        self.backpackerListApiCall()
                    }
                    
                }
            }
            
        }
    }
    func getInitials(from name: String) -> String {
        return name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .compactMap { $0.first?.uppercased() }
            .joined()
    }
    func firstDigit(of number: String) -> String {
        return number.first.map { String($0) } ?? ""
    }
    
}


extension EmployerBackPackerListVC :UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        // Prevent leading space
        if currentText.isEmpty && string == " " {
            return false
        }
        
        guard let stringRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let hasText = !updatedText.trimmingCharacters(in: .whitespaces).isEmpty
        self.btn_Close.isHidden = !hasText
        
        // Cancel existing timer
        searchDebounceTimer?.invalidate()
        
        // Start a new timer (debounce delay)
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let trimmedSearch = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if self.lastSearchedText != trimmedSearch {
                self.lastSearchedText = trimmedSearch
                self.page = 1
                removeTableFooterView()
                self.backpackerListApiCall()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.btn_Close.isHidden = true
        textField.resignFirstResponder()
        return true
    }
    
}


extension EmployerBackPackerListVC {
    func backpackerListApiCall() {
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            tbaleView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        viewModel.getBackpackersList(page: page, perPage: perPage,search: self.lastSearchedText,type: 1,isComeFromEmployer: iscomeFromEmployer) { [weak self] (success: Bool, result: BackpackerListResponse?, statusCode: Int?) in
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
                            if success, let list = result?.data?.backpackersList {
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
                                self.tbaleView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                           
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tbaleView.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                        if self.searchData.count <= 0 {
                            self.lbl_NoDataFound.isHidden = false
                        }else{
                            self.lbl_NoDataFound.isHidden = true
                        }
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
                                self.backpackerListApiCall()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.tbaleView.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.tbaleView.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.tbaleView.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later.")
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
    func createTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tbaleView.frame.width, height: 60))
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = iscomeFromEmployer ?  "Loading more employers..."   : "Loading more backpackers..."
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
        tbaleView.tableFooterView = nil
    }
}
