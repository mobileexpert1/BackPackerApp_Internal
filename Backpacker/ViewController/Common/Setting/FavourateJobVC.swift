//
//  FavourateJobVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit
import SkeletonView
class FavourateJobVC: UIViewController {
    @IBOutlet weak var CoLLectIonVwMain: UICollectionView!
    @IBOutlet weak var headerCollView: UICollectionView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    var selectedIndexHeader =  0
    @IBOutlet weak var lbl_No_AccomdodationFound: UILabel!
    var isComeFromAcceptDeclineJobs : Bool = false
    @IBOutlet weak var height_headerCollection: NSLayoutConstraint!
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    var lastContentOffset: CGFloat = 0
#if Backapacker
    var headerTirle = ["Accomodations","Hangout","Jobs"]
#else
    var headerTirle = ["Accomodations","Jobs"]
#endif
    var jobsTitle = ["Accepted","Declined"]
    let designations = [
        "Software Engineer",
        "UI/UX Designer",
        "Product Manager",
        "Data Analyst",
        "Mobile Developer",
        "QA Tester",
        "DevOps Engineer",
        "Project Coordinator",
        "Backend Developer",
        "Technical Lead"
    ]
    let hangoutPlaces = [
        "The Food Lounge",
        "Chillax Café",
        "Urban Bites",
        "The Rustic Table",
        "Midnight Munch",
        "Brew & Chew",
        "The Spice Route",
        "Fork & Fire",
        "Bean & Barrel",
        "NomNom Nook"
    ]
    let accommodations = [
        "Sunset View Hotel",
        "Royal Orchid Suites",
        "Palm Grove Resort",
        "Coastal Breeze Inn",
        "Skyline Grand Hotel",
        "Blue Lagoon Stay",
        "Urban Nest Suites",
        "Mountain Peak Lodge",
        "Serenity Bay Hotel",
        "Golden Hour Residency"
    ]
    
    
    var filteredDesignations: [String] = []
    let viewModel = AccommodationViewModel()
    let viewModelAuth = LogInVM()
    var isLoading : Bool = true
    var accommodationList = [Accommodation]()
    
    var page = 1
    let perPage = 6
    var totalAccomodations = Int()
    var isLoadingMoreData = false
    var isAllDataLoaded = false
    var isComeFromPullTorefresh : Bool = false
    
    var favJobList : [FavoriteJob]?
    var favAccommodationList : [FavAccommodation]?
    var favHangoutList : [FavHangout]?
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_No_AccomdodationFound.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_No_AccomdodationFound.isHidden = true
        self.lbl_MainHeader.text = "Favorite"
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        let snib2 = UINib(nibName: "SkeltonCVC", bundle: nil)
        self.CoLLectIonVwMain.register(snib2, forCellWithReuseIdentifier: "SkeltonCVC")
        CoLLectIonVwMain.isSkeletonable = true
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        CoLLectIonVwMain.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        CoLLectIonVwMain.register(UINib(nibName: "LoaderFooterViewCVC", bundle: nil),
                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                         withReuseIdentifier: "LoaderFooterViewCVC")
        self.filteredDesignations = designations
        let nib2 = UINib(nibName: "AccomodationCVC", bundle: nil)
        CoLLectIonVwMain.register(nib2, forCellWithReuseIdentifier: "AccomodationCVC")
        headerCollView.register(UINib(nibName: "MainJobCVC", bundle: nil), forCellWithReuseIdentifier: "MainJobCVC")
        self.headerCollView.delegate = self
        self.headerCollView.dataSource = self
        headerCollView.scrollToItem(at: IndexPath(item: selectedIndexHeader, section: 0), at: .centeredHorizontally, animated: false)
        
