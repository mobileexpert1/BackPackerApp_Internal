//
//  HistoryVC.swift
//  Backpacker
//
//  Created by Sahil Sharma on 12/07/25.
//

import UIKit
import SkeletonView
class HistoryVC: UIViewController {

    @IBOutlet weak var historyCV: UICollectionView!
  //  @IBOutlet weak var Main_SettinhgVw: UIView!
    @IBOutlet weak var lbl_SubHeader: UILabel!
 //   @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lbl_No_AccomdodationFound: UILabel!
    var filteredDesignations: [String] = []
    let refreshControl = UIRefreshControl()
    var page = 1
    let perPage = 10
    var totalAccomodations = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    let viewModel = JobVM()
    let viewModelAuth = LogInVM()
    var isLoading: Bool = true // true while loading, false once data is ready
    var lastContentOffset: CGFloat = 0
    var jobData : [CompletedJob]?
    var jobId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_No_AccomdodationFound.text = "No Data Found"
        self.lbl_No_AccomdodationFound.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_No_AccomdodationFound.isHidden = true
        self.lbl_SubHeader.font = FontManager.inter(.semiBold, size: 16.0)
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        historyCV.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        let snib2 = UINib(nibName: "SkeltonCVC", bundle: nil)
        self.historyCV.register(snib2, forCellWithReuseIdentifier: "SkeltonCVC")
        historyCV.isSkeletonable = true
        historyCV.register(UINib(nibName: "LoaderFooterViewCVC", bundle: nil),
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                         withReuseIdentifier: "LoaderFooterViewCVC")
        
        
      
        self.setupPullToRefresh()
        self.getHistoryJobsList()
        self.historyCV.delegate = self
        self.historyCV.dataSource = self
        if let layout = historyCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshCollectionData), for: .valueChanged)
        self.historyCV.refreshControl = refreshControl
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
#if Backapacker
            self.getHistoryJobsList()
                
                #else
#endif
       
        }
        
    }

    @IBAction func action_Setting(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC {
               self.navigationController?.pushViewController(settingVC, animated: true)
           } else {
               print("- Could not instantiate SettingVC")
           }
    }
}


extension HistoryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading ==  true{
            return 8
        }else{
            return self.jobData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading == true{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeltonCVC", for: indexPath) as? SkeltonCVC else {
                return UICollectionViewCell()
            }
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                return UICollectionViewCell()
            }
            if let declineJob = self.jobData?[indexPath.item] {
                cell.onTap = { [weak self]  index in
                    guard let self = self else { return }
                    print("Cell tapped at index: \(indexPath.item)")
                  //  if let id =  declineJob.id {
                        print("Cell id tapped at index: \(declineJob.id)")
                        self.jobId = declineJob.id
                        self.navigateToDescriptionVC()
                  //  }
                 
                }
                cell.btn_fav.isHidden = true
                cell.btn_fav.isUserInteractionEnabled = false
                // Assign item to your label/image inside the cell
                // cell.titleLabel.text = item
                cell.lbl_Title.text = declineJob.name
                let amnt = declineJob.price
                    cell.lblAmount.text = "$\(amnt) per day"//per day
                
                cell.lbl_SubTitle.text = declineJob.description
                if declineJob.image.hasPrefix("http") {
                    cell.imgVw.sd_setImage(
                        with: URL(string: declineJob.image),
                        placeholderImage: UIImage(named: "Profile")
                    )
                } else {
                    let port3000 = "\(ApiConstants.API.API_IMAGEURL)\(declineJob.image)"
                    let port3001 = "\(ApiConstants.API.API_IMAGEURL)\(declineJob.image)"
                    
                    cell.imgVw.sd_setImage(with: URL(string: port3000), placeholderImage: UIImage(named: "img_Placehodler")) { image, _, _, _ in
                        if image == nil {
                            cell.imgVw.sd_setImage(with: URL(string: port3001), placeholderImage: UIImage(named: "img_Placehodler"))
                        }
                    }
                   
                    if declineJob.favoriteStatus == 1 {
                        cell.btn_fav.setImage(UIImage(named: "red_heart"), for: .normal)
                    }else{
                        cell.btn_fav.setImage(UIImage(named: "Heart"), for: .normal)
                    }
                }
                
                cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                let strtTime = declineJob.startTime
                let endTime = declineJob.endTime
                let duration1 = Date.durationString(from: strtTime , to: endTime ) // "8 hr"
                cell.lbl_duration.text = "Duration \(duration1)"
            }
    #if Backapacker
            cell.setUpUI(iscomeFromAccept: false)
            
    #else
            cell.setUpUI(iscomeFromAccept: true)
    #endif
            return cell
        }
  
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 180) // Adjust height based on content
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoadingMoreData ? CGSize(width: collectionView.frame.width, height: 100) : .zero
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Skip if pulling down from top
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
        
        // Check if near bottom
        if offsetY > contentHeight - frameHeight - 500 {
     
            if !isComeFromPullTorefresh {
                if !isLoading && !isLoadingMoreData && !isAllDataLoaded {
                    isLoadingMoreData = true
                    page += 1
                    historyCV.reloadSections(IndexSet(integer: 0))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
#if Backapacker
                        self.getHistoryJobsList()
                
                #else
                        
#endif
                    }
                }
            }
        }
    }
}


