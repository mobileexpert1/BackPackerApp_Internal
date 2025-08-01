//
//  AccomodationDetailVC.swift
//  BackpackerHire
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import Cosmos
import MapKit
class AccomodationDetailVC: UIViewController {
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var facilityCollectionVw: UICollectionView!
    
    @IBOutlet weak var btn_Availbility: UIButton!
    
    @IBOutlet weak var btn_VwOnMap: UIButton!
    @IBOutlet weak var lbl_Review: UILabel!
    @IBOutlet weak var lbl_HotelName: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var lbl_ReviewCount: UILabel!
    
    @IBOutlet weak var lbl_Addrees: UILabel!
    @IBOutlet weak var lbl_TitleAbout: UILabel!
    @IBOutlet weak var ratingVw: CosmosView!
    
    @IBOutlet weak var lbl_AboutDescription: UILabel!
    
    @IBOutlet weak var lbl_FaclityTitle: UILabel!
    
    @IBOutlet weak var lbl_LocationTitle: UILabel!
    
    
    @IBOutlet weak var img_Collection_Vw: UICollectionView!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
 
    private func setUpUI(){
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
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


    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Availibilty(_ sender: Any) {
    }
    
}
extension AccomodationDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == img_Collection_Vw{
            return 10
        }else{
            return facilities.count // <-- Replace with your array count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == img_Collection_Vw{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCell", for: indexPath) as? CommonImageCell else {
                return UICollectionViewCell()
            }
            cell.isComeFromHangout = false
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FacilityCVC", for: indexPath) as? FacilityCVC else {
                return UICollectionViewCell()
            }
            
            let facility = facilities[indexPath.item] // Use your model or static data
            cell.setImageAndTitle(image: facility.image, Title: facility.title)
            
            return cell
        }
        
        
     
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


struct Facility {
    var image : String
    var title : String
    
}
