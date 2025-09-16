//
//  ChatVC.swift
//  Backpacker
//
//  Created by Mobile on 15/07/25.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var chatTxtFLdVw_Bottom: NSLayoutConstraint!
    @IBOutlet weak var lbl_NDataFound: UILabel!
    @IBOutlet weak var tblVw: UITableView!
   
    @IBOutlet weak var lbl_UserName: UILabel!
    var headerUserName : String?
   
    let viewModel = ChatViewModel()
    let viewModelReport = ReportIssueViewModel()
    let viewModelAuth = LogInVM()
    var isLoading : Bool = true
    private let topLoader = UIActivityIndicatorView(style: .medium)
    var ListChat = [Chat]()
    var AdminListChat = [AdminChatMessage]()
    var page = 1
    let perPage = 100
    var totalAccomodations = Int()
    @IBOutlet weak var sendButton: UIButton!
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    
    var isComeFromPullTorefresh : Bool = false
    
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var isComFromSearch : Bool = false
    var lastContentOffset: CGFloat = 0
    var resceiverID : String?
    var senderId : String?
    var chatList = [Chat]()
    @IBOutlet weak var txtFldChat: UITextField!
    var chatMessageList = [ChatMessage]()
    var sendMessage = String()
    var ticketId = String()
    var isComeFromAdmin : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
        if isComeFromAdmin == true{
            AdminlistOfChat()
        }else{
            self.listOfChat()
        }
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.isComeFromNotification = false
    }
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear // hide default spinner
        
        // Custom loader
        topLoader.color = .gray
        topLoader.hidesWhenStopped = true
        topLoader.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addSubview(topLoader)
        
        NSLayoutConstraint.activate([
            topLoader.centerXAnchor.constraint(equalTo: refreshControl.centerXAnchor),
            topLoader.centerYAnchor.constraint(equalTo: refreshControl.centerYAnchor),
            topLoader.heightAnchor.constraint(equalToConstant: 20),
            topLoader.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        refreshControl.addTarget(self, action: #selector(loadOlderMessages), for: .valueChanged)
        
        tblVw.refreshControl = refreshControl
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: duration) {
            self.chatTxtFLdVw_Bottom.constant = -(keyboardHeight)// little padding
            self.scrollToBottom(animated: true)
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.chatTxtFLdVw_Bottom.constant = 10
            self.view.layoutIfNeeded()
        }
    }
 


    @IBAction func action_sendChat(_ sender: Any) {
        guard let text = txtFldChat.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                    !text.isEmpty else {
                  print("⚠️ Cannot send empty message")
                  return
              }
              
        self.sendMessage = text
        if isComeFromAdmin == true{
            self.sendAdminChat()
        }else{
            self.sendChat()
        }
        
        
        // Clear text field
    
        
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setUpUI(){
        self.lbl_NDataFound.text = "No Chat Found"
        self.lbl_NDataFound.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_NDataFound.isHidden = true
        self.lbl_UserName.font = FontManager.inter(.medium, size: 12.0)
        let nib = UINib(nibName: "UserChatTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "UserChatTVC")
        
        let Enib = UINib(nibName: "EmplyerChatTVC", bundle: nil)
        self.tblVw.register(Enib, forCellReuseIdentifier: "EmplyerChatTVC")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        txtFldChat.attributedPlaceholder = NSAttributedString(
            string: "Write your message",
            attributes: [
                .foregroundColor: UIColor(hex:"#797C7B"),                     // Placeholder color
                .font: FontManager.inter(.regular, size: 14.0)             // Replace with your custom font if needed
            ]
        )
        self.lbl_UserName.text = self.headerUserName
        self.txtFldChat.delegate = self
                sendButton.isEnabled = false // disable until there's text
        // Flip table view for reverse order
       // tblVw.transform = CGAffineTransform(scaleX: 1, y: -1)
        tblVw.separatorStyle = .none
       // tblVw.transform = CGAffineTransform(scaleX: 1, y: -1)

        // Setup top loader
        self.setupRefreshControl()
    }
  
    func refreshData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if  appDelegate.isComeFromNotification == true{
            self.page = 1
            self.ListChat.removeAll()
            if isComeFromAdmin == true{
                self.AdminlistOfChat()
            }else{
                self.listOfChat()
            }
          
        }
    }


}
extension ChatVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get updated text
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Enable button only if not empty after trimming spaces
        sendButton.isEnabled = !currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return true
    }
    
    //  Dismiss keyboard when user presses return/done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Replace with your actual data source count
        if isComeFromAdmin == true{
            return  self.AdminListChat.count
            
        }else{
            return  self.ListChat.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isComeFromAdmin == true{
            guard indexPath.row < AdminListChat.count else { return UITableViewCell() }
            let chat = AdminListChat[indexPath.row]
            let currentUserId = chat.senderId
            self.senderId = currentUserId
            if currentUserId == chat.sender?.id {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatTVC", for: indexPath) as? UserChatTVC else {
                    return UITableViewCell()
                }
                cell.txtMsg.text = chat.message
                let formattedTime = formatChatTime(chat.timestamp ?? "")
                cell.lbl_Tim.text = formattedTime.isEmpty ? chat.timestamp : formattedTime
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmplyerChatTVC", for: indexPath) as? EmplyerChatTVC else {
                    return UITableViewCell()
                }
                cell.txtLbl.text = chat.message
                let formattedTime = formatChatTime(chat.timestamp ?? "")
                cell.lbl_Time.text = formattedTime.isEmpty ? chat.timestamp : formattedTime
                return cell
            }
            
        }else{
            guard indexPath.row < ListChat.count else { return UITableViewCell() }
            let chat = ListChat[indexPath.row]
            let currentUserId = self.senderId
            if chat.sender == currentUserId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatTVC", for: indexPath) as? UserChatTVC else {
                    return UITableViewCell()
                }
                cell.txtMsg.text = chat.message
                let formattedTime = formatChatTime(chat.timestamp)
                cell.lbl_Tim.text = formattedTime.isEmpty ? chat.timestamp : formattedTime
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmplyerChatTVC", for: indexPath) as? EmplyerChatTVC else {
                    return UITableViewCell()
                }
                cell.txtLbl.text = chat.message
                let formattedTime = formatChatTime(chat.timestamp)
                cell.lbl_Time.text = formattedTime.isEmpty ? chat.timestamp : formattedTime
                return cell
            }
        }
        
      
    }




    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func formatChatTime(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "hh:mm a"   // Example: "07:28 AM"
            return displayFormatter.string(from: date)
        }
        return ""
    }

    private func scrollToBottom(animated: Bool = true) {
         guard !ListChat.isEmpty else { return }
         let indexPath = IndexPath(row: ListChat.count - 1, section: 0)
         tblVw.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        
     }
    @objc private func loadOlderMessages() {
        guard !isLoadingMoreData, !isAllDataLoaded else {
            self.tblVw.refreshControl?.endRefreshing()
            self.topLoader.stopAnimating()
            return
        }
        self.tblVw.refreshControl?.beginRefreshing()
        self.topLoader.startAnimating()
        page += 1
        self.isComeFromPullTorefresh = true
        if isComeFromAdmin == true {
            AdminlistOfChat()
        }else{
            listOfChat()
        }
        
    }
}