extension HistoryVC {
    
    
    private func getHistoryJobsList(){
        self.isLoading = true
            let trimmedSearch = ""
            LoaderManager.shared.show()
        viewModel.getCompletedJob(page: page, perPage: perPage, search: trimmedSearch)  { [weak self] (success: Bool, result: CompletedJobsResponse?, statusCode: Int?) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    LoaderManager.shared.hide()
                    self.isLoading = false
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
                                let newAccommodations = result?.data.completedJobsList ?? []
                                
                                if self.page == 1 {
                                    if newAccommodations.isEmpty {
                                        self.lbl_No_AccomdodationFound.isHidden = false
                                        self.jobData?.removeAll()
                                        self.jobData = newAccommodations
                                    } else {
                                        self.isLoading = false
                                      self.lbl_No_AccomdodationFound.isHidden = true
                                        self.jobData = newAccommodations
                                    }
                                } else {
                                   
                                    self.jobData?.append(contentsOf: newAccommodations)
                                }
                                self.totalAccomodations = result?.data.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = newAccommodations.count < self.perPage
                                
                                self.isLoading = false
                                self.isComeFromPullTorefresh = false
                                self.isLoadingMoreData = false
                                self.historyCV.reloadData()
                                self.refreshControl.endRefreshing()
                            } else {
                                self.isLoading = false
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                self.refreshControl.endRefreshing()
                                self.historyCV.setContentOffset(.zero, animated: true)
                                LoaderManager.shared.hide()
                            }
                        case .badRequest:
                            self.isLoading = false
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.getHistoryJobsList()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.refreshControl.endRefreshing()
                                    self.historyCV.setContentOffset(.zero, animated: true)
                                    NavigationHelper.showLoginRedirectAlert(on: self, message:  result?.message ?? "Internal Server Error")
                                    
                                }
                            }
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.isLoading = false
                            self.refreshControl.endRefreshing()
                            self.historyCV.setContentOffset(.zero, animated: true)
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                        case .unknown:
                            self.isLoading = false
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.historyCV.setContentOffset(.zero, animated: true)
                            AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                        case .methodNotAllowed:
                            self.isLoading = false
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            self.isLoading = false
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        }
                    }
                }
                }
    }
    
}
extension HistoryVC: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // Number of skeleton cells
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SkeltonCVC" // Your skeleton cell identifier
    }
    private func navigateToDescriptionVC(animation: Bool = true){
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
            jobDescriptionVC.JobId = self.jobId
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                jobDescriptionVC.notificationId = appDelegate.pendingNotificationId
            }
            
            // Optional: pass selected job title
            self.navigationController?.pushViewController(jobDescriptionVC, animated: animation)
        }
        
        
    }
}