        self.CoLLectIonVwMain.delegate = self
        self.CoLLectIonVwMain.dataSource = self
        if let layout = CoLLectIonVwMain.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
#if BackpackerHire
        if isComeFromAcceptDeclineJobs != true  {
            if role == "3"{
                self.selectedIndexHeader = 0
              //  headerTirle = ["Accomodation"]
            }else if role == "4"{
                self.selectedIndexHeader = 0
            }else{
                self.selectedIndexHeader = 1
              //  headerTirle = ["Jobs"]
            }
        }
        if role == "3"{
            selectedIndexHeader = 0
            self.height_headerCollection.constant = 0
            self.headerCollView.isHidden = true
            self.lbl_MainHeader.text = "Favorite Accomodations"
            self.getListOfFavourateAccommodation()
        } else if role == "4"{
            selectedIndexHeader = 0
            self.height_headerCollection.constant = 0
            self.headerCollView.isHidden = true
            self.lbl_MainHeader.text = "Favorite HangOut"
            self.getListOfFavourateHangOut()
        }else if role == "2"{
            selectedIndexHeader = 1
            self.height_headerCollection.constant = 0
            self.headerCollView.isHidden = true
            self.lbl_MainHeader.text = "Favorite Jobs"
            self.getListOfFavourateJobs()
        }
        /*
         private func callApis(){
             if selectedIndexHeader == 0{
                 self.lbl_No_AccomdodationFound.text = "No Accomodation Found"
                 self.getListOfFavourateAccommodation()
                
             }else if selectedIndexHeader == 1 {
                 self.lbl_No_AccomdodationFound.text = "No Hangout Found"
                 self.getListOfFavourateHangOut()
                 
             }else{
                 self.lbl_No_AccomdodationFound.text = "No Job Found"
                 self.getListOfFavourateJobs()
                
             }
         }
         */
        #else
      
        self.callApis()
        self.setupPullToRefresh()
#endif
        
    }
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.tintColor = .gray // Default loader color (you can set .systemBlue etc.)
        refreshControl.addTarget(self, action: #selector(refreshCollectionData), for: .valueChanged)
        self.CoLLectIonVwMain.refreshControl = refreshControl
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
                 self.callApis()
                
                #else
#endif
       
        }
        
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func callApis(){
        if selectedIndexHeader == 0{
            self.lbl_No_AccomdodationFound.text = "No Accomodation Found"
            self.page = 1
            self.isAllDataLoaded = false
            self.isLoadingMoreData = false
            self.isLoading = true
            
            // Start refreshing UI
            
            isComeFromPullTorefresh = false
            self.getListOfFavourateAccommodation()
           
        }else if selectedIndexHeader == 1 {
            self.lbl_No_AccomdodationFound.text = "No Hangout Found"
            self.page = 1
            self.isAllDataLoaded = false
            self.isLoadingMoreData = false
            self.isLoading = true
            
            // Start refreshing UI
            
            isComeFromPullTorefresh = false
            self.getListOfFavourateHangOut()
            
        }else{
            self.lbl_No_AccomdodationFound.text = "No Job Found"
            self.page = 1
            self.isAllDataLoaded = false
            self.isLoadingMoreData = false
            self.isLoading = true
            
            // Start refreshing UI
            
            isComeFromPullTorefresh = false
            self.getListOfFavourateJobs()
           
        }
    }
    
}
extension FavourateJobVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollView{
            if isComeFromAcceptDeclineJobs {
                return jobsTitle.count
            }else{
                return headerTirle.count
            }
        }else{
#if BackpackerHire
            
            if selectedIndexHeader == 0 {
                if isComeFromAcceptDeclineJobs {
                    return filteredDesignations.count
                }else{
                    return filteredDesignations.count
                }
            }else{
                return filteredDesignations.count
            }
            
#else
            
            if isLoading ==  true{
                return 8
            }else{
                if selectedIndexHeader == 0 {
                    return self.favAccommodationList?.count ?? 0
                }else if selectedIndexHeader == 1 {
                    return self.favHangoutList?.count ?? 0
                }else{
                    return self.favJobList?.count ?? 0
                }
            }
            
          
#endif
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainJobCVC", for: indexPath) as? MainJobCVC else {
                return UICollectionViewCell()
            }
            if isComeFromAcceptDeclineJobs {
                cell.title_header.text = jobsTitle[indexPath.item]
            }else{
                cell.title_header.text = headerTirle[indexPath.item]
            }
            cell.showBottomView(indexPath.item == selectedIndexHeader)
            return cell
        }else{
            
#if BackpackerHire
            if isComeFromAcceptDeclineJobs{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                    return UICollectionViewCell()
                }
                if selectedIndexHeader == 0{
                    cell.lbl_jobStatus.text = "Accepted"
                    cell.statusVw.backgroundColor = UIColor(hex: "#00A925")
                    cell.setUpUI(iscomeFromAccept: isComeFromAcceptDeclineJobs)
                }
                else{
                    
                    cell.lbl_jobStatus.text = "Declined"
                    cell.statusVw.backgroundColor = UIColor(hex: "#F80505")
                    cell.setUpUI(iscomeFromAccept: isComeFromAcceptDeclineJobs)
                }
                return cell
            }else{
                if selectedIndexHeader == 0{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }
                    if role == "3"{
                        cell.lbl_Title.text = accommodations[indexPath.row]
                        cell.imgVw.image = UIImage(named: "aCCOMODATION")
                        cell.lblAmount.isHidden = false
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.cosmosVw.isHidden = true
                    }else if role == "4"{
                        cell.lbl_Title.text = accommodations[indexPath.row]
                        cell.imgVw.image = UIImage(named: "restaurantImg")
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.lblAmount.isHidden = true
                        cell.cosmosVw.isHidden = true
                    }else{
                        cell.lbl_Title.text = accommodations[indexPath.row]
                        cell.imgVw.image = UIImage(named: "aCCOMODATION")
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.lblAmount.isHidden = true
                    }
                   
                    return cell
                }
                else{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                        return UICollectionViewCell()
                    }
                    
                    cell.lbl_Title.text = filteredDesignations[indexPath.row]
                    cell.setUpUI(iscomeFromAccept: isComeFromAcceptDeclineJobs)
                    return cell
                }
            }
            
          
