//
//  EmployerAccomodationVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit
import SkeletonView
class EmployerAccomodationVC: UIViewController {
    
    @IBOutlet weak var lbl_No_AccomdodationFound: UILabel!
    @IBOutlet weak var coollVw: UICollectionView!
    @IBOutlet weak var txtFld_Search: UITextField!
    @IBOutlet weak var searchBgVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var filterImgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btn_AddAccomodation: UIButton!
    var accommodationID : String?
    var lastContentOffset: CGFloat = 0
    let hotels = [
        "Little National Hotel Sydney",
        "Dorsett Melbourne",
        "The Langham Sydney",
        "Crown Towers Melbourne",
        "QT Melbourne",
        "Park Hyatt Sydney",
        "Shangri-La Hotel Sydney",
        "The Westin Melbourne",
        "Sofitel Sydney Darling Harbour",
        "Four Seasons Hotel Sydney"
    ]
    @IBOutlet weak var btn_cleartxtFld: UIButton!
    
    var filteredDesignations: [String] = []
    let viewModel = AccommodationViewModel()
    let viewModelAuth = LogInVM()
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    var accommodationList = [Accommodation]()
    
    var page = 1
    let perPage = 2
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_cleartxtFld.isHidden = true
        self.lbl_No_AccomdodationFound.font = FontManager.inter(.medium, size: 14.0)
        self.setupPullToRefresh()
#if BackpackerHire
        self.btn_AddAccomodation.isHidden = false
        self.btn_AddAccomodation.isUserInteractionEnabled = true
#else
        self.btn_AddAccomodation.isHidden = true
        self.btn_AddAccomodation.isUserInteractionEnabled = false
#endif
        self.btn_AddAccomodation.titleLabel?.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.searchBgVw.layer.borderColor = UIColor.black.cgColor
        self.searchBgVw.layer.borderWidth = 1.0
        
        txtFld_Search.attributedPlaceholder = NSAttributedString(
            string: "Search Accommodation",
            attributes: [
                .foregroundColor: UIColor.black,
                .font:FontManager.inter(.regular, size: 14.0)
            ]
        )
        txtFld_Search.delegate = self
        filteredDesignations = hotels  // Initialize with full data
        txtFld_Search.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        self.registercells()
        
        self.lbl_No_AccomdodationFound.isHidden = true

#if BackpackerHire
        
        self.listOfAllAccommodationEmployer()
#else
        self.listOfAllAccommodation()
#endif
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isComeFromPullTorefresh = false
    }
    
    
    func registercells(){
        let nib2 = UINib(nibName: "SkeltonCVC", bundle: nil)
        self.coollVw.register(nib2, forCellWithReuseIdentifier: "SkeltonCVC")
        coollVw.isSkeletonable = true
        
        
        let nib = UINib(nibName: "AccomodationCVC", bundle: nil)
        coollVw.register(nib, forCellWithReuseIdentifier: "AccomodationCVC")
        coollVw.register(UINib(nibName: "LoaderFooterViewCVC", bundle: nil),
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                         withReuseIdentifier: "LoaderFooterViewCVC")
        let nib3 = UINib(nibName: "AccomodationCVC", bundle: nil)
        coollVw.register(nib3, forCellWithReuseIdentifier: "AccomodationCVC")
        self.coollVw.delegate = self
        self.coollVw.dataSource = self
        if let layout = coollVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshCollectionData), for: .valueChanged)
        self.coollVw.refreshControl = refreshControl
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
#if BackpackerHire
            self.listOfAllAccommodationEmployer()
#else
            self.listOfAllAccommodation()
            