extension ChatVC {
    
    
    private func listOfChat(){
            if page == 1 {
                self.isLoading = true
                LoaderManager.shared.show()
            } else {
                isLoadingMoreData = true
                self.tblVw.reloadSections(IndexSet(integer: 0), with: .none)
            }
        viewModel.getChatList(page: page, perPage: perPage,otherUserId: resceiverID){ [weak self] (success: Bool, result: ChatListResponse?, statusCode: Int?) in
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
                                guard success, let newChats = result?.data?.chats else {
                                     self.isAllDataLoaded = true
                                     self.isLoadingMoreData = false
                                     return
                                 }
                                 self.senderId = result?.data?.user.id
                                 // Prevent duplicates
                                 let existingIds = Set(self.ListChat.map { $0.id })
                                 let filteredChats = newChats.filter { !existingIds.contains($0.id) && !$0.id.isEmpty }

                                 if self.page == 1 {
                                     // First load → replace
                                     self.ListChat = filteredChats
                                     self.lbl_NDataFound.isHidden = !filteredChats.isEmpty
                                     self.tblVw.reloadData()
                                  //   self.scrollToBottom(animated: false)  // ✅ show latest at bottom
                                 } else {
                                     // Older messages prepend at top
                                     let previousContentHeight = self.tblVw.contentSize.height
                                     self.ListChat.insert(contentsOf: filteredChats, at: 0)
                                     self.tblVw.reloadData()
                                     self.tblVw.layoutIfNeeded()
                                     let newContentHeight = self.tblVw.contentSize.height
                                     self.tblVw.contentOffset.y += (newContentHeight - previousContentHeight)
                                 }

                                 self.isAllDataLoaded = filteredChats.count < self.perPage
                                 self.isLoadingMoreData = false
                                self.tblVw.refreshControl?.endRefreshing()
                                if self.isComeFromPullTorefresh == false {
                                    self.scrollToBottom()
                                }
                                self.isComeFromPullTorefresh = false
                                self.topLoader.stopAnimating()
                            case .badRequest:
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                self.isComeFromPullTorefresh = false
                            case .unauthorized :
                                self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                    if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                        self.listOfChat()
                                    } else {
                                        LoaderManager.shared.hide()
                                        self.tblVw.refreshControl?.endRefreshing()
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
                                self.tblVw.refreshControl?.endRefreshing()
                                self.lastContentOffset = 0.0
                                self.tblVw.setContentOffset(.zero, animated: true)
                                self.isComeFromPullTorefresh = false
                                
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                            case .unknown:
                                LoaderManager.shared.hide()
                                self.tblVw.refreshControl?.endRefreshing()
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
    
    
    private func sendChat(){
        LoaderManager.shared.show()
        let req = ChatRequest(receiver: resceiverID ?? "", message: self.sendMessage)
        viewModel.sendChat(request: req) { success, message ,statusCode in
            self.setUpLocalData()
            self.txtFldChat.text = ""
            self.sendMessage = ""
            self.sendButton.isEnabled = false
            guard let statusCode = statusCode else {
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                return
            }
            let httpStatus = HTTPStatusCode(rawValue: statusCode)
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                switch httpStatus {
                case .ok, .created:
                    print("Sent Sucessfluuy")
                    
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.sendChat()
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                }
            }
        }
    }
    
    private func AdminlistOfChat() {
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            self.tblVw.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        viewModelReport.getAdminChatt(page: page, perPage: perPage, ticketId: self.ticketId) { [weak self] (success: Bool, result: AdminChatResponse?, statusCode: Int?) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                
                guard let statusCode = statusCode else {
                    AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                    return
                }
                
                let httpStatus = HTTPStatusCode(rawValue: statusCode)
                
                switch httpStatus {
                case .ok, .created:
                    guard success, let newChats = result?.data?.chats  else {
                        self.isAllDataLoaded = true
                        self.isLoadingMoreData = false
                        return
                    }
                    
                    self.resceiverID = result?.data?.adminDetail?.id
                    
                    // Prevent duplicates
                    let existingIds = Set(self.AdminListChat.map { $0.id ?? "" })
                    let filteredChats = newChats.filter { !existingIds.contains($0.id ?? "") && !($0.id ?? "").isEmpty }
                    
                    if self.page == 1 {
                        self.AdminListChat = filteredChats
                        self.lbl_NDataFound.isHidden = !filteredChats.isEmpty
                        self.tblVw.reloadData()
                    } else {
                        let previousContentHeight = self.tblVw.contentSize.height
                        self.AdminListChat.insert(contentsOf: filteredChats, at: 0)
                        self.tblVw.reloadData()
                        self.tblVw.layoutIfNeeded()
                        let newContentHeight = self.tblVw.contentSize.height
                        self.tblVw.contentOffset.y += (newContentHeight - previousContentHeight)
                    }
                    
                    self.isAllDataLoaded = filteredChats.count < self.perPage
                    self.isLoadingMoreData = false
                    self.tblVw.refreshControl?.endRefreshing()
                    
                    if !self.isComeFromPullTorefresh {
                        self.scrollToBottom()
                    }
                    self.isComeFromPullTorefresh = false
                    self.topLoader.stopAnimating()
                    
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    self.isComeFromPullTorefresh = false
                    
                case .unauthorized:
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.AdminlistOfChat()
                        } else {
                            LoaderManager.shared.hide()
                            self.tblVw.refreshControl?.endRefreshing()
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
                    self.tblVw.refreshControl?.endRefreshing()
                    self.lastContentOffset = 0.0
                    self.tblVw.setContentOffset(.zero, animated: true)
                    self.isComeFromPullTorefresh = false
                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    
                case .unknown:
                    LoaderManager.shared.hide()
                    self.tblVw.refreshControl?.endRefreshing()
                    self.lastContentOffset = 0.0
                    self.tblVw.setContentOffset(.zero, animated: true)
                    self.isComeFromPullTorefresh = false
                    AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .methodNotAllowed, .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                }
            }
        }
    }