#else
            if isLoading == true  {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeltonCVC", for: indexPath) as? SkeltonCVC else {
                    return UICollectionViewCell()
                }
                return cell
            }else{
                if selectedIndexHeader == 0{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }
                    if let accommodation = favAccommodationList?[indexPath.item] {
                        cell.lbl_Title.text = accommodation.name
                        cell.lblAmount.isHidden = true
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.cosmosVw.isHidden = true
                        cell.item = indexPath.item
                        if let firstIMage = accommodation.image.first{
                            let baseURL1 = ApiConstants.API.API_IMAGEURL
                            let baseURL2 = ApiConstants.API.API_IMAGEURL
                            
                            let imageURLString = firstIMage.hasPrefix("http") ? firstIMage : baseURL1 + firstIMage
                            
                            cell.imgVw.sd_setImage(
                                with: URL(string: imageURLString),
                                placeholderImage: UIImage(named: "img_Placehodler")
                            ) { image, _, _, _ in
                                if image == nil {
                                    let fallbackURL = firstIMage.hasPrefix("http") ? firstIMage : baseURL2 + firstIMage
                                    cell.imgVw.sd_setImage(
                                        with: URL(string: fallbackURL),
                                        placeholderImage: UIImage(named: "img_Placehodler")
                                    )
                                }
                            }
                            
                        }else{
                            cell.imgVw.image = UIImage(named: "img_Placehodler")
                        }
                        cell.onItemTapped = { [weak self]  index in
    //                        self?.onAddAccommodation?(indexPath.item)
                            let id = self?.favAccommodationList?[indexPath.item].id
                            self?.moveToDetail(id: id ?? "")
                        }
    //                    cell.onHeartTapped = { [weak self]  index in
    //                        self?.onFavTap?(indexPath.item)
    //                    }
                        if accommodation.favoriteStatus == 1 {
                            cell.imgHeart.image = UIImage(named: "red_heart")
                        }else{
                            cell.imgHeart.image = UIImage(named: "Heart")
                        }
                        
                    }
                    return cell
                }else if selectedIndexHeader == 1 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }
                    cell.lbl_Title.text =   hangoutPlaces[indexPath.row]
                    cell.imgVw.image = UIImage(named: "restaurantImg")
                    cell.lblAmount.isHidden = true
                    if   let hangOut = favHangoutList?[indexPath.item]{
                        cell.lbl_Title.text = hangOut.name
                        cell.lblAmount.isHidden = true
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.cosmosVw.isHidden = true
                        if let firstIMage = hangOut.image.first{
                            if firstIMage.hasPrefix("http") {
                                cell.imgVw.sd_setImage(
                                    with: URL(string: firstIMage),
                                    placeholderImage: UIImage(named: "restaurantImg")
                                )
                            } else {
                                let url3000 = URL(string: "\(ApiConstants.API.API_IMAGEURL)\(firstIMage)")
                                let url3001 = URL(string: "\(ApiConstants.API.API_IMAGEURL)\(firstIMage)")
                                
                                cell.imgVw.sd_setImage(with: url3000, placeholderImage: UIImage(named: "img_Placehodler")) { image, _, _, _ in
                                    if image == nil {
                                        cell.imgVw.sd_setImage(with: url3001, placeholderImage: UIImage(named: "img_Placehodler"))
                                    }
                                }
                            }
                            
                        }else{
                            cell.imgVw.image = UIImage(named: "img_Placehodler")
                        }
                        cell.onItemTapped = { [weak self] val in
                            let id = self?.favHangoutList?[indexPath.item].id
                            self?.moveToHangoutDetail(id: id ?? "")
                            
                        }
    //                    cell.onHeartTapped = { [weak self] val in
    //                        if let id = self?.hangOutList[indexPath.item].id {
    //                            self?.MakeJobHangOutFav(id: id)
    //                        }
    //
    //                    }
                        if hangOut.favoriteStatus == 1 {
                            cell.imgHeart.image = UIImage(named: "red_heart")
                        }else{
                            cell.imgHeart.image = UIImage(named: "Heart")
                        }
                        
                    }
                    
                    return cell
                }
                else{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                        return UICollectionViewCell()
                    }
                    if let declineJob = favJobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                           // self.onTap?(indexPath.item)
                            self.NavigateToJobDetailVC(indexPath: indexPath.row)
                        }
                        cell.onFavTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell Fav tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            //self.onFavTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = favJobList?[indexPath.item].name ?? "No Data"
                        if let amnt = favJobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"//per day
                        }
                        cell.lbl_SubTitle.text = favJobList?[indexPath.item].description ?? "No Data"
                       
                        if ((declineJob.image.hasPrefix("http")) != nil) {
                            cell.imgVw.sd_setImage(
                                with: URL(string: declineJob.image ?? ""),
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
                           
                           
                        }
                        if favJobList?[indexPath.item].favoriteStatus == 1 {
                            cell.btn_fav.setImage(UIImage(named: "red_heart"), for: .normal)
                        }else{
                            cell.btn_fav.setImage(UIImage(named: "Heart"), for: .normal)
                        }
                       // cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)  (Not include)
                        cell.setUpUI(iscomeFromAccept: false)
                        let strtTime = favJobList?[indexPath.item].startTime
                        let endTime = favJobList?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
                    }
                  //  cell.setUpUI(iscomeFromAccept: false)
                    return cell
                }
                
                
            }
           