#endif
        }

        
    }
    
    @objc func searchTextChanged() {
        let text = txtFld_Search.text ?? ""
        if text.isEmpty {
            filteredDesignations = hotels
        } else {
            filteredDesignations = hotels.filter { $0.lowercased().contains(text.lowercased()) }
        }
        coollVw.reloadData()
    }
    
    @IBAction func action_AdddNewAccomodation(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let accVC = storyboard.instantiateViewController(withIdentifier: "AddNewAccomodationVC") as? AddNewAccomodationVC {
            self.navigationController?.pushViewController(accVC, animated: true)
        } else {
            print("❌ Could not instantiate AddNewAccomodationVC")
        }
    }
    @IBAction func action_Sort(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.isComeFromHangOut = false
        vc.initialFacilities = self.facilities  // e.g. "Free Wifi, Swimming Pool"
        vc.initialSortBy = self.sortByPrice     // e.g. "asc" or "desc"
        vc.initialRadius = self.radius != nil ? String(self.radius!) : nil
        vc.onApplyFilters = { [weak self] facilities, sortBy, radius in

            
            print("Facilities: \(facilities ?? "-")")
            print("Sort by: \(sortBy ?? "-")")
            print("Radius: \(radius ?? "-")")
            self?.sortByPrice = sortBy ?? "asc"
            self?.facilities = facilities
            self?.radius = Int(radius ?? "")
            // You can now use the data to filter your content
            self?.page = 1
#if Backapacker
            self?.listOfAllAccommodation()
            #else
            
            self?.listOfAllAccommodationEmployer()
#endif
            
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }
    @IBAction func action_ClearTxtFld(_ sender: Any) {

            
        self.isComFromSearch = false
        txtFld_Search.text = ""
        lastSearchedText = ""
        page = 1
        txtFld_Search.resignFirstResponder()
        self.btn_cleartxtFld.isHidden = true
#if Backapacker
        listOfAllAccommodation()
#else
        listOfAllAccommodationEmployer()
#endif
     
    }
}
extension EmployerAccomodationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading ==  true{
            return 8
        }else{
            return accommodationList.count
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
            let accomodation = accommodationList[indexPath.item]
            cell.lbl_Title.text = accomodation.name
            cell.lblAmount.isHidden = false
            cell.lblAmount.text = "$\(accomodation.price)"
            cell.lbl_review.isHidden = true
            cell.cosmosVw.isHidden = true
            
            if let firstIMage = accomodation.image.first{
                if firstIMage.hasPrefix("http") {
                    cell.imgVw.sd_setImage(
                        with: URL(string: firstIMage),
                        placeholderImage: UIImage(named: "aCCOMODATION")
                    )
                } else {
                    let url3000 = URL(string: "http://192.168.11.4:3000/assets/\(firstIMage)")
                    let url3001 = URL(string: "http://192.168.11.4:3001/assets/\(firstIMage)")

                    cell.imgVw.sd_setImage(with: url3000, placeholderImage: UIImage(named: "aCCOMODATION")) { image, _, _, _ in
                        if image == nil {
                            cell.imgVw.sd_setImage(with: url3001, placeholderImage: UIImage(named: "aCCOMODATION"))
                        }
                    }
                }

            }else{
                cell.imgVw.image = UIImage(named: "aCCOMODATION")
            }
            cell.onItemTapped = { [weak self] val in
                let id = self?.accommodationList[indexPath.item].id
                self?.moveToDetail(id: id ?? "")
                
            }
            return cell
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
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    
     
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 225) // Adjust height based on content
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = accommodationList[indexPath.item].id
        if id.isEmpty == false {
            let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "AccomodationDetailVC") as? AccomodationDetailVC {
                accVC.accomodationID = id
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("❌ Could not instantiate AddNewAccomodationVC")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoadingMoreData ? CGSize(width: collectionView.frame.width, height: 100) : .zero
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
                    coollVw.reloadSections(IndexSet(integer: 0))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ){
#if Backapacker
                        self.listOfAllAccommodation()
                        #else
                        
                        self.listOfAllAccommodationEmployer()
                        
#endif
                    }
                    
                }
            }
            
          
           
            
        }
    }
    
    private func moveToDetail(id : String){
        if id.isEmpty == false {
            let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "AccomodationDetailVC") as? AccomodationDetailVC {
                accVC.accomodationID = id
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("❌ Could not instantiate AddNewAccomodationVC")
            }
        }
    }
}
extension EmployerAccomodationVC : UITextFieldDelegate{
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

            
            if self.lastSearchedText != trimmedSearch {
                self.lastSearchedText = trimmedSearch
                self.page = 1
                self.isComFromSearch = true
#if Backapacker
                self.listOfAllAccommodation()
                
#else
                self.listOfAllAccommodationEmployer()
#endif
            }
            
           
            
         
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.btn_cleartxtFld.isHidden = true
        textField.resignFirstResponder()
        return true
    }
}


extension EmployerAccomodationVC {
    
