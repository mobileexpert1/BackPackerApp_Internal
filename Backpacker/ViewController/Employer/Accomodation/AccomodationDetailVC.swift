//
//  AccomodationDetailVC.swift
//  BackpackerHire
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import Cosmos
import MapKit
import SKPhotoBrowser

class AccomodationDetailVC: UIViewController {
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var facilityCollectionVw: UICollectionView!
    
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_Availbility: UIButton!
    
    @IBOutlet weak var main_bgVw_ImgCollection: UIView!
    @IBOutlet weak var btn_VwOnMap: UIButton!
    @IBOutlet weak var lbl_Review: UILabel!
    @IBOutlet weak var lbl_HotelName: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var lbl_ReviewCount: UILabel!
    
    @IBOutlet weak var lbl_Addrees: UILabel!
    @IBOutlet weak var lbl_TitleAbout: UILabel!
    @IBOutlet weak var ratingVw: CosmosView!
    
    @IBOutlet weak var lbl_AboutDescription: UILabel!
    
    @IBOutlet weak var lbl_FaclityTitle: UILabel!
    
    @IBOutlet weak var lbl_LocationTitle: UILabel!
    
    @IBOutlet weak var facility_coll_height: NSLayoutConstraint!
    
    @IBOutlet weak var img_Collection_Vw: UICollectionView!
    
    @IBOutlet weak var lbl_ValPrice: UILabel!
    @IBOutlet weak var lbl_header_Price: UILabel!
    @IBOutlet weak var page_Controller: UIPageControl!
    let facilities: [Facility] = [
        Facility(image: "pool", title: "Swimming Pool"),
        Facility(image: "wifi", title: "WiFi"),
        Facility(image: "restaurant", title: "Restaurant"),
        Facility(image: "parking", title: "Parking"),
        Facility(image: "meeting", title: "Meeting Room"),
        Facility(image: "elevator", title: "Elevator"),
        Facility(image: "open", title: "24-hours Open"),
        Facility(image: "fitness", title: "Fitness Center")
    ]
    var facilitiesArray: [Facility]?
    
    let viewMOdel = AccommodationViewModel()
    let viewModelAuth = LogInVM()
    var isLoading: Bool = true // true while loading, false once data is ready
    var accomodationDetailObj : AccommodationDetailData?
    @IBOutlet weak var mainScrollVw: UIScrollView!
    var accomodationID : String?
    let refreshControl = UIRefreshControl()
    var localImages: [UIImage] = []   // your UIImage array
    var remoteImages: [String] = []   // your URL array

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.setUpUI()
        self.setupPullToRefresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if BackpackerHire
        self.btn_edit.isHidden = false
        self.getDetailOfAccomodationEmployer()
        #else
        self.btn_edit.isHidden = true
        self.btn_delete.isHidden = true
        self.getDetailOfAccomodation()
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
        self.refreshControl.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
#if BackpackerHire
        
        self.getDetailOfAccomodationEmployer()
        #else
        
