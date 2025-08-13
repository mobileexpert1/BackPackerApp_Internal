//
//  CommonGridVC.swift
//  Backpacker
//
//  Created by Mobile on 05/08/25.
//

import UIKit

class CommonGridVC: UIViewController {
    
    @IBOutlet weak var main_Header: UILabel!
    @IBOutlet weak var collVw: UICollectionView!
    var currentPage = 1
    var isFetchingData = false
    var hasMorePages = true
    var isLoadingMore = false
    
    @IBOutlet weak var btn_searchCross: UIButton!
    @IBOutlet weak var lbl_nodata_Found: UILabel!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var seacrh_Vw: UIView!
    var isComeFromJobSections : Bool = false
    var isComeFromHomeJob : Bool = false
    var isComeFromHomeAccomodation : Bool = false
    var isComeFromHomeHangout : Bool = false
    
    let viewModel = JobVM()
    let viewModelAuth = LogInVM()
    var type : Int?
    var jobslist =  [Job]()
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    var accommodationList = [Accommodation]()
    
    var page = 1
    let perPage = 6
    var totalJobs = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var jobId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the collection view cell
        self.setupPullToRefresh()
        self.setUpUI()
        self.getListOfAll()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isComeFromPullTorefresh = false
        
    }
    func setUpUI(){
        btn_searchCross.isHidden = true
        self.lbl_nodata_Found.isHidden = true
        self.lbl_nodata_Found.text = "No Jobs Found"
        self.lbl_nodata_Found.isHidden = true
        let nib2 = UINib(nibName: "SkeltonCVC", bundle: nil)
               self.collVw.register(nib2, forCellWithReuseIdentifier: "SkeltonCVC")
        collVw.isSkeletonable = true
        collVw.register(UINib(nibName: "AccomodationCVC", bundle: nil), forCellWithReuseIdentifier: "AccomodationCVC")
        collVw.register(UINib(nibName: "HomeJobCVC", bundle: nil), forCellWithReuseIdentifier: "HomeJobCVC")
        collVw.register(UINib(nibName: "LoaderFooterViewCVC", bundle: nil),
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                        withReuseIdentifier: "LoaderFooterViewCVC")
        collVw.delegate = self
        collVw.dataSource = self
        
        if let layout = collVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        self.setUpStatus()
        self.main_Header.font = FontManager.inter(.semiBold, size: 16.0)
        self.seacrh_Vw.layer.cornerRadius = 25.0
        self.seacrh_Vw.layer.borderWidth = 0.8
        self.seacrh_Vw.layer.borderColor = UIColor(hex: "#000000").cgColor
        txtFldSearch.delegate = self
    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        self.collVw.refreshControl = refreshControl
    }
    
    @objc private func refreshTableData() {
        // Show the default spinner, reload after delay
        self.page = 1
        self.isAllDataLoaded = false
        self.isLoadingMoreData = false
        self.isLoading = true

        // Start refreshing UI
        self.refreshControl.beginRefreshing()
        isComeFromPullTorefresh = true
        // Fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.getListOfAll()
        }
       
    }
    @IBAction func action_ClearSearch(_ sender: Any) {
        txtFldSearch.text = ""
            lastSearchedText = ""
            page = 1
        txtFldSearch.resignFirstResponder()
        self.btn_searchCross.isHidden = true
            getListOfAll()
    }
    
    func setUpStatus(){
        if isComeFromJobSections == false{
            if isComeFromHomeJob == true{
                self.isComeFromHomeHangout = false
                self.isComeFromHomeAccomodation = false
                print("IsComefrom JOb")
                self.main_Header.text = "Jobs"
                
            }else  if isComeFromHomeHangout == true{
                self.isComeFromHomeJob = false
                self.isComeFromHomeAccomodation = false
                print("IsComefrom Hangout")
                self.main_Header.text = "Backpacker Hangout"
                
            }else  if isComeFromHomeAccomodation == true{
                self.isComeFromHomeJob = false
                self.isComeFromHomeHangout = false
                print("IsComefrom Accomodation")
                self.main_Header.text = "Accommodations"
                
            }
        }else{
            if isComeFromHomeJob == true{
                self.isComeFromHomeHangout = false
                self.isComeFromHomeAccomodation = false
                print("IsComefrom JOb")
                self.main_Header.text = "Declined Jobs"
                self.type = 2
                
            }else  if isComeFromHomeHangout == true{
                self.isComeFromHomeJob = false
                self.isComeFromHomeAccomodation = false
                print("IsComefrom Hangout")
                self.main_Header.text = "New Jobs"
                self.type = 3
                
            }else  if isComeFromHomeAccomodation == true{
                self.isComeFromHomeJob = false
                self.isComeFromHomeHangout = false
                print("IsComefrom Accomodation")
                self.main_Header.text = "Current Jobs"
                self.type = 1
                
            }
        }
       
        self.setTitleForSearch()
    }
    func setTitleForSearch(){
        if isComeFromJobSections == false {
            if isComeFromHomeJob == true{
                txtFldSearch.attributedPlaceholder = NSAttributedString(
                    string: "Declined Jobs",
                    attributes: [
                        .foregroundColor: UIColor.black,
                        .font: FontManager.inter(.regular, size: 14.0)
                    ])
               
                
            }else  if isComeFromHomeHangout == true{
                txtFldSearch.attributedPlaceholder = NSAttributedString(
                    string: "New Jobs",
                    attributes: [
                        .foregroundColor: UIColor.black,
                        .font: FontManager.inter(.regular, size: 14.0)
                    ])
                
            }else  if isComeFromHomeAccomodation == true{
                txtFldSearch.attributedPlaceholder = NSAttributedString(
                    string: "Current Jobs",
                    attributes: [
                        .foregroundColor: UIColor.black,
                        .font: FontManager.inter(.regular, size: 14.0)
                    ])
            }
        }else{
            
        }
       
    }
    @IBAction func action_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension CommonGridVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
