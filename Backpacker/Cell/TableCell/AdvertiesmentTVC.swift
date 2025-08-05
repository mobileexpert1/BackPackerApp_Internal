//
//  AdvertiesmentTVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import SDWebImage
import SkeletonView
class AdvertiesmentTVC: UITableViewCell {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionViw: UICollectionView!
#if Backapacker
    var ads: [BannerItem] = [] {
          didSet {
              if ads.isEmpty {
                  collectionViw.showAnimatedGradientSkeleton()
              } else {
                  collectionViw.stopSkeletonAnimation()
                  collectionViw.hideSkeleton(reloadDataAfter: true)
                  pageController.numberOfPages = ads.count
              }
          }
      }
    
#else
    var adsHire : [Advertisement]?
    
#endif
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViw.delegate = self
                collectionViw.dataSource = self
                collectionViw.isSkeletonable = true
                
                collectionViw.register(UINib(nibName: "AdvertiesmentCVC", bundle: nil), forCellWithReuseIdentifier: "AdvertiesmentCVC")
                collectionViw.isPagingEnabled = true
                collectionViw.showsHorizontalScrollIndicator = false

                pageController.currentPageIndicatorTintColor = UIColor(hex: "#299EF5")
                pageController.pageIndicatorTintColor = UIColor(hex:"#D9D9D9")
                pageController.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                // Start shimmer until data arrives
#if Backapacker
        
        collectionViw.showAnimatedGradientSkeleton()
#endif
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }
    
}
// MARK: - SkeletonCollectionViewDataSource
extension AdvertiesmentTVC: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "AdvertiesmentCVC"
    }
}
// MARK: - UICollectionView Delegates
extension AdvertiesmentTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
#if BackpackerHire
        
        return adsHire?.count ?? 0
        #else
        return ads.isEmpty ? 5 : ads.count
#endif
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiesmentCVC", for: indexPath) as? AdvertiesmentCVC else {
            return UICollectionViewCell()
        }
#if BackpackerHire
        let ad = adsHire?[indexPath.item]
        cell.lbl_Name.text = ad?.name
        cell.imageVw.image = UIImage(named: "advertiesment")
        
        #else
        
        if ads.isEmpty {
            cell.lbl_Name.text = " "
            cell.imageVw.image = nil
        } else {
            let ad = ads[indexPath.item]
            cell.lbl_Name.text = ad.description ?? ""
            let imageURLString = ad.image.hasPrefix("http") ? ad.image : "http://192.168.11.4:3001/assets/\(ad.image)"
            cell.imageVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "placeholder"))
        }

        
#endif
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ad = ads[indexPath.item]
        let urlString = ad.link
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
}
