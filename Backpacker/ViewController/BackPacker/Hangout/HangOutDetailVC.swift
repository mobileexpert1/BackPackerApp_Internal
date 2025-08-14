//
//  HangOutDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import MapKit
import SDWebImage
class HangOutDetailVC: UIViewController {

    @IBOutlet weak var Bg_Vw_image_Collection: UIView!
    @IBOutlet weak var page_Controller: UIPageControl!
    @IBOutlet weak var img_CollectionVw: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var title_Location: UILabel!
    
    @IBOutlet weak var btn_ViewOnMap: UIButton!
    
    @IBOutlet weak var lbl_Address: UILabel!
    
    @IBOutlet weak var title_About: UILabel!
    
    @IBOutlet weak var mainScrollVw: UIScrollView!
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var lbl_restaurantName: UILabel!
    
    @IBOutlet weak var lbl_AboutDescription: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    let viewMOdel = HangoutViewModel()
    let viewModelAuth = LogInVM()
    var isLoading: Bool = true // true while loading, false once data is ready
    var hangoutDetailObj : HangoutData?
    var hangoutID : String?
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
#if BackpackerHire
        
        self.getEmployerDetailOfHangout()
#else
        self.getDetailOfHangout()
        
#endif
        
        self.setUpCollectionVw()
        self.setupPullToRefresh()
        
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
        
        self.getEmployerDetailOfHangout()
#else
        self.getDetailOfHangout()
        
#endif
        }
        
    }
    private func setUpUI(){
        self.title_Location.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_Address.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_restaurantName.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_Rating.font = FontManager.inter(.regular, size: 10.0)
        self.lbl_review.font = FontManager.inter(.regular, size: 10.0)
        self.title_About.font = FontManager.inter(.semiBold, size: 14.0)
        self.lbl_AboutDescription.font = FontManager.inter(.regular, size: 12.0)
        btn_ViewOnMap.titleLabel?.font = FontManager.inter(.regular, size: 12.0)
        
    

    }
    
    func setUpCollectionVw(){
        let nib2 = UINib(nibName: "CommonImageCell", bundle: nil)
        img_CollectionVw.register(nib2, forCellWithReuseIdentifier: "CommonImageCell")
      
        img_CollectionVw.isPagingEnabled = true
        img_CollectionVw.showsHorizontalScrollIndicator = false
        img_CollectionVw.decelerationRate = .fast
        
        page_Controller.numberOfPages = self.hangoutDetailObj?.hangout.image.count ?? 0
        page_Controller.currentPage = 0
        page_Controller.currentPageIndicatorTintColor = UIColor(hex: "#299EF5") // ← Your highlight color
        page_Controller.pageIndicatorTintColor =  UIColor(hex: "#D9D9D9")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: img_CollectionVw.frame.width, height: img_CollectionVw.frame.height)
        img_CollectionVw.collectionViewLayout = layout
        img_CollectionVw.delegate = self
        img_CollectionVw.dataSource = self
        self.mapView.delegate = self
    }
    @IBAction func action_VwOnMap(_ sender: Any) {
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension HangOutDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading == true{
            return 5
        }else{
            return hangoutDetailObj?.hangout.image.count ?? 0
        }
       
      
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCell", for: indexPath) as? CommonImageCell else {
            return UICollectionViewCell()
        }
        
        cell.isComeFromHangout = true
        
        if let img = hangoutDetailObj?.hangout.image[indexPath.item] {
            let baseURL1 = "http://192.168.11.4:3000/assets/"
            let baseURL2 = "http://192.168.11.4:3001/assets/"

            let imageURLString = img.hasPrefix("http") ? img : baseURL1 + img

            cell.img_Vw.sd_setImage(
                with: URL(string: imageURLString),
                placeholderImage: UIImage(named: "restaurantImg")
            ) { image, error, _, _ in
                if image == nil { // First attempt failed
                    let fallbackURL = img.hasPrefix("http") ? img : baseURL2 + img
                    cell.img_Vw.sd_setImage(
                        with: URL(string: fallbackURL),
                        placeholderImage: UIImage(named: "restaurantImg")
                    )
                }
            }
        } else {
            cell.img_Vw.image = UIImage(named: "restaurantImg")
        }
        
        return cell
    }

    // Optional: Set item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = img_CollectionVw.bounds.width

            return CGSize(width: width, height: 186)
    

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
            return 0
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      
            return 0
     
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / img_CollectionVw.frame.width)
        page_Controller.currentPage = page
    }
   
}

extension HangOutDetailVC {
    
#if BackpackerHire
    func getEmployerDetailOfHangout(){
        LoaderManager.shared.show()
        isLoading = true
        if hangoutID?.isEmpty == true {
            LoaderManager.shared.hide()
                AlertManager.showAlert(
                    on: self,
                    title: "Alert",
                    message: "Hangout ID is missing."
                )
            
            return
        }else{
            viewMOdel.getEmployerHangutDetail(hangoutID: hangoutID ?? ""){ [weak self] (success: Bool, result: HangoutDetailResponse?, statusCode: Int?) in
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
                                    self.isLoading = false
                                    self.hangoutDetailObj = result?.data
                                    self.setUpValues(obj: self.hangoutDetailObj!)
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
                                    self.getEmployerDetailOfHangout()
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
    
    
    
    #else
    
    func getDetailOfHangout(){
        LoaderManager.shared.show()
        isLoading = true
        if hangoutID?.isEmpty == true {
            LoaderManager.shared.hide()
                AlertManager.showAlert(
                    on: self,
                    title: "Alert",
                    message: "Hangout ID is missing."
                )
            
            return
        }else{
            viewMOdel.getBackPackerHangutDetail(hangoutID: hangoutID ?? ""){ [weak self] (success: Bool, result: HangoutDetailResponse?, statusCode: Int?) in
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
                                    self.isLoading = false
                                    self.hangoutDetailObj = result?.data
                                    self.setUpValues(obj: self.hangoutDetailObj!)
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
                                    self.getDetailOfHangout()
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
  
    func setUpValues(obj : HangoutData){
        DispatchQueue.main.async {
            self.lbl_Address.text = obj.hangout.address
            self.lbl_restaurantName.text = obj.hangout.name
            self.lbl_AboutDescription.text = obj.hangout.description
            if self.hangoutDetailObj?.hangout.image.count == 1 {
                self.page_Controller.numberOfPages = 0
                self.page_Controller.currentPage = 0
                self.page_Controller.isHidden = true
            }else{
                self.page_Controller.numberOfPages = self.hangoutDetailObj?.hangout.image.count ?? 0
                self.page_Controller.currentPage = 0
                self.page_Controller.isHidden = false
            }
            
            self.img_CollectionVw.reloadData()
            self.setupMapAnnotations()
        }
    }
}


import MapKit

extension HangOutDetailVC: MKMapViewDelegate {

    func setupMapAnnotations() {
        guard let nearbyUsers = self.hangoutDetailObj?.nearbyUsers else { return }
        
        for user in nearbyUsers {
            let annotation = UserAnnotation(user: user)
            mapView.addAnnotation(annotation)
        }
        
        // Optionally zoom to show all annotations
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Exclude user location blue dot
        if annotation is MKUserLocation {
            return nil
        }
        
        guard annotation is UserAnnotation else { return nil }
        
        let identifier = "UserAnnotationViewAccomodatio"
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

import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(user: NearbyUser) {
        self.coordinate = CLLocationCoordinate2D(latitude: user.lat, longitude: user.long)
        self.title = user.name
        self.subtitle = user.email
    }
}
