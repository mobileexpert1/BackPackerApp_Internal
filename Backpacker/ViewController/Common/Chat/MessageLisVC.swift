//  MessageLisVC.swift
//  Backpacker
//  Created by Mobile on 15/07/25.

import UIKit

class MessageLisVC: UIViewController {
    
    @IBOutlet weak var btn_Close: UIButton!
    @IBOutlet weak var lbl_NDataFound: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btn_Admin: UIButton!
    @IBOutlet weak var btn_Employer: UIButton!
    @IBOutlet weak var Vw_Admin: UIView!
    @IBOutlet weak var Vw_Employer: UIView!
    @IBOutlet weak var lbl_Admin: UILabel!
    @IBOutlet weak var lbl_Employer: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    var isComeFromNotification : Bool = false
    var isComefFromAdmin : Bool = false
    // MARK: - Sample Array
    var userList: [MessageUser] = [
        MessageUser(userId: UUID().uuidString, name: "John Doe", subHeader: "Hey, got your message!", seenTime: "29 Mar"),
        MessageUser(userId: UUID().uuidString, name: "Jane Smith", subHeader: "Let's catch up tomorrow.", seenTime: "25 Mar"),
        MessageUser(userId: UUID().uuidString, name: "Admin Team", subHeader: "Your request was approved.", seenTime: "29 Feb"),
        MessageUser(userId: UUID().uuidString, name: "Michael Scott", subHeader: "Meeting rescheduled to 3 PM", seenTime: "25 Feb"),
        MessageUser(userId: UUID().uuidString, name: "Pam Beesly", subHeader: "Artwork is ready!", seenTime: "20 Jan")
    ]
    let viewModel = ChatViewModel()
    let viewModelAuth = LogInVM()
    let viewModelReport = ReportIssueViewModel()
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    var employerList = [EmployerChat]()
    var page = 1
    let perPage = 20
    var totalAccomodations = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var isComFromSearch : Bool = false
    var lastContentOffset: CGFloat = 0
    var senderId : String?
    var receiverId : String?
    var ticketId : String?
    var ticketList =  [Ticket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUpUI() {
        self.lbl_NDataFound.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_NDataFound.isHidden = true
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.txtFldSearch.font = FontManager.inter(.regular, size: 14.0)
        self.txtFldSearch.delegate = self
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        self.searchVw.layer.borderWidth = 1.0
#if Backapacker
        self.lbl_Employer.text = "Employer"
#else
        self.lbl_Employer.text = "Backpacker"
#endif
        self.lbl_Admin.text = "Admin"
        let nib = UINib(nibName: "EmployerTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "EmployerTVC")
        self.btn_Employer.tag = 1
        self.btn_Admin.tag = 0
        self.lbl_Admin.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Employer.font = FontManager.inter(.medium, size: 14.0)
        txtFldSearch.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor(hex:"#000000"),                     // Placeholder color
                .font: FontManager.inter(.regular, size: 14.0)             // Replace with your custom font if needed
            ]
        )
        
        self.btn_Close.isHidden = true
        self.UpdateBtnAppearance()
        self.setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if btn_Employer.tag == 1 {
#if BackpackerHire
            self.listOfAllBackpacker()
#else
            
            self.listOfAllEmployer()
#endif
            self.refreshData()
        } else {
            if btn_Admin.tag == 1 {
                self.getListOfTickets()
                self.refreshData()
            }
        }
    }
    