#if BackpackerHire
            return 20
      
        #else
        if isLoading ==  true{
            return 8
        }else{
            return jobslist.count
        }
        
#endif
      
       
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
#if Backapacker
        if isLoading == true  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeltonCVC", for: indexPath) as? SkeltonCVC else {
                return UICollectionViewCell()
            }
            return cell
        }else{
            if isComeFromJobSections == false {
                if isComeFromHomeHangout == true || isComeFromHomeAccomodation == true{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }
                    // Optionally configure cell
                    return cell
                }else{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                        return UICollectionViewCell()
                    }
                    // Optionally configure cell
                    return cell
                }
                
            }else{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                    return UICollectionViewCell()
                }
                let item = jobslist[indexPath.item]
                cell.lbl_Title.text = item.name
                cell.lblAmount.text = "$\(item.price)"
                cell.lbl_SubTitle.text = item.description
                
                let imageURLString = item.image.hasPrefix("http") ? item.image : "http://192.168.11.4:3001/assets/\(item.image)"
                cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "profile"))
                if isComeFromHomeHangout == true { // New Job
                    cell.isComeForHiredetailpage = true
                    cell.lbl_jobStatus.text = ""
                    cell.statusVw.isHidden = true
                    cell.SetUpHeight(isHeightShow: false)
                } else if isComeFromHomeJob == true{
                    cell.isComeForHiredetailpage = true
                    cell.lbl_jobStatus.text = "Declined"
                    cell.statusVw.isHidden = false
                    cell.statusVw.backgroundColor = UIColor.red
                    cell.SetUpHeight(isHeightShow: true)
                }else{//Current job
                    cell.lbl_jobStatus.text = "Accepted"
                    cell.statusVw.isHidden = false
                    cell.statusVw.backgroundColor = UIColor(hex: "#00A925")
                    cell.SetUpHeight(isHeightShow: true)
                }
                let strtTime = item.startTime
                let endTime = item.endTime
                let duration1 = Date.durationString(from: strtTime , to: endTime) // "8 hr"
                cell.lbl_duration.text = "Duration \(duration1)"
                cell.onTap = { [weak self] val in
#if Backapacker
                    let id = self?.jobslist[indexPath.item].id
                    self?.jobId = id ?? ""
                    self?.navigateToDescriptionVC()
#endif
                }
                // Optionally configure cell
                return cell
            }
        }
        
        #else
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
        // Optionally configure cell
        return cell
        
        