    func listOfAllAccommodationEmployer(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            coollVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
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
            viewModel.getEMPLOYERAccommodationList(page: page, perPage: perPage, lat: lat ?? 0.0, long: long ?? 0.0,radius: self.radius, sortByPrice:self.sortByPrice, facilities: facilities,search: self.lastSearchedText){ [weak self] (success: Bool, result: AccommodationResponseModel?, statusCode: Int?) in
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
                                let newAccommodations = result?.data.accommodationList ?? []
                                
                                if self.page == 1 {
                                    if newAccommodations.isEmpty {
                                        if self.isComFromSearch == false{
                                            AlertManager.showAlert(
                                                on: self,
                                                title: "No Results",
                                                message: "No accommodations found."
                                            )
                                        }
                                        self.lbl_No_AccomdodationFound.isHidden = false
                                        self.accommodationList.removeAll()
                                        self.accommodationList = newAccommodations
                                        self.coollVw.isHidden = true
                                    } else {
                                        self.isLoading = false
                                        self.coollVw.isHidden = false
                                        self.lbl_No_AccomdodationFound.isHidden = true
                                        self.accommodationList = newAccommodations
                                    }
                                } else {
                                    self.isLoading = false
                                    self.accommodationList.append(contentsOf: newAccommodations)
                                }
                                self.totalAccomodations = result?.data.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = newAccommodations.count < self.perPage
                                
                              
                                self.isComeFromPullTorefresh = false
                                self.isLoadingMoreData = false
                                self.coollVw.reloadData()
                                self.refreshControl.endRefreshing()
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                self.refreshControl.endRefreshing()
                                self.coollVw.setContentOffset(.zero, animated: true)
                                self.isLoading = false
                                self.isLoadingMoreData = false
                                self.isComeFromPullTorefresh = false
                                LoaderManager.shared.hide()
                            }
                            
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.listOfAllAccommodationEmployer()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.refreshControl.endRefreshing()
                                    self.isLoading = false
                                    self.isComeFromPullTorefresh = false
                                    self.coollVw.setContentOffset(.zero, animated: true)
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.coollVw.setContentOffset(.zero, animated: true)
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.coollVw.setContentOffset(.zero, animated: true)
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
    
    
   
    
    
    func listOfAllAccommodation(){
        if page == 1 {
            self.isLoading = true
            LoaderManager.shared.show()
        } else {
            isLoadingMoreData = true
            coollVw.reloadSections(IndexSet(integer: 0)) // Show footer loader
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
            viewModel.getAccommodationList(page: page, perPage: perPage, lat: lat ?? 0.0, long: long ?? 0.0,radius: self.radius, sortByPrice:self.sortByPrice, facilities: facilities,search: self.lastSearchedText){ [weak self] (success: Bool, result: AccommodationResponseModel?, statusCode: Int?) in
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
                                let newAccommodations = result?.data.accommodationList ?? []
                                
                                if self.page == 1 {
                                    if newAccommodations.isEmpty {
                                        if self.isComFromSearch == false{
                                            AlertManager.showAlert(
                                                on: self,
                                                title: "No Results",
                                                message: "No accommodations found near your current location. Try expanding your search radius or adjusting filters."
                                            )
                                        }
                                        self.lbl_No_AccomdodationFound.isHidden = false
                                        self.accommodationList.removeAll()
                                        self.accommodationList = newAccommodations
                                        self.coollVw.isHidden = true
                                    } else {
                                        self.isLoading = false
                                        self.coollVw.isHidden = false
                                        self.lbl_No_AccomdodationFound.isHidden = true
                                        self.accommodationList = newAccommodations
                                    }
                                } else {
                                    self.isLoading = false
                                    self.accommodationList.append(contentsOf: newAccommodations)
                                }
                                self.totalAccomodations = result?.data.total ?? 0
                                // Pagination end check
                                self.isAllDataLoaded = newAccommodations.count < self.perPage
                                
                              
                                self.isComeFromPullTorefresh = false
                                self.isLoadingMoreData = false
                                self.coollVw.reloadData()
                                self.refreshControl.endRefreshing()
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                self.refreshControl.endRefreshing()
                                self.coollVw.setContentOffset(.zero, animated: true)
                                self.isLoading = false
                                self.isLoadingMoreData = false
                                self.isComeFromPullTorefresh = false
                                LoaderManager.shared.hide()
                            }
                            
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                        case .unauthorized :
                            self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.listOfAllAccommodation()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.refreshControl.endRefreshing()
                                    self.isLoading = false
                                    self.isComeFromPullTorefresh = false
                                    self.coollVw.setContentOffset(.zero, animated: true)
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.coollVw.setContentOffset(.zero, animated: true)
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            self.isComeFromPullTorefresh = false
                            self.coollVw.setContentOffset(.zero, animated: true)
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
}



extension EmployerAccomodationVC: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // Number of skeleton cells
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SkeltonCVC" // Your skeleton cell identifier
    }
}