    func refreshViaApiCall() {
        if isComefFromAdmin == true {
            self.btn_Admin.tag = 1
            self.btn_Employer.tag =  0
            
            self.UpdateBtnAppearance()
            self.getListOfTickets()
        } else {
            if btn_Employer.tag == 1 {
#if BackpackerHire
                self.listOfAllBackpacker()
#else
                
                self.listOfAllEmployer()
#endif
            } else {
                self.getListOfTickets()
            }
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
        self.refreshControl.beginRefreshing()
        self.removeTableFooterView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.page = 1
            self.isAllDataLoaded = false
            self.isLoadingMoreData = false
            self.isLoading = true
            
            // Start refreshing UI
            self.isComeFromPullTorefresh = true
            // Fetch data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.btn_Employer.tag == 1 {
#if BackpackerHire
                    self.listOfAllBackpacker()
#else
                    
                    self.listOfAllEmployer()
#endif
                    
                } else {
                    if self.btn_Admin.tag == 1 {
#if BackpackerHire
                        self.getListOfTickets()
#else
                        self.getListOfTickets()
#endif
                    }
                }
            }
        }
    }
    
    @IBAction func action_btn_Close(_ sender: Any) {
        self.txtFldSearch.text = ""
        self.btn_Close.isHidden = true
        self.lastSearchedText = ""
        self.txtFldSearch.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.btn_Employer.tag == 1 {
#if BackpackerHire
                self.listOfAllBackpacker()
#else
                
                self.listOfAllEmployer()
#endif
                
            } else {
                if self.btn_Admin.tag == 1 {
#if BackpackerHire
                    self.getListOfTickets()
#else
                    self.getListOfTickets()
#endif
                }
            }
        }
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func UpdateBtnAppearance() {
        if btn_Employer.tag == 1{
            self.lbl_MainHeader.text = "Messages"
            self.Vw_Employer.backgroundColor = UIColor(named: "themeColor")
            self.Vw_Employer.layer.cornerRadius = 10.0
            self.lbl_Employer.textColor = .white
            self.Vw_Admin.backgroundColor = .clear
            self.lbl_Admin.textColor = .black
        } else {
            self.lbl_MainHeader.text = "Chat"
            self.Vw_Admin.backgroundColor = UIColor(named: "themeColor")
            self.Vw_Admin.layer.cornerRadius = 10.0
            self.lbl_Admin.textColor = .white
            self.Vw_Employer.backgroundColor = .clear
            self.lbl_Employer.textColor = .black
        }
    }
    
    @IBAction func action_AdminToggle(_ sender: Any) {
        self.btn_Admin.tag = 1
        self.btn_Employer.tag =  0
        self.UpdateBtnAppearance()
        self.page = 1
        self.isAllDataLoaded = false
        self.isLoadingMoreData = false
        self.isLoading = false
        if self.btn_Admin.tag == 1 {
#if BackpackerHire
            self.getListOfTickets()
#else
            self.getListOfTickets()
#endif
        }
    }
    
    @IBAction func action_EmplyerToggle(_ sender: Any) {
        self.btn_Admin.tag = 0
        self.btn_Employer.tag =  1
        self.UpdateBtnAppearance()
        self.page = 1
        self.isAllDataLoaded = false
        self.isLoadingMoreData = false
        self.isLoading = false
        if self.btn_Employer.tag == 1 {
#if BackpackerHire
            self.listOfAllBackpacker()
#else
            self.listOfAllEmployer()
#endif
        }
    }
}

extension MessageLisVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //#if Backapacker
        if btn_Employer.tag == 1 {
            return employerList.count
        } else {
            return ticketList.count
        }
        //        #else
        
        // return userList.count
        
        //#endif
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployerTVC", for: indexPath) as? EmployerTVC else {
            return UITableViewCell()
        }
        if btn_Employer.tag == 1 {
            let user = employerList[indexPath.row]
            
            // Header & short name
            if user.name.isEmpty {
                cell.lblHeader.text = user.mobileNumber
                cell.lbl_ShortName.text = "" // clear if name is empty
            } else {
                cell.lblHeader.text = user.name
                cell.lbl_ShortName.text = getFirstLetter(of: user.name)
            }
            
            // Last message
            if let lastMessage = user.lastMessageInfo?.lastMessage, !lastMessage.isEmpty {
                cell.lbl_Subheader.text = lastMessage
                cell.setUpConstraint(isLastMsgExist: true)
            } else {
                cell.lbl_Subheader.text = ""
                cell.setUpConstraint(isLastMsgExist: false)
            }
            
            // Last message time
            if let dateString = user.lastMessageInfo?.lastMessageDate,
               !dateString.isEmpty,
               let timeOnly = extractTime(from: dateString) {
                cell.lbl_SeenTime.text = timeOnly
            } else {
                cell.lbl_SeenTime.text = "" // clear if no timestamp
            }
            
        } else {
            let user = ticketList[indexPath.row]
            
            // Header & short name
            cell.lblHeader.text =  user.title
            cell.lbl_ShortName.text = getFirstLetter(of: user.title ?? "Admin")
            
            // Last message
            if let lastMessage = user.lastMessage?.message, !lastMessage.isEmpty {
                cell.lbl_Subheader.text = lastMessage
                cell.setUpConstraint(isLastMsgExist: true)
            } else {
                cell.lbl_Subheader.text = ""
                cell.setUpConstraint(isLastMsgExist: false)
            }
            
            // Last message time
            if let dateString = user.lastMessage?.timestamp,
               !dateString.isEmpty,
               let timeOnly = extractTime(from: dateString) {
                cell.lbl_SeenTime.text = timeOnly
            } else {
                cell.lbl_SeenTime.text = "" // clear if no timestamp
            }
        }
        return cell
    }
    
    func extractTime(from isoString: String, is24Hour: Bool = false, useLocalTime: Bool = true) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = is24Hour ? "HH:mm" : "hh:mm a"
        timeFormatter.timeZone = useLocalTime ? TimeZone.current : TimeZone(abbreviation: "UTC")
        
        return timeFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if btn_Employer.tag == 1 {
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                settingVC.isComeFromAdmin = false
                settingVC.headerUserName = employerList[indexPath.row].name
                settingVC.resceiverID  = employerList[indexPath.row].id
                self.navigationController?.pushViewController(settingVC, animated: true)
            } else {
                print("- Could not instantiate SettingVC")
            }
            
            
        } else {
            // AlertManager.showAlert(on: self, title: "Admin Chat", message: "In Progress")
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                settingVC.isComeFromAdmin = true
                settingVC.headerUserName = ticketList[indexPath.row].title
                settingVC.ticketId  = ticketList[indexPath.row].id ?? ""
                self.navigationController?.pushViewController(settingVC, animated: true)
            } else {
                print("- Could not instantiate SettingVC")
            }
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
                        if self.btn_Employer.tag == 1 {
#if BackpackerHire
                            self.listOfAllBackpacker()
#else
                            
                            self.listOfAllEmployer()
#endif
                            
                        }else{
#if BackpackerHire
                            
#else
                            
                            self.getListOfTickets()
#endif
                            
                        }
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
#if BackpackerHire
        label.text = "Loading more backpackers..."
