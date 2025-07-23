//
//  AdvertiesmentTVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class AdvertiesmentTVC: UITableViewCell {

    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionViw: UICollectionView!
    var ads: [Advertisement] = [] {
        didSet {
            collectionViw.reloadData()
            pageController.numberOfPages = ads.count
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionViw.delegate = self
        collectionViw.dataSource = self

        collectionViw.register(UINib(nibName: "AdvertiesmentCVC", bundle: nil), forCellWithReuseIdentifier: "AdvertiesmentCVC")
        
        collectionViw.isPagingEnabled = true
        collectionViw.showsHorizontalScrollIndicator = false

        pageController.currentPageIndicatorTintColor = UIColor(hex: "#299EF5")
        pageController.pageIndicatorTintColor = UIColor(hex:"#D9D9D9") 
        pageController.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // 1.0 is default

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension AdvertiesmentTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiesmentCVC", for: indexPath) as? AdvertiesmentCVC else {
            return UICollectionViewCell()
        }
        let ad = ads[indexPath.item]
        cell.lbl_Name.text = ad.name
        cell.lbl_Address.text = ad.address
     //   cell.imageVw.image = ad.image
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
}
