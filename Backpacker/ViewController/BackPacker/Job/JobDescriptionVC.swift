//
//  JobDescriptionVC.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit
import SDWebImage
class JobDescriptionVC: UIViewController {
    
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var mainScrollVw: UIScrollView!
    @IBOutlet weak var mainScrollHeight: NSLayoutConstraint!
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var description_ContainerVW: UIView!
    @IBOutlet weak var lblEmployer: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var vW_Employer: UIView!
    @IBOutlet weak var vW_Description: UIView!
    @IBOutlet weak var btn_Employer: UIButton!
    @IBOutlet weak var btn_Description: UIButton!
    
    @IBOutlet weak var lbl_Header: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var lbl_Address: UILabel!
    
    @IBOutlet weak var btn_Accept: UIButton!
    @IBOutlet weak var lbl_Time: UILabel!
    var firstVC: DescriptionController!
    var secondVC: EmployerController!
    let refreshControl = UIRefreshControl()
    var currentChildVC: UIViewController?
    var JobId : String?
    @IBOutlet weak var btn_Decline: UIButton!
    let viewMOdel = JobVM()
    let viewModelAuth = LogInVM()
    var isLoading: Bool = true // true while loading, false once data is ready
    var jobDetailObj : JobDetail?
    var jobDetailEmployerObj : EmployerJobDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_edit.isHidden = true
        self.btn_delete.isHidden = true
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        firstVC = storyboard.instantiateViewController(withIdentifier: "DescriptionController") as? DescriptionController
        secondVC = storyboard.instantiateViewController(withIdentifier: "EmployerController") as? EmployerController
        
        self.setUPBtns()
        self.setupPullToRefresh()
        btn_Accept.layer.cornerRadius = 10
        btn_Decline.layer.cornerRadius = 10
        applyGradientButtonStyle(to: btn_Accept)
        // Do any additional setup after loading the view.
        self.btn_Accept.isHidden = true
        self.btn_Accept.isUserInteractionEnabled = false
        
