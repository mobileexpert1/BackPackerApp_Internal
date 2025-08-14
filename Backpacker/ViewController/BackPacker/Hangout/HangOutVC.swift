//
//  HangOutVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import MapKit
import SkeletonView
class HangOutVC: UIViewController {
    
    @IBOutlet weak var lbl_NDataFound: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtFld: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var collectIOnVw: UICollectionView!
    @IBOutlet weak var btn_cleartxtFld: UIButton!
    
    var filteredDesignations: [String] = []
    let viewModel = HangoutViewModel()
    let viewModelAuth = LogInVM()
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    var hangOutList = [BackPackerHangoutItem]()
    
    var page = 1
    let perPage = 10
    var totalAccomodations = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    
    var radius : Int?
    var facilities : String?
    var sortByPrice : String?
    var searchDebounceTimer: Timer?
    var lastSearchedText: String = ""
    var isComFromSearch : Bool = false
    var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
#if Backapacker
        self.listOfAllBackPackerHangOuts()
#endif
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    func setUpUI(){
        
        self.btn_cleartxtFld.isHidden = true
        let nib2 = UINib(nibName: "SkeltonCVC", bundle: nil)
        self.collectIOnVw.register(nib2, forCellWithReuseIdentifier: "SkeltonCVC")
        collectIOnVw.isSkeletonable = true
        
        self.lbl_NDataFound.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_NDataFound.isHidden = true
#if BackpackerHire
//        self.maVw_Height.constant = 0
//        self.lbl_nearBackpacker_Height.constant = 0
        self.btnAdd.isHidden = false
        self.btnAdd.isUserInteractionEnabled = true
#else
        self.btnAdd.isHidden = true
        self.btnAdd.isUserInteractionEnabled = false
#endif
        self.collectIOnVw.isScrollEnabled = true
        self.collectIOnVw.delegate = self
        self.collectIOnVw.dataSource = self
        self.btnAdd.titleLabel?.font = FontManager.inter(.medium, size: 12.0)
        let nib = UINib(nibName: "AccomodationCVC", bundle: nil)
        self.collectIOnVw.register(nib, forCellWithReuseIdentifier: "AccomodationCVC")
        
        collectIOnVw.register(UINib(nibName: "LoaderFooterViewCVC", bundle: nil),
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                         withReuseIdentifier: "LoaderFooterViewCVC")
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        self.searchVw.layer.borderWidth = 1.0
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        txtFld.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: FontManager.inter(.regular, size: 14.0)
            ])
        txtFld.delegate = self
        if let layout = collectIOnVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        self.setupPullToRefresh()
    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshCollectionData), for: .valueChanged)
        self.collectIOnVw.refreshControl = refreshControl
    }
    
    @objc private func refreshCollectionData() {
        // Reset pagination and loading flags
#if Backapacker
        self.page = 1
        self.isAllDataLoaded = false
        self.isLoadingMoreData = false
        self.isLoading = true
        
        // Start refreshing UI
        
        isComeFromPullTorefresh = true
        // Fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.listOfAllBackPackerHangOuts()
        }
#endif
        
    }
   
    @IBAction func action_ClearTExtFld(_ sender: Any) {
#if Backapacker
            
        self.isComFromSearch = false
        txtFld.text = ""
        lastSearchedText = ""
        page = 1
        txtFld.resignFirstResponder()
        self.btn_cleartxtFld.isHidden = true
        listOfAllBackPackerHangOuts()
            
#endif
    }
    
    @IBAction func action_filter(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.isComeFromHangOut = true
        vc.initialRadius = self.radius != nil ? String(self.radius!) : nil
        vc.onApplyFilters = { [weak self] facilities, sortBy, radius in
            print("Facilities: \(facilities ?? "-")")
            print("Sort by: \(sortBy ?? "-")")
            print("Radius: \(radius ?? "-")")
#if Backapacker
            self?.radius = Int(radius ?? "")
            // You can now use the data to filter your content
            self?.page = 1
            self?.listOfAllBackPackerHangOuts()
            #endif
        }
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func action__Add(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HangOut", bundle: nil)
        if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "AddNewPlaceVC") as? AddNewPlaceVC {
            
            // Optional: pass selected job title
            self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
        }
        
    }
}
extension HangOutVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading ==  true{
            return 8
        }else{
            return hangOutList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isLoading == true  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeltonCVC", for: indexPath) as? SkeltonCVC else {
                return UICollectionViewCell()
            }
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                return UICollectionViewCell()
            }
            
            // Configure your cell
            // cell.titleLabel.text = dataArr[indexPath.item]
            if hangOutList.count > 0{
                let hangOut = hangOutList[indexPath.item]
                cell.lbl_Title.text = hangOut.name
                cell.lblAmount.isHidden = true
                cell.lblRating.isHidden = true
                cell.lbl_review.isHidden = true
                cell.cosmosVw.isHidden = true
                if let firstIMage = hangOut.image.first{
                    let imageURLString = firstIMage.hasPrefix("http") ? firstIMage : "http://192.168.11.4:3001/assets/\(firstIMage)"
                    cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "restaurantImg"))
                }else{
                    cell.imgVw.image = UIImage(named: "restaurantImg")
               }
                cell.onItemTapped = { [weak self] val in
                    let id = self?.hangOutList[indexPath.item].id
                    self?.moveToDetail(id: id ?? "")
                    
                }
                return cell
            }else{
                return UICollectionViewCell()
            }
            
           
        }
        
        
    }
    private func moveToDetail(id : String){
        if id.isEmpty == false {
            let storyboard = UIStoryboard(name: "HangOut", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "HangOutDetailVC") as? HangOutDetailVC {
                accVC.hangoutID = id
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("❌ Could not instantiate AddNewAccomodationVC")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let id  = hangOutList[indexPath.item].id
            let storyboard = UIStoryboard(name: "HangOut", bundle: nil)
        if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "HangOutDetailVC") as? HangOutDetailVC {
            jobDescriptionVC.hangoutID = id
            // Optional: pass selected job title
            self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
        }
        
       
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
        if offsetY > contentHeight - frameHeight - 300 {
        #if Backapacker
            if !isComeFromPullTorefresh {
                if !isLoading && !isLoadingMoreData && !isAllDataLoaded {
                    isLoadingMoreData = true
                    page += 1
                    collectIOnVw.reloadSections(IndexSet(integer: 0))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.listOfAllBackPackerHangOuts()
                    }
                }
            }
        #endif
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 205) // Adjust height based on content
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
        return 5
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
    
  
}