        self.getDetailOfAccomodation()
#endif
        }
        
    }
    private func setUpUI(){
        self.lbl_header_Price.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_ValPrice.font = FontManager.inter(.regular, size: 11.0)
        self.lbl_MainHeader.font =  FontManager.inter(.medium, size: 16.0)
        self.lbl_HotelName.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_Review.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_ReviewCount.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_TitleAbout.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_FaclityTitle.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_LocationTitle.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_AboutDescription.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_Addrees.font = FontManager.inter(.regular, size: 11.0)
        self.btn_VwOnMap.titleLabel?.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_price.font = FontManager.inter(.regular, size: 11.0)
        let nib = UINib(nibName: "FacilityCVC", bundle: nil)
        facilityCollectionVw.register(nib, forCellWithReuseIdentifier: "FacilityCVC")
        let nib2 = UINib(nibName: "CommonImageCell", bundle: nil)
        img_Collection_Vw.register(nib2, forCellWithReuseIdentifier: "CommonImageCell")
        facilityCollectionVw.delegate = self
        facilityCollectionVw.dataSource = self
        img_Collection_Vw.delegate = self
        img_Collection_Vw.dataSource = self
        applyGradientButtonStyle(to: self.btn_Availbility)
        self.btn_Availbility.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        img_Collection_Vw.isPagingEnabled = true
        img_Collection_Vw.showsHorizontalScrollIndicator = false
        img_Collection_Vw.decelerationRate = .fast
        
        page_Controller.numberOfPages = 10
        page_Controller.currentPage = 0
        page_Controller.currentPageIndicatorTintColor = UIColor(hex: "#299EF5") // ← Your highlight color
        page_Controller.pageIndicatorTintColor =  UIColor(hex: "#D9D9D9")
     
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: img_Collection_Vw.frame.width, height: img_Collection_Vw.frame.height)
        img_Collection_Vw.collectionViewLayout = layout
        self.mapVw.delegate = self

    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Availibilty(_ sender: Any) {
    }
    
    @IBAction func action_VwOnmPA(_ sender: Any) {
        
        if let lat = self.accomodationDetailObj?.accommodation.lat,
           let long = self.accomodationDetailObj?.accommodation.long {

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Accommodation Location" // 👉 Custom title on the pin
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            ])
        }


    }
    @IBAction func action_delete(_ sender: Any) {
        
#if BackpackerHire
        AlertManager.showConfirmationAlert(on: self,
                                           title: "Delete Accommodation",
                                           message: "Are you sure you want to delete the accommodation?",
                                           confirmAction: {
            if let id = self.accomodationID{
                self.empDeleteAccomodation(accID: id)
            }else{
                AlertManager.showAlert(on: self, title: "Missing", message: "Accommodation Id Is Missing")
            }
           
            
        })
#endif
      
        
    }
    @IBAction func action_Edit(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let accVC = storyboard.instantiateViewController(withIdentifier: "AddNewAccomodationVC") as? AddNewAccomodationVC {
            
            accVC.accomodationID = self.accomodationID
            
            let addres = self.accomodationDetailObj?.accommodation.address ?? ""
            let name = self.accomodationDetailObj?.accommodation.name ?? ""
            let description = self.accomodationDetailObj?.accommodation.description ?? ""
            let price = self.accomodationDetailObj?.accommodation.price ?? 0
            let loc = self.accomodationDetailObj?.accommodation.locationText ?? ""
            let lat = self.accomodationDetailObj?.accommodation.lat ?? 0.0
            let long = self.accomodationDetailObj?.accommodation.long ?? 0.0
            accVC.isComeFromEdit = true
            if let imageUrls = self.accomodationDetailObj?.accommodation.image {
                ImageLoader.loadImages(from: imageUrls) { images in
                    // here you get your [UIImage]
                    accVC.editImages = images
                    
                    accVC.editName = name
                    accVC.editAddress = addres
                    accVC.editDescription = description
                    accVC.editLocation = loc
                    accVC.editLat = lat
                    accVC.editLongitude = long
                    accVC.editPrice = "\(price)"
                    accVC.editFacilities = self.accomodationDetailObj?.accommodation.facilities ?? []
                    accVC.editedimageStrings = self.accomodationDetailObj?.accommodation.image ?? []
                    self.navigationController?.pushViewController(accVC, animated: true)
                }
                
            }
        } else {
            print("❌ Could not instantiate AddNewAccomodationVC")
        }
        
    }
}
extension AccomodationDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isLoading == false{
            if collectionView == img_Collection_Vw{
                return self.accomodationDetailObj?.accommodation.image.count ?? 0
            }else{
                return facilitiesArray?.count ?? 0 // <-- Replace with your array count
            }
        }else{
            return 1
        }

        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == img_Collection_Vw{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCell", for: indexPath) as? CommonImageCell else {
                return UICollectionViewCell()
            }
            cell.isComeFromHangout = false
            if let img = self.accomodationDetailObj?.accommodation.image[indexPath.item] {
                let baseURL1 = ApiConstants.API.API_IMAGEURL
                let baseURL2 = ApiConstants.API.API_IMAGEURL

                let imageURLString = img.hasPrefix("http") ? img : baseURL1 + img

                cell.img_Vw.sd_setImage(
                    with: URL(string: imageURLString),
                    placeholderImage: UIImage(named: "img_Placehodler")
                ) { image, error, _, _ in
                    if image == nil { // If first attempt fails
                        let fallbackURL = img.hasPrefix("http") ? img : baseURL2 + img
                        cell.img_Vw.sd_setImage(
                            with: URL(string: fallbackURL),
                            placeholderImage: UIImage(named: "img_Placehodler")
                        )
                    }
                }

            } else {
                cell.img_Vw.image = UIImage(named: "img_Placehodler")
            }
            cell.img_Vw.isUserInteractionEnabled = true
            cell.img_Vw.tag = indexPath.item

            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            cell.img_Vw.addGestureRecognizer(tap)

            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCVC", for: indexPath) as? FacilityCVC else {
                return UICollectionViewCell()
            }
            if facilitiesArray?.count ?? 0 > 0 {
                let facility = facilitiesArray?[indexPath.item] // Use your model or static data
                cell.setImageAndTitle(image: facility?.image ?? "", Title: facility?.title ?? "")
            }
            
            return cell
        }
     
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        let startIndex = tappedImageView.tag

        var photos: [SKPhotoProtocol] = []

        if let imgArr = accomodationDetailObj?.accommodation.image {
            for img in imgArr {
                let baseURL = ApiConstants.API.API_IMAGEURL
                let imageURLString = img.hasPrefix("http") ? img : baseURL + img

                let photo = SKPhoto.photoWithImageURL(imageURLString)
                photo.shouldCachePhotoURLImage = true
                photos.append(photo)
            }
        }

        let browser = SKPhotoBrowser(photos: photos, initialPageIndex: startIndex)
        browser.modalPresentationStyle = .fullScreen
        present(browser, animated: true, completion: nil)
    }


    // Optional: Set item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == img_Collection_Vw{
            let width = img_Collection_Vw.bounds.width

            return CGSize(width: width, height: 186)
        }else{
            let spacing: CGFloat = 10  // inter-item spacing
            let itemsPerRow: CGFloat = 4

            let totalSpacing = (itemsPerRow - 1) * spacing
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = availableWidth / itemsPerRow

            return CGSize(width: itemWidth, height: 75)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == img_Collection_Vw{
            return 0
        }else{
            return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == img_Collection_Vw{
            return 0
        }else{
            return 10
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / img_Collection_Vw.frame.width)
        page_Controller.currentPage = page
    }
 
}