        self.btn_Decline.isHidden = true
        self.btn_Decline.isUserInteractionEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if Backapacker
        self.getDetailOfJob()
        self.segmentHeight.constant = 50.0
#else
        self.segmentHeight.constant = 0.0
        self.lbl_Description.isHidden = true
        self.lblEmployer.isHidden = true
        self.getEmployeeDetailOfJob()
        
#endif
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if   appDelegate.isComeFromNotification == true {
                appDelegate.isComeFromNotification = false
            }
            
        }
    }
    
    func refreshData(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if   appDelegate.isComeFromNotification == true {
#if BackpackerHire
                self.segmentHeight.constant = 0.0
                self.lbl_Description.isHidden = true
                self.lblEmployer.isHidden = true
                self.getEmployeeDetailOfJob()
                
#else
                self.getDetailOfJob()
                self.segmentHeight.constant = 50.0
                
#endif
            }
        }
    }
    private func handleEditBtnAppearance(){
#if BackpackerHire
        self.btn_edit.isHidden = true
        if jobDetailEmployerObj?.jobAcceptStatus == 1 {
            if let startDateString = jobDetailEmployerObj?.startDate {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                if let startDate = formatter.date(from: startDateString) {
                    let today = Date()
                    
                    if startDate > today {
                        // ✅ Start date is greater than current date
                        // Show Edit button here
                        self.btn_edit.isHidden = false
                        self.btn_delete.isHidden = false
                        print("Show Edit button")
                    } else {
                        // ❌ Start date is today or past
                        self.btn_edit.isHidden = true
                        self.btn_delete.isHidden = true
                        print("Hide Edit button")
                    }
                }
            }
        }

        #else
        self.btn_edit.isHidden = true
        
        #endif

    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshCollectionData), for: .valueChanged)
        self.mainScrollVw.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionData() {
        // Reset pagination and loading flags

        // Fetch data
        LoaderManager.shared.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
#if BackpackerHire
            self.getEmployeeDetailOfJob()
#else
            self.getDetailOfJob()
            self.btn_Description.tag = 1
            self.btn_Employer.tag = 0
            if self.btn_Description.tag == 1 {
                self.vW_Description.backgroundColor  = UIColor(named: "themeColor")
                self.lbl_Description.textColor = .white
                self.lblEmployer.textColor =  .black
                self.vW_Employer.backgroundColor = .clear
            }
            self.setBtnTitle()
            self.handleBotmBtnAppearance()
#endif
           
        }

        
    }
    
    
    private func setUPBtns(){
        self.btn_Description.tag = 1
        self.btn_Employer.tag = 0
        self.vW_Employer.layer.cornerRadius = 10
        self.vW_Description.layer.cornerRadius = 10
        self.vW_Description.backgroundColor = UIColor(named: "themeColor")
        self.lblEmployer.textColor = .black
        self.lbl_Description.textColor =  .white
        
        
        self.lbl_Description.text = "Description"
        self.lblEmployer.text = "Employer"
        lbl_Header.font = FontManager.inter(.medium, size: 16.0)
        lblTitle.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Address.font = FontManager.inter(.regular, size: 12.0)
        lbl_Time.font = FontManager.inter(.regular, size: 12.0)
        lbl_Description.font = FontManager.inter(.medium, size: 14.0)
        lblEmployer.font = FontManager.inter(.medium, size: 14.0)
    }
    
    @IBAction func action_btnDescription(_ sender: Any) {
        self.btn_Description.tag = 1
        self.btn_Employer.tag = 0
        if btn_Description.tag == 1 {
            self.vW_Description.backgroundColor  = UIColor(named: "themeColor")
            self.lbl_Description.textColor = .white
            self.lblEmployer.textColor =  .black
            self.vW_Employer.backgroundColor = .clear
        }
        self.setBtnTitle()
        self.showChild(firstVC)
        self.handleBotmBtnAppearance()
    }
    @IBAction func action_BtnEmployer(_ sender: Any) {
        
        self.btn_Employer.tag = 1
        self.btn_Description.tag = 0
        if btn_Employer.tag == 1 {
            self.vW_Employer.backgroundColor = UIColor(named: "themeColor")
            self.lblEmployer.textColor = .white
            self.lbl_Description.textColor =  .black
            self.vW_Description.backgroundColor = .clear
        }
        self.setBtnTitle()
        self.showChild(secondVC)
        self.handleBotmBtnAppearance()
    }
    
    @IBAction func action_Bck(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setBtnTitle(){
        self.lbl_Description.text = "Description"
        self.lblEmployer.text = "Employer"
    }
    
    @IBAction func action_delete(_ sender: Any) {
      
#if BackpackerHire
        AlertManager.showConfirmationAlert(on: self,
                                           title: "Delete Job",
                                           message: "Are you sure you want to delete the job?",
                                           confirmAction: {
            if let id = self.JobId{
                self.empDeleteJOb(jobID: id)
            }else{
                AlertManager.showAlert(on: self, title: "Missing", message: "Job Id Is Missing")
            }
           
            
        })
#endif
       
    }
    @IBAction func action_Edit(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        if let accVC = storyboard.instantiateViewController(withIdentifier: "AddNewJobVC") as? AddNewJobVC {
            accVC.jobID = self.JobId ?? ""
            
            let addres = self.jobDetailEmployerObj?.address ?? ""
            let name = self.jobDetailEmployerObj?.name ?? ""
            let description = self.jobDetailEmployerObj?.description ?? ""
            let price = self.jobDetailEmployerObj?.price ?? 0
            let loc = self.jobDetailEmployerObj?.locationText ?? ""
            let lat = self.jobDetailEmployerObj?.lat ?? 0.0
            let long = self.jobDetailEmployerObj?.long ?? 0.0
            accVC.isComeFromEdit = true
            let date = self.jobDetailEmployerObj?.startDate ?? ""
            let enddate = self.jobDetailEmployerObj?.endDate ?? ""
            let strtTime = self.jobDetailEmployerObj?.startTime ?? ""
            let endTime = self.jobDetailEmployerObj?.endTime ?? ""
            let req  = self.jobDetailEmployerObj?.requests
        //    let assgnBckPkr = self.jobDetailObj.
            if let imageUrls = self.jobDetailEmployerObj?.image {
                ImageLoader.loadImages(from: [imageUrls]) { images in
                    // here you get your [UIImage]
                  //  accVC.editImagess = images.first
                    accVC.editImageData = images.first
                    accVC.editImagess = self.jobDetailEmployerObj?.image
                    accVC.editBackPackersList = self.jobDetailEmployerObj?.requests
                    accVC.editName = name
                    accVC.editHeadAddress = addres
                    accVC.editdescription = description
                    accVC.editrequirment = self.jobDetailEmployerObj?.requirements ?? ""
                    accVC.editLocation = loc
                    accVC.editLat = lat
                    accVC.editLongitude = long
                    accVC.editrate = "\(price)"
                    accVC.editDate = date
                    accVC.editEndDate = enddate
                    accVC.editStartTime = strtTime
                    accVC.editEndTime = endTime
                    self.navigationController?.pushViewController(accVC, animated: true)
                }
            }
        } else {
            print("❌ Could not instantiate AddNewAccomodationVC")
        }
        
        
    }
    private func showChild(_ newVC: UIViewController) {
        // Remove current child if any
        /*
         if let descVC = newVC as? DescriptionController {
             descVC.delegate = self
 #if BackpackerHire
             descVC.EmpobjJobDetail = self.jobDetailEmployerObj
           //  descVC.refreshData?(obj: self.jobDetailEmployerObj)
             if let obj = self.jobDetailEmployerObj{
                 descVC.refreshData(obj: obj)
             }
           
 #else
             descVC.objJobDetail = self.jobDetailObj
 #endif
            
         }
         */
      
        if let currentVC = currentChildVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        // Add new child
        addChild(newVC)
        newVC.view.frame = description_ContainerVW.bounds // ✅ Corrected line
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        description_ContainerVW.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        
        // Update current
        currentChildVC = newVC
        if let descVC = newVC as? DescriptionController {
            descVC.delegate = self
#if BackpackerHire
            descVC.EmpobjJobDetail = self.jobDetailEmployerObj
            if let obj = self.jobDetailEmployerObj{
                descVC.refreshData(obj: obj)
            }
          
#else
            descVC.objJobDetail = self.jobDetailObj
            if let obj = self.jobDetailObj{
                descVC.refreshDatabp(obj: obj)
                self.setupBtnAppearanceStatus(obj: obj)
            }
            
#endif
           
        }
        if let empVC = newVC as? EmployerController {
            empVC.objJobDetail = self.jobDetailObj
        }
    }
    
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_JobAccept(_ sender: Any) {
        
#if Backapacker
        if jobDetailObj?.jobAcceptStatus == 1 {
            AlertManager.showConfirmationAlert(on: self,
                                               title: "",
                                               message: "Are you sure you want to accept the job?",
                                               confirmAction: {
                if let id = self.JobId{
                    self.acceptRejectJob(status: "accepted")
                }else{
                    AlertManager.showAlert(on: self, title: "Missing", message: "Job Id Is Missing")
                }
               
                
            })
        }
      
       
#endif
    }
    @IBAction func action_Decline(_ sender: Any) {
        
#if Backapacker
        if jobDetailObj?.jobAcceptStatus == 1 {
            AlertManager.showConfirmationAlert(on: self,
                                               title: "",
                                               message: "Are you sure you want to reject the job?",
                                               confirmAction: {
                if let id = self.JobId{
                    self.acceptRejectJob(status: "rejected")
                }else{
                    AlertManager.showAlert(on: self, title: "Missing", message: "Job Id Is Missing")
                }
               
                
            })
        }
    
      
#endif
    }
}


