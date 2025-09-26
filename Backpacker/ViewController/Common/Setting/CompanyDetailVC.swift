//
//  CompanyDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 04/08/25.
//

import UIKit

class CompanyDetailVC: UIViewController {
    @IBOutlet weak var scroll_Height: NSLayoutConstraint!
    
    @IBOutlet weak var tapImageBtn: UIButton!
    @IBOutlet weak var btn_Cancle: UIButton!
    @IBOutlet weak var btn_Save: UIButton!
    @IBOutlet weak var btn_btnHeight: NSLayoutConstraint!
    @IBOutlet weak var jobs_Tble_Height: NSLayoutConstraint!
    @IBOutlet weak var jobs_TblVw: UITableView!
    @IBOutlet weak var lbl_CompanyLOgi: UILabel!
    @IBOutlet weak var lbl_Val_SelctedIndustry: UILabel!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var vw_Table_Height: NSLayoutConstraint!
    @IBOutlet weak var tbl_Height: NSLayoutConstraint!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vw_SelectIndustry: UIView!
    @IBOutlet weak var lbl_Industry: UILabel!
    @IBOutlet weak var bussinesName_Vw: CommonTxtFldLblVw!
    
    @IBOutlet weak var lbl_Placeholder: UILabel!
    @IBOutlet weak var placeholde_Img: UIImageView!
    @IBOutlet weak var selected_Image: UIImageView!
    
    @IBOutlet weak var MainVw_Industries: UIView!
    @IBOutlet weak var btn_Industry: UIButton!
    @IBOutlet weak var placeholder_Vw: UIView!
    var isComeFromUpdate : Bool = false
    let industries = [
        "Information Technology",
        "Software Development",
        "Cybersecurity",
        "Cloud Computing",
        "Artificial Intelligence",
        "Web Development",]
    var jobsTotalCount : Int = 5
    var mediaPicker: MediaPickerManager?
    let profileVm = ProfileVM()
    let viewModelAuth = LogInVM()
    var companyObj : CompanyDetail?
    var listOfIndeustries : [Industry]?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCompanyInfo()
        self.getIndustriesList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        jobs_Tble_Height.constant = CGFloat(jobsTotalCount) * (130 + 10)
    }
    func setUpUI(){
        self.MainVw_Industries.layer.cornerRadius = 10.0
        self.MainVw_Industries.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.MainVw_Industries.layer.borderWidth = 1.0
        self.btn_Industry.tag  = 0
        self.bussinesName_Vw.setTitleLabel("Business Name")
        self.bussinesName_Vw.setPlaceholder("Name")
        self.bussinesName_Vw.setError("")
        self.lbl_Industry.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Val_SelctedIndustry.font = FontManager.inter(.regular, size: 14.0)
        lbl_CompanyLOgi.font = FontManager.inter(.medium, size: 14.0)
        self.setUpLblIndustryColor()
        self.manageHeight()
        self.vw_SelectIndustry.layer.cornerRadius = 10.0
        self.vw_SelectIndustry.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.vw_SelectIndustry.layer.borderWidth = 1.0
        self.lbl_Placeholder.font = FontManager.inter(.medium, size: 10.0)
        self.btn_remove.isHidden = true
        handleRemoveBtnVisibility()
        self.tblVw.register(UINib(nibName: "ReportIssueTVC", bundle: nil), forCellReuseIdentifier: "ReportIssueTVC")
        self.jobs_TblVw.register(UINib(nibName: "CompanyDetailTVC", bundle: nil), forCellReuseIdentifier: "CompanyDetailTVC")
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        applyGradientButtonStyle(to: btn_Save)
        self.jobs_TblVw.delegate = self
        self.jobs_TblVw.dataSource = self
        self.jobs_TblVw.showsVerticalScrollIndicator = false
        self.jobs_TblVw.showsHorizontalScrollIndicator = false
        jobs_TblVw.isScrollEnabled = false
        self.reloadTableData()
        

    }
    
    func setUpLblIndustryColor(){
        if lbl_Val_SelctedIndustry.text == "Select Industry"{
            
            self.lbl_Val_SelctedIndustry.textColor = UIColor(hex: "#9D9D9D")
        }else{
            self.lbl_Val_SelctedIndustry.textColor = UIColor.black
        }
    }
    @IBAction func action_remove(_ sender: Any) {
        self.selected_Image.image = nil
        self.selected_Image.image = UIImage(named: "BgUploadImage")
        self.setUpImagePlacehoder()
        
    }
    @IBAction func action_uploadImage(_ sender: Any) {
        
        mediaPicker = MediaPickerManager(presentingVC: self)
        mediaPicker?.showMediaOptions(isFromNewAccommodation: false) { image in
            print("Selected image: \(image)")
            self.selected_Image.image = image
            self.placeholde_Img.isHidden = true
            self.lbl_Placeholder.isHidden = true
            self.setUpImagePlacehoder()
        }
    }
    func setUpImagePlacehoder(){
        if self.selected_Image.image == UIImage(named: "BgUploadImage"){
            self.selected_Image.layer.cornerRadius = 0.0
            self.btn_remove.isHidden = true
            self.btn_remove.isUserInteractionEnabled = false
            self.placeholde_Img.isHidden = false
            self.lbl_Placeholder.isHidden = false
        }else{
            self.selected_Image.layer.cornerRadius = 10.0
            self.btn_remove.isHidden = false
            self.btn_remove.isUserInteractionEnabled = true
            self.placeholde_Img.isHidden = true
            self.lbl_Placeholder.isHidden = true
        }
    }
    func reloadTableData() {
        jobs_TblVw.reloadData()
        jobs_TblVw.layoutIfNeeded()
        jobs_Tble_Height.constant = CGFloat(jobsTotalCount) * (130 + 10)
        self.scroll_Height.constant = ( self.scroll_Height.constant + jobs_Tble_Height.constant) - 300

    }

    @IBAction func action_IsTapppedIndustry(_ sender: Any) {
        if  self.btn_Industry.tag  == 0{
            self.btn_Industry.tag = 1
        }else{
            self.btn_Industry.tag = 0
        }
        self.manageHeight()
    }
    
    func manageHeight(){
        if  self.btn_Industry.tag  == 0{
            self.vw_Table_Height.constant = 0.0
            self.tbl_Height.constant = 0.0
        }else{
            self.vw_Table_Height.constant = 190
            self.tbl_Height.constant = 176.0
        }
        self.handleRemoveBtnVisibility()
    }
    
    func handleRemoveBtnVisibility(){
        if  self.btn_Industry.tag  == 0{
            self.MainVw_Industries.layer.cornerRadius = 0.0
            self.MainVw_Industries.layer.borderColor = UIColor.clear.cgColor
            self.MainVw_Industries.layer.borderWidth = 0.0
        }else{
            self.MainVw_Industries.layer.cornerRadius = 10.0
            self.MainVw_Industries.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
            self.MainVw_Industries.layer.borderWidth = 1.0
        }
    }
    @IBAction func actio_addLocation(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
           if let locationVC = storyboard.instantiateViewController(withIdentifier: "CompanyLocationVC") as? CompanyLocationVC {
               locationVC.modalPresentationStyle = .overFullScreen
                  locationVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.2) // dim effect
                  
                  let nav = UINavigationController(rootViewController: locationVC)
                  nav.navigationBar.isHidden = true
                  nav.modalPresentationStyle = .overFullScreen   // 👈 keeps transparency
                  
                  self.present(nav, animated: true)
           }
    }
}
extension CompanyDetailVC: CommonDetailChildDelegate {
    func enableEditing(_ isEnabled: Bool) {
            // Enable or disable editing UI
            if isEnabled {
                self.isComeFromUpdate = true
               
            } else {
                self.isComeFromUpdate = false
            }
        isEditap()
        }
    func isEditap(){
#if BackpackerHire
        if isComeFromUpdate == true{
            DispatchQueue.main.async {
                self.bussinesName_Vw.txtFld.isUserInteractionEnabled = true
                self.btn_Industry.isUserInteractionEnabled = false
                self.tapImageBtn.isUserInteractionEnabled = false
            }
            self.btn_btnHeight.constant = 50.0
        }else{
            self.isComeFromUpdate = false
            self.btn_btnHeight.constant = 0.0
        }
        #endif
    }
}
extension CompanyDetailVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == jobs_TblVw{
            return jobsTotalCount
        }else{
            return listOfIndeustries?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == jobs_TblVw{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyDetailTVC", for: indexPath) as? CompanyDetailTVC else {
                return UITableViewCell()
            }

            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportIssueTVC", for: indexPath) as? ReportIssueTVC else {
                return UITableViewCell()
            }

            cell.lbl_Issue.text = listOfIndeustries?[indexPath.row].name // assuming your cell has `lbl_title`
            return cell
        }
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != jobs_TblVw{
            let selectedIssue = listOfIndeustries?[indexPath.row]
                print("Selected issue: \(selectedIssue)")
            self.lbl_Val_SelctedIndustry.text = selectedIssue?.name
            self.btn_Industry.tag = 0
            self.manageHeight()
            self.setUpLblIndustryColor()
        }
       

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView != jobs_TblVw{
            
            return 50.0
        }else{
            return 130.0
        }
        
    }
    
    
}

