//
//  CommonSearchVC.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import UIKit
protocol CommonSearchDelegate: AnyObject {
    func didSelectBackpacker(_ backpacker: [Backpacker])
}

class CommonSearchVC: UIViewController {

    @IBOutlet weak var btn_cross: UIButton!
    @IBOutlet weak var Btn_Save: UIButton!
    @IBOutlet weak var txtFld_Search: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var lbl_No_backpacker: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    var searchData: [Backpacker] = []
    var fullData: [Backpacker] = []
    var  selectedData : [Backpacker] = []
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
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setUpUI()
       
        self.setUpRefreshControl()
        self.backpackerListApiCall()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isComeFromPullTorefresh = false
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
            self.backpackerListApiCall()
        }
       
    }

    func setUpUI(){
        self.btn_cross.isHidden = true
        applyGradientButtonStyle(to: self.Btn_Save)
        self.Btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_No_backpacker.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_No_backpacker.isHidden = true
        let nib = UINib(nibName: "FacilityTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "FacilityTVC")
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16)
        self.searchVw.layer.cornerRadius = 22.5
        self.searchVw.layer.borderWidth = 1.0
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        self.txtFld_Search.delegate = self
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
               
    }

   

    @IBAction func action_txtFldClear(_ sender: Any) {
        txtFld_Search.text = ""
            lastSearchedText = ""
            page = 1
        txtFld_Search.resignFirstResponder()
        self.btn_cross.isHidden = true
        backpackerListApiCall()
        
    }
    @IBAction func action_Save(_ sender: Any) {
           delegate?.didSelectBackpacker(self.selectedData)
           self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CommonSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityTVC", for: indexPath) as? FacilityTVC else {
            return UITableViewCell()
        }

        let data = searchData[indexPath.row]
        
        cell.lblTitle.text = data.name.isEmpty ? data.mobileNumber : data.name
        cell.lblTitle.textColor = .black
           // ✅ Check if the item is selected
        
           let isSelected = selectedData.contains { $0.mobileNumber == data.mobileNumber }
           cell.imgCheckBox.image = isSelected ? UIImage(named: "Checkbox2") : UIImage(named: "Checkbox")

           return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchData[indexPath.row]

            if let index = selectedData.firstIndex(where: { $0.mobileNumber == selectedItem.mobileNumber }) {
                // Already selected → remove
                selectedData.remove(at: index)
            } else {
                // Not selected → add
                selectedData.append(selectedItem)
            }

            // Reload just the tapped row
            tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 300 {
            if isComeFromPullTorefresh == false{
                if !isLoading && !isLoadingMoreData && !isAllDataLoaded {
                    isLoadingMoreData = true
                    page += 1
                    tblVw.tableFooterView = createTableFooterView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ){
                        self.backpackerListApiCall()
                    }
                   
                }
            }
          
        }
    }
}
extension CommonSearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
          
          // Prevent leading space
          if currentText.isEmpty && string == " " {
              return false
          }
          
          guard let stringRange = Range(range, in: currentText) else { return true }
          let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
          
          let hasText = !updatedText.trimmingCharacters(in: .whitespaces).isEmpty
         self.btn_cross.isHidden = !hasText

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
       self.btn_cross.isHidden = true
        textField.resignFirstResponder()
        return true
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

    func removeTableFooterView() {
        tblVw.tableFooterView = nil
    }
}
//MAAR:  - API Call
extension CommonSearchVC {
    
    func backpackerListApiCall() {
        if page == 1 {
               self.isLoading = true
               LoaderManager.shared.show()
           } else {
               isLoadingMoreData = true
               tblVw.reloadSections(IndexSet(integer: 0), with: .none)
           }
        viewModel.getBackpackersList(page: page, perPage: perPage,search: self.lastSearchedText,type: 1) { [weak self] (success: Bool, result: BackpackerListResponse?, statusCode: Int?) in
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
                                        self.lbl_No_backpacker.isHidden = false
                                        self.searchData.removeAll()
                                        self.searchData = list
                                        self.tblVw.isHidden = true
                                    } else {
                                        self.tblVw.isHidden = false
                                       self.lbl_No_backpacker.isHidden = true
                                        self.searchData = list
                                        self.isLoading = false
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
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.backpackerListApiCall()
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