extension JobDescriptionVC {
    
    
    func getDetailOfJob(){
        LoaderManager.shared.show()
        isLoading = true
        if JobId?.isEmpty == true {
            LoaderManager.shared.hide()
            AlertManager.showAlert(
                on: self,
                title: "Alert",
                message: "Job ID is missing."
            )
            
            return
        }else{
            viewMOdel.getBackPackerJobDetail(jobID: self.JobId ?? ""){ [weak self] (success: Bool, result: JobDetailResponse?, statusCode: Int?) in
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
                                if result?.data.job != nil{
                                    self.jobDetailObj = result?.data.job
                                    self.setUpValues(obj: self.jobDetailObj!)
                                    self.isLoading = false
                                    self.showChild(self.firstVC)
                                }else{
                                    
                                }
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                
                                LoaderManager.shared.hide()
                            }
                            self.refreshControl.endRefreshing()
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.getDetailOfJob()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.isLoading = false
                                    self.refreshControl.endRefreshing()
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    private func acceptRejectJob(status:String){
        LoaderManager.shared.show()
        isLoading = true
        if JobId?.isEmpty == true {
            LoaderManager.shared.hide()
            AlertManager.showAlert(
                on: self,
                title: "Alert",
                message: "Job ID is missing."
            )
            
            return
        }else{
            
            viewMOdel.acceptRejectJob(jobID: self.JobId ?? "", status: status){ [weak self] (success: Bool, result: DeleteJobResponse?, statusCode: Int?) in
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
                                AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? ""){
                                    self.getDetailOfJob()
                                }
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                
                            }
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.getDetailOfJob()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.isLoading = false
                                    self.refreshControl.endRefreshing()
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
        }
    }
    
#if BackpackerHire
    func getEmployeeDetailOfJob(){
        LoaderManager.shared.show()
        isLoading = true
        if JobId?.isEmpty == true {
            LoaderManager.shared.hide()
            AlertManager.showAlert(
                on: self,
                title: "Alert",
                message: "Job ID is missing."
            )
            
            return
        }else{
            viewMOdel.getEmployerJobDetail(jobID: self.JobId ?? ""){ [weak self] (success: Bool, result: EmployerJobDetailResponse?, statusCode: Int?) in
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
                                if result?.data.job != nil{
                                    self.jobDetailEmployerObj = result?.data.job
                                    self.setUpValuesEmployer(obj:  self.jobDetailEmployerObj!)
                                    self.isLoading = false
                                    self.showChild(self.firstVC)
                                }else{
                                    
                                }
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                
                                LoaderManager.shared.hide()
                            }
                            self.refreshControl.endRefreshing()
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.getEmployeeDetailOfJob()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.isLoading = false
                                    self.refreshControl.endRefreshing()
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    func empDeleteJOb(jobID:String){
        LoaderManager.shared.show()
        isLoading = true
        if JobId?.isEmpty == true {
            LoaderManager.shared.hide()
            AlertManager.showAlert(
                on: self,
                title: "Alert",
                message: "Job ID is missing."
            )
            
            return
        }else{
            viewMOdel.deleteJob(jobID: self.JobId ?? ""){ [weak self] (success: Bool, result: DeleteJobResponse?, statusCode: Int?) in
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
                                AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Job deleted successfully"){
                                    self.navigationController?.popViewController(animated: true)
                                }
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                
                            }
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.empDeleteJOb(jobID: self.JobId ?? "")
                                } else {
                                    LoaderManager.shared.hide()
                                    self.isLoading = false
                                    self.refreshControl.endRefreshing()
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
        }
    }
#endif
    func setUpValues(obj : JobDetail){
        
        self.lblTitle.text = obj.name
        self.lbl_Address.text = obj.address
        let duration = calculateDuration(startTime: obj.startTime, endTime: obj.endTime)
        self.lbl_Time.text = duration
        let imageStr = obj.image
        if !imageStr.isEmpty {
            let baseURL1 = ApiConstants.API.API_IMAGEURL
            let baseURL2 = ApiConstants.API.API_IMAGEURL

            let imageURLString = imageStr.hasPrefix("http") ? imageStr : baseURL1 + imageStr

            img_Profile.sd_setImage(
                with: URL(string: imageURLString),
                placeholderImage: UIImage(named: "Profile")
            ) { image, error, _, _ in
                if image == nil { // If first attempt fails
                    let fallbackURL = imageStr.hasPrefix("http") ? imageStr : baseURL2 + imageStr
                    self.img_Profile.sd_setImage(
                        with: URL(string: fallbackURL),
                        placeholderImage: UIImage(named: "Profile")
                    )
                }
            }

        } else {
            img_Profile.image = UIImage(named: "Profile")
        }
        
        self.setupBtnAppearanceStatus(obj: obj)
    }
    
   private func setupBtnAppearanceStatus(obj:JobDetail){
       if obj.jobAcceptStatus == 1 {
           self.btn_Accept.isHidden = false
           self.btn_Accept.isUserInteractionEnabled = true
           self.btn_Decline.isHidden = false
           self.btn_Decline.isUserInteractionEnabled = true
           applyGradientButtonStyle(to: btn_Accept)
       } else if obj.jobAcceptStatus == 2 {
           self.btn_Accept.isHidden = false
           self.btn_Accept.setTitle("Accepted", for: .normal)
           self.btn_Accept.isUserInteractionEnabled = false
           applyGradientButtonStyle(to: btn_Accept)
           self.btn_Decline.isHidden = true
           self.btn_Decline.isUserInteractionEnabled = false
       }else if obj.jobAcceptStatus == 3 {
           self.btn_Accept.isHidden = false
           self.btn_Accept.isUserInteractionEnabled = false
           self.btn_Accept.setTitle("Declined", for: .normal)
           applyGradientButtonStyle(to: btn_Accept)
           self.btn_Decline.isHidden = true
           self.btn_Decline.isUserInteractionEnabled = false
       }else{
           self.btn_Accept.isHidden = true
           self.btn_Accept.isUserInteractionEnabled = false
           
           self.btn_Decline.isHidden = true
           self.btn_Decline.isUserInteractionEnabled = false
       }
       
    }
    func setUpValuesEmployer(obj : EmployerJobDetail){
        DispatchQueue.main.async {
            self.lblTitle.text = obj.name
            self.lbl_Address.text = obj.address
            let duration = self.calculateDuration(startTime: obj.startTime, endTime: obj.endTime)
            self.lbl_Time.text = duration
            let imageStr = obj.image
            if !imageStr.isEmpty {
                let baseURL1 = ApiConstants.API.API_IMAGEURL
                let baseURL2 = ApiConstants.API.API_IMAGEURL

                let imageURLString = imageStr.hasPrefix("http") ? imageStr : baseURL1 + imageStr

                self.img_Profile.sd_setImage(
                    with: URL(string: imageURLString),
                    placeholderImage: UIImage(named: "Profile")
                ) { image, error, _, _ in
                    if image == nil { // If first attempt fails
                        let fallbackURL = imageStr.hasPrefix("http") ? imageStr : baseURL2 + imageStr
                        self.img_Profile.sd_setImage(
                            with: URL(string: fallbackURL),
                            placeholderImage: UIImage(named: "Profile")
                        )
                    }
                }

            } else {
                self.img_Profile.image = UIImage(named: "Profile")
            }
            self.btn_Accept.isHidden = true
            self.btn_Accept.isUserInteractionEnabled = false
            
            self.btn_Decline.isHidden = true
            self.btn_Decline.isUserInteractionEnabled = false
            self.handleEditBtnAppearance()
        }
 
        /*
         if obj.jobAcceptStatus == 1 {
             self.btn_Accept.isHidden = false
             self.btn_Accept.isUserInteractionEnabled = true
             self.btn_Decline.isHidden = false
             self.btn_Decline.isUserInteractionEnabled = true
             applyGradientButtonStyle(to: btn_Accept)
         } else if obj.jobAcceptStatus == 2 {
             self.btn_Accept.isHidden = false
             self.btn_Accept.setTitle("Accepted", for: .normal)
             self.btn_Accept.isUserInteractionEnabled = false
             applyGradientButtonStyle(to: btn_Accept)
             self.btn_Decline.isHidden = true
             self.btn_Decline.isUserInteractionEnabled = false
         }else if obj.jobAcceptStatus == 3 {
             self.btn_Accept.isHidden = false
             self.btn_Accept.isUserInteractionEnabled = false
             self.btn_Accept.setTitle("Declined", for: .normal)
             applyGradientButtonStyle(to: btn_Accept)
             self.btn_Decline.isHidden = true
             self.btn_Decline.isUserInteractionEnabled = false
         }else{
             self.btn_Accept.isHidden = true
             self.btn_Accept.isUserInteractionEnabled = false
             
             self.btn_Decline.isHidden = true
             self.btn_Decline.isUserInteractionEnabled = false
         }
         */
       
        
        
    }
    func calculateDuration(startTime: String, endTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            return "Invalid time"
        }
        
        let diff = end.timeIntervalSince(start)
        
        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        
        if minutes == 0 {
            return "\(hours) hr"
        } else {
            return "\(hours) hr \(minutes) min"
        }
    }
    
    
    
}
extension JobDescriptionVC : DescriptionControllerDelegate {
    
    
    func descriptionController(_ controller: DescriptionController, didUpdateHeight height: CGFloat) {
        print("Child view height is: \(height)")
        //320 is View Height top like profile etc.
        self.mainScrollVw.layoutIfNeeded()
        self.mainScrollHeight.constant = 305 + height
        
    }
    
    func handleBotmBtnAppearance(){
        if   self.btn_Description.tag == 1{
            self.btn_Accept.isHidden = false
            self.btn_Accept.isUserInteractionEnabled = true
            
            self.btn_Decline.isHidden = false
            self.btn_Decline.isUserInteractionEnabled = true
        }else{
            
            self.btn_Accept.isHidden = true
            self.btn_Accept.isUserInteractionEnabled = false
            
            self.btn_Decline.isHidden = true
            self.btn_Decline.isUserInteractionEnabled = false
        }
    }
}