extension CompanyDetailVC{
    
    private func setCompanyDetail(_ obj: Company){
        /*
         "_id": "68a2ffd6f26c026679d74b1a",
               "userId": "68a2ffd6f26c026679d74b1a",
               "name": "Acme Corporation",
               "industryTypeId": "68b4ffd6f26c026679d74b2b",
               "logo": "https://example.com/logo.png",
               "website": "https://acme-corp.com",
               "contactNumber": "+1234567890",
               "createdAt": "2025-01-10T08:00:00.000Z",
               "updatedAt": "2025-09-20T09:30:00.000Z"
         */
        self.bussinesName_Vw.txtFld.text = obj.name ?? ""
        
    }
    
    func getCompanyInfo() {
            LoaderManager.shared.show()
            
            profileVm.getCompanyDetail { [weak self] (success: Bool, result: CompanyCreateResponse?, statusCode: Int?) in
                guard let self = self else { return }
                
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
                        if success, let profileData = result?.data {
                            print("User Profile data fetched result:", profileData)
                            if profileData != nil{
                               // self.setCompanyDetail(profileData.company!)
                            }
                           
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getCompanyInfo() // Retry on token refresh success
                            } else {
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Session expired. Please log in again.")
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                }
            }
        }
    
    func getIndustriesList() {
        profileVm.getIndustriesList() { [weak self] (success: Bool, result: IndustryResponse?, statusCode: Int?) in
            guard let self = self else { return }
            
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
                    if success, let profileData = result?.data {
                        print("User Profile data fetched result:", profileData)
                        self.listOfIndeustries = result?.data.industries
                        self.tblVw.reloadData()
                       
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.getCompanyInfo() // Retry on token refresh success
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Session expired. Please log in again.")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                }
            }
        }
    }
    
    func createCompany(){
        
    }
}