extension AccomodationDetailVC {
    
#if BackpackerHire
    func getDetailOfAccomodationEmployer(){
        LoaderManager.shared.show()
        isLoading = true
        if accomodationID?.isEmpty == true {
            LoaderManager.shared.hide()
                AlertManager.showAlert(
                    on: self,
                    title: "Alert",
                    message: "Accomodation ID is missing."
                )
            
            return
        }else{
            viewMOdel.getEmployerAcommodationDetail(accommodationID: accomodationID ?? ""){ [weak self] (success: Bool, result: AccommodationDetailResponse?, statusCode: Int?) in
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
                                if result?.data != nil{
                                    self.accomodationDetailObj = result?.data
                                    self.setUpValues(obj: self.accomodationDetailObj!)
                                    
                                    self.isLoading = false
                                }else{
                                    AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Something went wrong.")
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
                                    self.getDetailOfAccomodation()
                                } else {
                                    LoaderManager.shared.hide()
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
    func empDeleteAccomodation(accID:String){
        LoaderManager.shared.show()
        isLoading = true
        if accID.isEmpty == true {
            LoaderManager.shared.hide()
            AlertManager.showAlert(
                on: self,
                title: "Alert",
                message: "Accommodation ID is missing."
            )
            
            return
        }else{
            viewMOdel.deletAccommodation(accommodationID: accID){ [weak self] (success: Bool, result: DeleteJobResponse?, statusCode: Int?) in
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
                                AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Accommodation deleted successfully"){
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
                                    self.empDeleteAccomodation(accID:self.accomodationID ?? "")
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
    
    func getDetailOfAccomodation(){
        LoaderManager.shared.show()
        isLoading = true
        if accomodationID?.isEmpty == true {
            LoaderManager.shared.hide()
                AlertManager.showAlert(
                    on: self,
                    title: "Alert",
                    message: "Accomodation ID is missing."
                )
            
            return
        }else{
            viewMOdel.getBackPackerAcommodationDetail(accommodationID: accomodationID ?? ""){ [weak self] (success: Bool, result: AccommodationDetailResponse?, statusCode: Int?) in
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
                                if result?.data != nil{
                                    self.accomodationDetailObj = result?.data
                                    self.setUpValues(obj: self.accomodationDetailObj!)
                                    
                                    self.isLoading = false
                                }else{
                                    AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Something went wrong.")
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
                                    self.getDetailOfAccomodation()
                                } else {
                                    LoaderManager.shared.hide()
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
    func setUpValues(obj : AccommodationDetailData){
        DispatchQueue.main.async {
            self.lbl_Addrees.text = obj.accommodation.address
            self.lbl_AboutDescription.text = obj.accommodation.description
            self.lbl_HotelName.text = obj.accommodation.name
            self.lbl_ValPrice.text = "$\(obj.accommodation.price)"
                if obj.accommodation.image.count == 1 {
                self.page_Controller.numberOfPages = 0
                self.page_Controller.currentPage = 0
                self.page_Controller.isHidden = true
            }else{
                self.page_Controller.numberOfPages = obj.accommodation.image.count
                self.page_Controller.currentPage = 0
                self.page_Controller.isHidden = false
            }
            
            self.img_Collection_Vw.reloadData()
            self.setFacilities(obj: obj)
                
            }
        self.setupMapAnnotations()
        }
    
    
    func setFacilities(obj : AccommodationDetailData){
        let facilities = obj.accommodation.facilities
        var objPfFacilty = [Facility]()
        for facility in facilities {
            /*
             Swimming Pool
             WiFi
             Parking
             Elevator
             Fitness Center
             24-hours Open
             
             --
             
             let facilities: [Facility] = [
                 Facility(image: "pool", title: "Swimming Pool"),
                 Facility(image: "wifi", title: "WiFi"),
                 Facility(image: "restaurant", title: "Restaurant"),
                 Facility(image: "parking", title: "Parking"),
                 Facility(image: "meeting", title: "Meeting Room"),
                 Facility(image: "elevator", title: "Elevator"),
                 Facility(image: "open", title: "24-hours Open"),
                 Facility(image: "fitness", title: "Fitness Center")
             ]
             
             */
            if facility == "Free WiFi" || facility == "Free Wifi" {//
                let obj = Facility(image: "wifi", title: facility)
                objPfFacilty.append(obj)
            }
            if facility == "Swimming Pool" {
                let obj = Facility(image: "pool", title: facility)
                objPfFacilty.append(obj)
            }
            if facility == "Parking" {
                let obj = Facility(image: "parking", title: facility)
                objPfFacilty.append(obj)
            }
            if facility == "Elevator" {
                let obj = Facility(image: "elevator", title: facility)
                objPfFacilty.append(obj)
            }
            if facility == "Fitness Center" {
                let obj = Facility(image: "fitness", title: facility)
                objPfFacilty.append(obj)
            }
            if facility == "24-hours Open" {
                let obj = Facility(image: "open", title: facility)
                objPfFacilty.append(obj)
            }
            self.facilitiesArray = objPfFacilty
            if facilitiesArray?.count ?? 0 <= 4 {
                self.facility_coll_height.constant = 100
            }else{
                self.facility_coll_height.constant = 200
            }
            
            DispatchQueue.main.async{
                self.facilityCollectionVw.reloadData()
            }
           
           
    }
}
}

extension AccomodationDetailVC: MKMapViewDelegate {
    
    func setupMapAnnotations() {
        guard let acc = self.accomodationDetailObj?.accommodation else { return }
        
       
        let annotation = AccommodationAnnotation(accommodation: acc)
        mapVw.addAnnotation(annotation)

        
        // Optionally zoom to show all annotations
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Exclude user location blue dot
        if annotation is MKUserLocation {
            return nil
        }
        
        guard annotation is AccommodationAnnotation else { return nil }
        
        let identifier = "UserAnnotationViewAccomodationss"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Set your custom marker image here
            annotationView?.image = UIImage(named: "custom_marker")
            
            // Optional: Add a callout accessory button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}








struct Facility {
    var image : String
    var title : String
    
}
import MapKit

class AccommodationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(accommodation: AccommodationDetail) {
        self.coordinate = CLLocationCoordinate2D(latitude: accommodation.lat, longitude: accommodation.long)
        self.title = accommodation.name
        self.subtitle = accommodation.locationText
    }
}