#endif
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollView{
                let previousIndex = selectedIndexHeader
            if previousIndex == 0 {
                self.favAccommodationList?.removeAll()
            }else if previousIndex == 1 {
                self.favHangoutList?.removeAll()
            }else{
                self.favJobList?.removeAll()
            }
                selectedIndexHeader = indexPath.item
                
                let indexesToReload = [
                    IndexPath(item: previousIndex, section: 0),
                    IndexPath(item: selectedIndexHeader, section: 0)
                ]
                collectionView.reloadItems(at: indexesToReload)
                
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                //self.CoLLectIonVwMain.reloadData()
                self.callApis()
            }
            }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == headerCollView{
            let title = headerTirle[indexPath.item]
            let font = FontManager.inter(.medium, size: 12.0) // Adjust if you use custom font
            let padding: CGFloat = 12 // Add padding for horizontal margins
            
            let textWidth = title.size(withAttributes: [.font: font]).width
            if isComeFromAcceptDeclineJobs {
                return CGSize(width: textWidth + padding + 20, height: 50) // Adjust height as per design
            }else{
                return CGSize(width: textWidth + padding + 13, height: 50) // Adjust height as per design
            }
            
        }else{
#if BackpackerHire
            if isComeFromAcceptDeclineJobs{
               
                    return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 200) // Adjust height based on content
               
            }else{
                if selectedIndexHeader == 0{
                    if role == "4"{
                        return CGSize(width: (collectionView.bounds.width/2) - 3 , height: 205) // Adjust height based on content
                    }else  if role == "3"{
                        return CGSize(width: (collectionView.bounds.width/2) - 3 , height: 235) // Adjust height based on content
                    }else{
                        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 240) // Adjust height based on content
                    }
                   
                }
                else{
                    return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 180) // Adjust height based on content
                }
            }
            
            
#else
            if selectedIndexHeader == 0 {
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 205) // Adjust height based on content
            }else if  selectedIndexHeader == 1  {
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 210) // Adjust height based on content
            }
            else{
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 180) // Adjust height based on content
            }
