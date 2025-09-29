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
    
    @IBOutlet weak var main_scrollVw: UIScrollView!
    @IBOutlet weak var MainVw_Industries: UIView!
    @IBOutlet weak var btn_Industry: UIButton!
    @IBOutlet weak var placeholder_Vw: UIView!
    var isComeFromUpdate : Bool = false
    var isLoading : Bool = false
    var iscomeFromCamera : Bool = false
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
    var industryId : String?
    var  locations: [LocationList]?
    var companyDetailObj : CompanyDetail?
    
    
    var page = 1
    let perPage = 10
    var totalAccomodations = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var isComFromSearch : Bool = false
    var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if iscomeFromCamera == false{
            self.getCompanyInfo()
            self.getIndustriesList()
            self.getListOfLocationAll()
        }
      
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       /// jobs_Tble_Height.constant = CGFloat(locations?.count ?? 0) * (100 + 10)
    }
    func setUpUI(){
        self.main_scrollVw.delegate = self
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
        self.selected_Image.image = UIImage(named: "BgUploadImage")
        self.updateAppearanceOfBottomBtns()
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
    
    @IBAction func action_save(_ sender: Any) {
        guard let name = bussinesName_Vw.txtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !name.isEmpty else {
                AlertManager.showAlert(on: self, title: "Field Missing", message: "Please enter business name")
                return
            }
            
            guard let industry = lbl_Val_SelctedIndustry.text,
                  !industry.isEmpty,
                  industry != "Select Industry" else {
                AlertManager.showAlert(on: self, title: "Field Missing", message: "Please select industry")
                return
            }
            
        if selected_Image.image == UIImage(named: "BgUploadImage") {
            AlertManager.showAlert(on: self, title: "Image Missing", message: "Please choose image")
        }else{
            guard let imageData = selected_Image.image?.jpegData(compressionQuality: 0.8) else {
                AlertManager.showAlert(on: self, title: "Error", message: "Could not process image")
                return
            }
            let industryTypeId = industryId ?? ""
                let contactNumber = "1234567890"
                let website = "www.google.com"
                
            if isComeFromUpdate == true {
                self.updateCompany(
                    name: name,
                    industryTypeId: industryTypeId,
                    contactNumber: contactNumber,
                    website: website,
                    logo: imageData
                )
            }else{
                self.createCompany(
                    name: name,
                    industryTypeId: industryTypeId,
                    contactNumber: contactNumber,
                    website: website,
                    logo: imageData
                )
            }
              
        }
        
    }
    
    
    @IBAction func action_cancle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpImagePlacehoder(){
        DispatchQueue.main.async {
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
      
    }
    func reloadTableData() {
        jobs_TblVw.reloadData()
        jobs_TblVw.layoutIfNeeded()
        jobs_Tble_Height.constant = CGFloat(locations?.count ?? 0) * (105)
        let constantHeight = CGFloat(locations?.count ?? 0) * (105)
        let mainScrolHeight = self.scroll_Height.constant - constantHeight
        self.scroll_Height.constant = ( mainScrolHeight + jobs_Tble_Height.constant) - 300

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
        self.btn_Industry.isUserInteractionEnabled = true
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
               locationVC.delegate = self
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
        self.updateAppearanceOfBottomBtns()
        }
    func updateAppearanceOfBottomBtns() {
        if companyDetailObj == nil {
            self.btn_btnHeight.constant = 50.0
            self.btn_Save.isHidden = false
            self.btn_Cancle.isHidden = false
            self.btn_Save.setTitle("Save", for: .normal)
            applyGradientButtonStyle(to: self.btn_Save)
        }else{
            DispatchQueue.main.async { [self] in
                if isComeFromUpdate == true{
                    self.btn_btnHeight.constant = 50.0
                    self.btn_Save.isHidden = false
                    self.btn_Cancle.isHidden = false
                    self.btn_Save.setTitle("Update", for: .normal)
                    applyGradientButtonStyle(to: self.btn_Save)
                }else{
                    self.btn_Save.setTitle("", for: .normal)
                    self.btn_Save.setTitle("", for: .normal)
                    self.btn_btnHeight.constant = 0.0
                    self.btn_Save.isHidden = true
                    self.btn_Cancle.isHidden = true
                }
                
            }
          
        }
    }
    
    func isEditap(){
#if BackpackerHire
        if isComeFromUpdate == true{
            DispatchQueue.main.async {
                //self.bussinesName_Vw.txtFld.isUserInteractionEnabled = true
//                self.btn_Industry.isUserInteractionEnabled = false
//                self.tapImageBtn.isUserInteractionEnabled = false
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
            return locations?.count ?? 0
        }else{
            return listOfIndeustries?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == jobs_TblVw{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyDetailTVC", for: indexPath) as? CompanyDetailTVC else {
                return UITableViewCell()
            }
            cell.lbl_Location.text = locations?[indexPath.row].name ?? ""
            cell.onDeleteButtonTapped = { [weak self] in
                guard let self = self else { return }
                let locationId = self.locations?[indexPath.row].id

                AlertManager.showConfirmationAlert(
                    on: self,
                    title: "Delete Location",
                    message: "Are you sure you want to delete the Location?",
                    confirmAction: {
                        if locationId?.isEmpty == false {
                            self.deleteLocation(loactionId: locationId!)
                        } else {
                            AlertManager.showAlert(on: self, title: "Missing", message: "Location Id Is Missing")
                        }
                    }
                )
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
            self.industryId = selectedIssue?.id
            self.btn_Industry.tag = 0
            self.manageHeight()
            self.setUpLblIndustryColor()
        }
       

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView != jobs_TblVw{
            return 50.0
        }else{
            return 100.0
        }
        
    }
    
    
}

extension CompanyDetailVC{
    
    private func setCompanyDetail(_ obj: CompanyDetail){
        self.bussinesName_Vw.txtFld.text = obj.name
        self.lbl_Val_SelctedIndustry.text = obj.industryType?.name ?? ""
        self.industryId = obj.industryType?.id ?? ""
        let image = obj.logo
        let baseURL1 = ApiConstants.API.API_IMAGEURL

        let imageURLString: String
        if ((image?.hasPrefix("http")) != nil) {
            imageURLString = image ?? ""
        } else {
            imageURLString = baseURL1 + (image ?? "")
        }

        self.selected_Image.sd_setImage(
            with: URL(string: imageURLString),
            placeholderImage: UIImage(named: "BgUploadImage"),
            options: [],
            completed: { [weak self] loadedImage, error, _, _ in
                guard let self = self else { return }
                if loadedImage == nil {
                    // First attempt failed, try HTTPS or alternative path if needed
                    var fallbackURLString = image
                    if !(image?.hasPrefix("http") ?? false) {
                        fallbackURLString = baseURL1 + (image ?? "")
                    }
                    
                    // Only retry if the fallback URL is different
                    if fallbackURLString != imageURLString {
                        self.selected_Image.sd_setImage(
                            with: URL(string: fallbackURLString ?? ""),
                            placeholderImage: UIImage(named: "BgUploadImage")
                        )
                    }
                }
            }
           
        )

    
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
                            if let company = profileData.company {
                                self.companyDetailObj = company
                                if company.id == nil {
                                    self.companyDetailObj = nil
                                }else{
                                    self.setCompanyDetail(company)
                                }
                               
                            }else{
                                self.companyDetailObj = nil
                            }
                            self.updateAppearanceOfBottomBtns()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                self.setUpImagePlacehoder()
                            }
                            self.setUpLblIndustryColor()
                           
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
    
    func createCompany(name: String,
                               industryTypeId: String,
                               contactNumber: String,
                               website: String,
                               logo: Data?){
            LoaderManager.shared.show()

        profileVm.addCompanyDetail(name: name, industryTypeId: industryTypeId, logo: logo, website: website, contactNumber: contactNumber){ success, message ,statusCode in
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
                        if success == true {
                            AlertManager.showAlert(on: self, title: "Success", message: message ?? "Comapny Added."){
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.createCompany(name: name, industryTypeId: industryTypeId, contactNumber: contactNumber, website: website, logo: logo)
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
    
    func updateCompany(name: String,
                               industryTypeId: String,
                               contactNumber: String,
                               website: String,
                               logo: Data?){
            LoaderManager.shared.show()

        profileVm.updateComapnyDetail(name: name, industryTypeId: industryTypeId, logo: logo, website: website, contactNumber: contactNumber){ success, message ,statusCode in
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
                        if success == true {
                            AlertManager.showAlert(on: self, title: "Success", message: message ?? "Comapny Added."){
                                self.getCompanyInfo()
                            }
                            
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.createCompany(name: name, industryTypeId: industryTypeId, contactNumber: contactNumber, website: website, logo: logo)
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
    func getListOfLocationAll(){
        let trimmedSearch = ""
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
        }
        profileVm.getCompanyLocationList(page: page, perPage: perPage, search: trimmedSearch)  { [weak self] (success: Bool, result: LocationResponse?, statusCode: Int?) in
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
                            let newLocations = result?.data.locations
                            
                            if self.page == 1 {
                                if newLocations?.count == 0 {
                                    self.locations?.removeAll()
                                    self.locations = newLocations
                                } else {
                                    self.locations?.removeAll()
                                    self.isLoading = false
                                    self.locations = newLocations
                                }
                            } else {
                                self.isLoading = false
                                self.locations?.append(contentsOf: newLocations ?? [])
                            }
                            self.totalAccomodations = result?.data.total ?? 0
                            // Pagination end check
                            self.isAllDataLoaded = newLocations?.count ?? 0 < self.perPage
                            
                         
                            self.isLoadingMoreData = false
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                       
                            self.isLoadingMoreData = false
                            self.isComeFromPullTorefresh = false
                            self.lastContentOffset = 0.0
                            LoaderManager.shared.hide()
                        }
                        self.reloadTableData()
                        self.hideBottomLoader()
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                     
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfLocationAll()
                            } else {
                                LoaderManager.shared.hide()
                                self.jobs_TblVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                
                            }
                        }
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.jobs_TblVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.jobs_TblVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                     
                    case .methodNotAllowed:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                     
                    case .internalServerError:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    
                    }
                }
            }
            }
    }
    
    func deleteLocation(loactionId:String){
        LoaderManager.shared.show()
        isLoading = true
        if loactionId.isEmpty == true {
            LoaderManager.shared.hide()
                AlertManager.showAlert(
                    on: self,
                    title: "Alert",
                    message: "Location ID is missing."
                )
            
            return
        }else{
            profileVm.delete(locationID: loactionId){ [weak self] (success: Bool, result: DeleteJobResponse?, statusCode: Int?) in
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
                                AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Location deleted successfully"){
                                    self.page = 1
                             self.getListOfLocationAll()
                                }
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                
                            }
                            LoaderManager.shared.hide()
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.deleteLocation(loactionId: loactionId)
                                } else {
                                    LoaderManager.shared.hide()
                                    self.isLoading = false
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            LoaderManager.shared.hide()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            LoaderManager.shared.hide()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
        }
        
    }
}


extension CompanyDetailVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Skip if pulling down from top
        if scrollView.contentOffset.y < 0 { return }

        // Detect scroll direction
        let isScrollingDown = scrollView.contentOffset.y > lastContentOffset
        lastContentOffset = scrollView.contentOffset.y

        guard isScrollingDown else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Check if near bottom (300pt threshold)
        if offsetY > contentHeight - frameHeight - 300 {
            if !isLoading && !isLoadingMoreData && !isAllDataLoaded {
                isLoadingMoreData = true
                showBottomLoader()

                page += 1

                // Simulate data fetch or call your API
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.getListOfLocationAll()
                }
            }
        }
    }

    private func showBottomLoader() {
        // Avoid adding multiple loaders
        if main_scrollVw.viewWithTag(9999) != nil { return }

        let loader = UIActivityIndicatorView(style: .medium)
        loader.tag = 9999
        loader.center = CGPoint(
            x: main_scrollVw.frame.width / 2,
            y: main_scrollVw.contentSize.height + 25
        )
        loader.startAnimating()
        main_scrollVw.addSubview(loader)
    }

    private func hideBottomLoader() {
        if let loader = main_scrollVw.viewWithTag(9999) as? UIActivityIndicatorView {
            loader.removeFromSuperview()
        }
        isLoadingMoreData = false
    }

    
}
extension CompanyDetailVC : CompanyLocationVCDelegate {
    func didLocationAdded(success: Bool) {
        if success == true{
            self.getListOfLocationAll()
        }
    }

}
