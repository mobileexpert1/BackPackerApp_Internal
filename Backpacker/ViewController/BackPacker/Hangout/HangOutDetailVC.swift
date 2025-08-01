//
//  HangOutDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import MapKit

class HangOutDetailVC: UIViewController {

    @IBOutlet weak var page_Controller: UIPageControl!
    @IBOutlet weak var img_CollectionVw: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var title_Location: UILabel!
    
    @IBOutlet weak var btn_ViewOnMap: UIButton!
    
    @IBOutlet weak var lbl_Address: UILabel!
    
    @IBOutlet weak var title_About: UILabel!
    
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var lbl_restaurantName: UILabel!
    
    @IBOutlet weak var lbl_AboutDescription: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpCollectionVw()
        
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
        
        page_Controller.numberOfPages = 10
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
    }
    @IBAction func action_VwOnMap(_ sender: Any) {
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension HangOutDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonImageCell", for: indexPath) as? CommonImageCell else {
                return UICollectionViewCell()
            }
        cell.isComeFromHangout = true
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