#endif
          
            
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
        if collectionView == CoLLectIonVwMain{
            if role == "4"{
                return 2
            }else if role == "3"{
                return 2
            }else{
                return 10
            }
            
        }else{
            return 0
        }
        
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
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
     
            if !isComeFromPullTorefresh {
                if !isLoading && !isLoadingMoreData && !isAllDataLoaded {
                    isLoadingMoreData = true
                    page += 1
                    CoLLectIonVwMain.reloadSections(IndexSet(integer: 0))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
#if Backapacker
                        self.callApis()
                
                #else
#endif
                    }
                }
            }
        }
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
    private func moveToDetail(id : String){
        if id.isEmpty == false {
            let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "AccomodationDetailVC") as? AccomodationDetailVC {
                accVC.accomodationID = id
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("- Could not instantiate AddNewAccomodationVC")
            }
        }
    }
    private func moveToHangoutDetail(id : String){
        if id.isEmpty == false {
            let storyboard = UIStoryboard(name: "HangOut", bundle: nil)
            if let accVC = storyboard.instantiateViewController(withIdentifier: "HangOutDetailVC") as? HangOutDetailVC {
                accVC.hangoutID = id
                self.navigationController?.pushViewController(accVC, animated: true)
            } else {
                print("- Could not instantiate AddNewAccomodationVC")
            }
        }
    }
    func NavigateToJobDetailVC(indexPath:Int){
            let storyboard = UIStoryboard(name: "Job", bundle: nil)
               if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
                   jobDescriptionVC.JobId = self.favJobList?[indexPath].id
                  
                   
                   // Optional: pass selected job title
                   self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
               }
    }
}


extension FavourateJobVC {
    