    private func sendAdminChat(){
        LoaderManager.shared.show()
        let req = AdminChatRequest(ticketId: self.ticketId, message: self.sendMessage, receiverId: self.resceiverID ?? "")
        viewModelReport.sendAdminChat(request: req) { success, message ,statusCode in
            self.setUpLocalData()
            self.txtFldChat.text = ""
            self.sendMessage = ""
            self.sendButton.isEnabled = false
            guard let statusCode = statusCode else {
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                return
            }
            let httpStatus = HTTPStatusCode(rawValue: statusCode)
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                switch httpStatus {
                case .ok, .created:
                    print("Sent Sucessfluuy")
                    
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.sendAdminChat()
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                }
            }
        }
    }
    func convertISOTo12Hour(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // Try parsing with fractional seconds first
        var date = isoFormatter.date(from: isoString)
        
        // Fallback if parsing fails (no fractional seconds)
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: isoString)
        }

        guard let validDate = date else {
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // 12-hour format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: validDate)
    }


    
    func setUpLocalData(){
        let currentTimeISO = ISO8601DateFormatter().string(from: Date())
        let formattedTime = convertISOTo12Hour(currentTimeISO)
        
        if isComeFromAdmin == true {
            let adminChat = AdminChatMessageChatUser(id: self.senderId, name: "", email: "", image: "")
            let neChat = AdminChatMessage(id: "", ticketId: "", senderId: self.senderId, senderModel: "", receiverId: "", receiverModel: "", message: self.sendMessage, messageType: "", status: "", timestamp: formattedTime, sender: adminChat, receiver: nil, createdAt: formattedTime, updatedAt: formattedTime)
            self.AdminListChat.append(neChat)
        }else{
            let newChat = Chat(
                    id: UUID().uuidString,   // temporary local ID
                    sender: self.senderId ?? "",
                    receiver: self.resceiverID ?? "",
                    message: self.sendMessage,
                    messageType: "text",
                    status: "sending",
                    timestamp: formattedTime,
                    createdAt: formattedTime,
                    updatedAt: formattedTime,
                    v: 0
                )

            self.ListChat.append(newChat)
        }
       
        self.tblVw.reloadData()
        self.lbl_NDataFound.isHidden = true
        scrollToBottom(animated: true)
    }

}


struct ChatMessage {
    let sender: SenderType
    let message: String
    let time: String
}
enum SenderType {
    case user
    case employer
}