#endif
           
     
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }

        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "LoaderFooterViewCVC",
            for: indexPath
        ) as! LoaderFooterViewCVC

        footer.lbl_fetching.isHidden = false
        footer.activityIndicator.isHidden = false

        if isAllDataLoaded {
            footer.lbl_fetching.text = "All data fetched"
            footer.activityIndicator.stopAnimating()
            footer.activityIndicator.isHidden = true
        } else if isLoadingMoreData {
            footer.lbl_fetching.text = "Loading more..."
            footer.activityIndicator.startAnimating()
        } else {
            footer.lbl_fetching.text = ""
            footer.activityIndicator.stopAnimating()
            footer.activityIndicator.isHidden = true
        }

        return footer
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if isComeFromJobSections == false{
            if isComeFromHomeJob == true{
                return CGSize(width: (width / 2) - 4, height: 178)
            }else{
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 225) // Adjust height based on content
            }
        }else{
            return CGSize(width: (width / 2) - 4, height: 195)
        }
    }


    
    // Horizontal spacing between items
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Vertical spacing between rows
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
     
        if isComeFromHomeJob == true {
            return UIEdgeInsets(top: 5, left: 0, bottom: 4, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
       
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoadingMoreData ? CGSize(width: collectionView.frame.width, height: 100) : .zero
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ){
                        self.getListOfAll()
                    }
                   
                }
            }
          
        }
    }
}

    extension CommonGridVC: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
              
              // Prevent leading space
              if currentText.isEmpty && string == " " {
                  return false
              }
              
              guard let stringRange = Range(range, in: currentText) else { return true }
              let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
              
              let hasText = !updatedText.trimmingCharacters(in: .whitespaces).isEmpty
              btn_searchCross.isHidden = !hasText

              // Cancel existing timer
              searchDebounceTimer?.invalidate()

              // Start a new timer (debounce delay)
              searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                  guard let self = self else { return }
                  let trimmedSearch = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)

                  if self.lastSearchedText != trimmedSearch {
                      self.lastSearchedText = trimmedSearch
                      self.page = 1
                      self.getListOfAll()
                  }
              }

              return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.btn_searchCross.isHidden = true
            textField.resignFirstResponder()
            return true
        }
    }



extension CommonGridVC {
    func getListOfAll(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            collVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
        }
        viewModel.getJobListSeeAllWithType(page: page, perPage: perPage, search: self.lastSearchedText, type: self.type ?? 1) { [weak self] (success: Bool, result: JobsResponse?, statusCode: Int?) in
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
                            let newJobs = result?.data.jobslist ?? []
                            
                            if self.page == 1 {
                                if newJobs.isEmpty {
                                    self.lbl_nodata_Found.isHidden = false
                                    self.jobslist.removeAll()
                                    self.jobslist = newJobs
                                    self.collVw.isHidden = true
                                } else {
                                    self.collVw.isHidden = false
                                    self.lbl_nodata_Found.isHidden = true
                                    self.jobslist = newJobs
                                }
                            } else {
                                self.jobslist.append(contentsOf: newJobs)
                            }
                            self.totalJobs = result?.data.total ?? 0
                            // Pagination end check
                            self.isAllDataLoaded = newJobs.count < self.perPage
                            
                            self.isLoading = false
                            self.isComeFromPullTorefresh = false
                            self.isLoadingMoreData = false
                            self.collVw.reloadData()
                            self.refreshControl.endRefreshing()
                            
                        } else {
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                            self.collVw.setContentOffset(.zero, animated: true)
                            LoaderManager.shared.hide()
                        }
                    case .badRequest:
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    case .unauthorized :
                        self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                            if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                self.getListOfAll()
                            } else {
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isLoading = false
                                self.collVw.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                            }
                        }
                        
                    case .unauthorizedToken:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.isLoading = false
                        self.collVw.setContentOffset(.zero, animated: true)
                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                    case .unknown:
                        LoaderManager.shared.hide()
                        self.refreshControl.endRefreshing()
                        self.isLoading = false
                        self.collVw.setContentOffset(.zero, animated: true)
                        AlertManager.showAlert(on: self, title: "Server Error", message: "Something went wrong. Try again later."){
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
    private func navigateToDescriptionVC(){
        if self.jobId.isEmpty == false{
            let storyboard = UIStoryboard(name: "Job", bundle: nil)
            if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
                jobDescriptionVC.JobId = self.jobId
                // Optional: pass selected job title
                self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
            }
        }
    }
}