    private func getListOfFavourateAccommodation(){
            if page == 1 {
                self.isLoading = true
                LoaderManager.shared.show()
            } else {
                isLoadingMoreData = true
                CoLLectIonVwMain.reloadSections(IndexSet(integer: 0)) // Show footer loader
            }
            let lat = LocationManager.shared.latitude
            let long = LocationManager.shared.longitude
            if lat ==  0.0 || long == 0.0{
                LoaderManager.shared.hide()
                return
            }else{
                viewModel.getFavAccommodationList(page: page, perPage: perPage,search: ""){ [weak self] (success: Bool, result: FavAccommodationResponse?, statusCode: Int?) in
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
                                    let newAccommodations = result?.data.accommodations ?? []
                                    if self.page == 1 {
                                        if newAccommodations.isEmpty {
                                            self.lbl_No_AccomdodationFound.isHidden = false
                                            self.accommodationList.removeAll()
                                            self.favAccommodationList = newAccommodations
                                            self.CoLLectIonVwMain.isHidden = true
                                        } else {
                                            self.isLoading = false
                                            self.CoLLectIonVwMain.isHidden = false
                                            self.lbl_No_AccomdodationFound.isHidden = true
                                            self.favAccommodationList = newAccommodations
                                        }
                                    } else {
                                        self.isLoading = false
                                        self.favAccommodationList?.append(contentsOf: newAccommodations)
                                    }
                                    self.totalAccomodations = result?.data.total ?? 0
                                    // Pagination end check
                                    self.isAllDataLoaded = newAccommodations.count < self.perPage
                                    
                                  
                                    self.isComeFromPullTorefresh = false
                                    self.isLoadingMoreData = false
                                    self.CoLLectIonVwMain.reloadData()
                                    self.refreshControl.endRefreshing()
                                } else {
                                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                    self.refreshControl.endRefreshing()
                                    self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
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
                                        self.getListOfFavourateAccommodation()
                                    } else {
                                        LoaderManager.shared.hide()
                                        self.refreshControl.endRefreshing()
                                        self.isLoading = false
                                        self.isComeFromPullTorefresh = false
                                        self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
                                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                    }
                                }
                                
                            case .unauthorizedToken:
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                            case .unknown:
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
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
    
    private func getListOfFavourateHangOut(){
            if page == 1 {
                self.isLoading = true
                LoaderManager.shared.show()
            } else {
                isLoadingMoreData = true
                CoLLectIonVwMain.reloadSections(IndexSet(integer: 0)) // Show footer loader
            }
            let lat = LocationManager.shared.latitude
            let long = LocationManager.shared.longitude
            if lat ==  0.0 || long == 0.0{
                LoaderManager.shared.hide()
                return
            }else{
                viewModel.getFavHangoutList(page: page, perPage: perPage,search: ""){ [weak self] (success: Bool, result: FavHangoutResponse?, statusCode: Int?) in
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
                                    let newAccommodations = result?.data?.hangoutList ?? []
                                    
                                    if self.page == 1 {
                                        if newAccommodations.isEmpty {
                                            self.lbl_No_AccomdodationFound.isHidden = false
                                            self.accommodationList.removeAll()
                                            self.favHangoutList = newAccommodations
                                            self.CoLLectIonVwMain.isHidden = true
                                        } else {
                                            self.isLoading = false
                                            self.CoLLectIonVwMain.isHidden = false
                                            self.lbl_No_AccomdodationFound.isHidden = true
                                            self.favHangoutList = newAccommodations
                                        }
                                    } else {
                                        self.isLoading = false
                                        self.favHangoutList?.append(contentsOf: newAccommodations)
                                    }
                                    self.totalAccomodations = result?.data?.total ?? 0
                                    // Pagination end check
                                    self.isAllDataLoaded = newAccommodations.count < self.perPage
                                    
                                  
                                    self.isComeFromPullTorefresh = false
                                    self.isLoadingMoreData = false
                                    self.CoLLectIonVwMain.reloadData()
                                    self.refreshControl.endRefreshing()
                                } else {
                                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                    self.refreshControl.endRefreshing()
                                    self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
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
                                        self.getListOfFavourateHangOut()
                                    } else {
                                        LoaderManager.shared.hide()
                                        self.refreshControl.endRefreshing()
                                        self.isLoading = false
                                        self.isComeFromPullTorefresh = false
                                        self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
                                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                    }
                                }
                                
                            case .unauthorizedToken:
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                            case .unknown:
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
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
    private func getListOfFavourateJobs(){
            if page == 1 {
                self.isLoading = true
                LoaderManager.shared.show()
            } else {
                isLoadingMoreData = true
                CoLLectIonVwMain.reloadSections(IndexSet(integer: 0)) // Show footer loader
            }
            let lat = LocationManager.shared.latitude
            let long = LocationManager.shared.longitude
            if lat ==  0.0 || long == 0.0{
                LoaderManager.shared.hide()
                return
            }else{
                viewModel.getFavJObsList(page: page, perPage: perPage,search: ""){ [weak self] (success: Bool, result: FavoriteJobResponse?, statusCode: Int?) in
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
                                    let newAccommodations = result?.data?.jobs ?? []
                                    
                                    if self.page == 1 {
                                        if newAccommodations.isEmpty {
                                            self.lbl_No_AccomdodationFound.isHidden = false
                                            self.favJobList?.removeAll()
                                            self.favJobList = newAccommodations
                                            self.CoLLectIonVwMain.isHidden = true
                                        } else {
                                            self.isLoading = false
                                            self.CoLLectIonVwMain.isHidden = false
                                            self.lbl_No_AccomdodationFound.isHidden = true
                                            self.favJobList = newAccommodations
                                        }
                                    } else {
                                        self.isLoading = false
                                        self.favJobList?.append(contentsOf: newAccommodations)
                                    }
                                    self.totalAccomodations = result?.data?.total ?? 0
                                    // Pagination end check
                                    self.isAllDataLoaded = newAccommodations.count < self.perPage
                                    
                                  
                                    self.isComeFromPullTorefresh = false
                                    self.isLoadingMoreData = false
                                    self.CoLLectIonVwMain.reloadData()
                                    self.refreshControl.endRefreshing()
                                } else {
                                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                    self.refreshControl.endRefreshing()
                                    self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
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
                                        self.getListOfFavourateAccommodation()
                                    } else {
                                        LoaderManager.shared.hide()
                                        self.refreshControl.endRefreshing()
                                        self.isLoading = false
                                        self.isComeFromPullTorefresh = false
                                        self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
                                        NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                    }
                                }
                                
                            case .unauthorizedToken:
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
                                NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                            case .unknown:
                                LoaderManager.shared.hide()
                                self.refreshControl.endRefreshing()
                                self.isComeFromPullTorefresh = false
                                self.CoLLectIonVwMain.setContentOffset(.zero, animated: true)
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
}
    extension FavourateJobVC: SkeletonCollectionViewDataSource {
        
        func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10 // Number of skeleton cells
        }
        
        func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
            return "SkeltonCVC" // Your skeleton cell identifier
        }
    }