extension HangOutVC{
    
    
#if Backapacker
    
    
    func listOfAllBackPackerHangOuts(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            collectIOnVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
        }
        let lat = LocationManager.shared.latitude
        let long = LocationManager.shared.longitude
        if lat ==  0.0 || long == 0.0{
            LoaderManager.shared.hide()
            if isComFromSearch == false{
                AlertManager.showAlert(
                    on: self,
                    title: "Location Missing",
                    message: "We couldn't fetch your current location. Please enable location services or try again later."
                )
            }
            return
        }else{
            viewModel.getBackPackerHangoutList(page: page, perPage: perPage, lat: lat ?? 0.0, long: long ?? 0.0,radius: self.radius,search: self.lastSearchedText){ [weak self] (success: Bool, result: BackPackerHangoutResponse?, statusCode: Int?) in
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
                                let newAccommodations = result?.data.hangoutList ?? []
                                
                                if self.page == 1 {
                                    if newAccommodations.isEmpty {
                                        if self.isComFromSearch == false{
                                            AlertManager.showAlert(
                                                on: self,
                                                title: "No Results",
                                                message: "No Hangout found near your current location. Try expanding your search radius or adjusting filters."
                                            )
                                        }
                                        self.lbl_NDataFound.isHidden = false
                                        self.hangOutList.removeAll()
                                        self.hangOutList = newAccommodations
                                        self.collectIOnVw.isHidden = true
                                    } else {
                                        self.hangOutList.removeAll()
                                        self.collectIOnVw.isHidden = false
                                        self.lbl_NDataFound.isHidden = true
                                        self.isLoading = false
                                        self.hangOutList = newAccommodations
                                    }
                                } else {
                                    self.isLoading = false
                                    self.hangOutList.append(contentsOf: newAccommodations)
                                }
                                self.totalAccomodations = result?.data.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = newAccommodations.count < self.perPage
                                
                             
                                self.isLoadingMoreData = false
                                self.collectIOnVw.reloadData()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.lastContentOffset = 0.0
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                self.refreshControl.endRefreshing()
                                self.collectIOnVw.setContentOffset(.zero, animated: true)
                                self.isLoadingMoreData = false
                                self.isComeFromPullTorefresh = false
                                self.lastContentOffset = 0.0
                                LoaderManager.shared.hide()
                            }
                            
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.listOfAllBackPackerHangOuts()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.refreshControl.endRefreshing()
                                    self.isLoading = false
                                    self.lastContentOffset = 0.0
                                    self.collectIOnVw.setContentOffset(.zero, animated: true)
                                    self.isComeFromPullTorefresh = false
                                    self.lastContentOffset = 0.0
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.lastContentOffset = 0.0
                            self.collectIOnVw.setContentOffset(.zero, animated: true)
                            self.isComeFromPullTorefresh = false
                            
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.lastContentOffset = 0.0
                            self.collectIOnVw.setContentOffset(.zero, animated: true)
                            self.isComeFromPullTorefresh = false
                           
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
        
    }
    
#endif
    
}
extension HangOutVC: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // Number of skeleton cells
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SkeltonCVC" // Your skeleton cell identifier
    }
}
extension HangOutVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the new text after the change
        
        let currentText = textField.text ?? ""
        
        // Prevent leading space
        if currentText.isEmpty && string == " " {
            return false
        }
        
        guard let stringRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let hasText = !updatedText.trimmingCharacters(in: .whitespaces).isEmpty
        btn_cleartxtFld.isHidden = !hasText
        
        // Cancel existing timer
        searchDebounceTimer?.invalidate()
        
        // Start a new timer (debounce delay)
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let trimmedSearch = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
#if Backapacker
            
            if self.lastSearchedText != trimmedSearch {
                self.lastSearchedText = trimmedSearch
                self.page = 1
                self.isComFromSearch = true
                self.listOfAllBackPackerHangOuts()
            }
            
            #endif
            
         
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.btn_cleartxtFld.isHidden = true
        textField.resignFirstResponder()
        return true
    }
}