#else
        
        label.text = "Loading more employers..."
#endif
        
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
    
    func getFirstLetter(of name: String) -> String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.first.map { String($0).uppercased() } ?? ""
    }
    
    func refreshData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDelegate.isComeFromNotification == true{
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                settingVC.headerUserName = "Test"
                if isComefFromAdmin == true{
                    self.btn_Admin.tag = 0
                    self.btn_Employer.tag =  1
                    self.UpdateBtnAppearance()
                    settingVC.isComeFromAdmin = true
                    settingVC.ticketId = ticketId ?? ""
                }else{
                    settingVC.isComeFromAdmin = false
                    self.btn_Admin.tag = 1
                    self.btn_Employer.tag =  0
                    self.UpdateBtnAppearance()
                }
                settingVC.resceiverID  = senderId
                self.navigationController?.pushViewController(settingVC, animated: true)
            } else {
                print("- Could not instantiate SettingVC")
            }
        }
    }
}

extension MessageLisVC :UITextFieldDelegate {
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
                if btn_Employer.tag == 1{
#if BackpackerHire
                    self.listOfAllBackpacker()
                    
#else
                    
                    self.listOfAllEmployer()
#endif
                }else{
#if BackpackerHire
                    self.getListOfTickets()
#else
                    
                    self.getListOfTickets()
#endif
                }
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

extension MessageLisVC {
#if Backapacker
    func listOfAllEmployer(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            // self.tblVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
        }
        viewModel.getEmployerChatList(page: page, perPage: perPage,search: self.lastSearchedText){ [weak self] (success: Bool, result: EmployerChatListResponse?, statusCode: Int?) in
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
                            let newAccommodations = result?.data?.employers ?? []
                            
                            if self.page == 1 {
                                if newAccommodations.isEmpty {
                                    self.lbl_NDataFound.isHidden = false
                                    self.employerList.removeAll()
                                    self.employerList = newAccommodations
                                } else {
                                    self.employerList.removeAll()
                                    self.lbl_NDataFound.isHidden = true
                                    self.isLoading = false
                                    self.employerList = newAccommodations
                                }
                            } else {
                                self.isLoading = false
                                self.employerList.append(contentsOf: newAccommodations)
                            }
                            self.totalAccomodations = result?.data?.total ?? 0
                            // Pagination end check
                            self.isAllDataLoaded = newAccommodations.count < self.perPage
                            
                            
                            self.isLoadingMoreData = false
                            self.tblVw.reloadData()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            self.isLoadingMoreData = false
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                            LoaderManager.shared.hide()
                        }
                        self.removeTableFooterView()
                        
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.listOfAllEmployer()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isLoading = false
                                self.lastContentOffset = 0.0
                                self.tblVw.setContentOffset(.zero, animated: true)
                                self.isComeFromPullTorefresh = false
                                self.lastContentOffset = 0.0
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                            }
                        }
                        
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.lastContentOffset = 0.0
                        self.tblVw.setContentOffset(.zero, animated: true)
                        self.isComeFromPullTorefresh = false
                        
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.lastContentOffset = 0.0
                        self.tblVw.setContentOffset(.zero, animated: true)
                        self.isComeFromPullTorefresh = false
                        
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        
                    }
                }
            }
        }
    }
    
#else
    func listOfAllBackpacker() {
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            // self.tblVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
        }
        viewModel.getBackpackerChatList(page: page, perPage: perPage,search: self.lastSearchedText){ [weak self] (success: Bool, result: BackpackerChatListResponse?, statusCode: Int?) in
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
                            let newAccommodations = result?.data?.backpacker ?? []
                            
                            if self.page == 1 {
                                if newAccommodations.isEmpty {
                                    self.lbl_NDataFound.isHidden = false
                                    self.employerList.removeAll()
                                    self.employerList = newAccommodations
                                } else {
                                    self.employerList.removeAll()
                                    self.lbl_NDataFound.isHidden = true
                                    self.isLoading = false
                                    self.employerList = newAccommodations
                                }
                            } else {
                                self.isLoading = false
                                self.employerList.append(contentsOf: newAccommodations)
                            }
                            self.totalAccomodations = result?.data?.total ?? 0
                            // Pagination end check
                            self.isAllDataLoaded = newAccommodations.count < self.perPage
                            
                            
                            self.isLoadingMoreData = false
                            self.tblVw.reloadData()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            self.isLoadingMoreData = false
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                            LoaderManager.shared.hide()
                        }
                        self.removeTableFooterView()
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                
                                if self.btn_Employer.tag == 1 {
#if BackpackerHire
#else
                                    self.listOfAllEmployer()
#endif
                                }
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isLoading = false
                                self.lastContentOffset = 0.0
                                self.tblVw.setContentOffset(.zero, animated: true)
                                self.isComeFromPullTorefresh = false
                                self.lastContentOffset = 0.0
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                            }
                        }
                        
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.lastContentOffset = 0.0
                        self.tblVw.setContentOffset(.zero, animated: true)
                        self.isComeFromPullTorefresh = false
                        
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.lastContentOffset = 0.0
                        self.tblVw.setContentOffset(.zero, animated: true)
                        self.isComeFromPullTorefresh = false
                        
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                    }
                }
            }
        }
    }
#endif
    
    func getListOfTickets() {
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            // self.tblVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
        }
        viewModelReport.getTicketList(page: page, perPage: perPage){ [weak self] (success: Bool, result: TicketsResponse?, statusCode: Int?) in
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
                            //  ticketList
                            let newAccommodations = result?.data?.tickets ?? []
                            
                            if self.page == 1 {
                                if newAccommodations.isEmpty {
                                    self.lbl_NDataFound.isHidden = false
                                    self.ticketList.removeAll()
                                    self.ticketList = newAccommodations
                                } else {
                                    self.ticketList.removeAll()
                                    self.lbl_NDataFound.isHidden = true
                                    self.isLoading = false
                                    self.ticketList = newAccommodations
                                }
                            } else {
                                self.isLoading = false
                                self.ticketList.append(contentsOf: newAccommodations)
                            }
                            self.totalAccomodations = result?.data?.total ?? 0
                            // Pagination end check
                            self.isAllDataLoaded = newAccommodations.count < self.perPage
                            
                            
                            self.isLoadingMoreData = false
                            self.tblVw.reloadData()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.tblVw.setContentOffset(.zero, animated: true)
                            self.isLoadingMoreData = false
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                            LoaderManager.shared.hide()
                        }
                        self.removeTableFooterView()
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfTickets()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isLoading = false
                                self.lastContentOffset = 0.0
                                self.tblVw.setContentOffset(.zero, animated: true)
                                self.isComeFromPullTorefresh = false
                                self.lastContentOffset = 0.0
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                            }
                        }
                        
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.lastContentOffset = 0.0
                        self.tblVw.setContentOffset(.zero, animated: true)
                        self.isComeFromPullTorefresh = false
                        
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.lastContentOffset = 0.0
                        self.tblVw.setContentOffset(.zero, animated: true)
                        self.isComeFromPullTorefresh = false
                        
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        
                    }
                }
            }
        }
    }
}

struct MessageUser {
    let userId: String
    let name: String
    let subHeader: String
    let seenTime: String
}
