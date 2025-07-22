//
//  HomeTVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class HomeTVC: UITableViewCell {
    
    @IBOutlet weak var home_CollectionVw: UICollectionView!
    var items: [String] = []
    var tableSection: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero
        
#if BackpackerHire
        let nib = UINib(nibName: "AccomodationCVC", bundle: nil)
        home_CollectionVw.register(nib, forCellWithReuseIdentifier: "AccomodationCVC")
        
        let nib2 = UINib(nibName: "AddAccomodationCVC", bundle: nil)
        home_CollectionVw.register(nib2, forCellWithReuseIdentifier: "AddAccomodationCVC")
        
        
        let nib3 = UINib(nibName: "JobCountCVC", bundle: nil)
        home_CollectionVw.register(nib3, forCellWithReuseIdentifier: "JobCountCVC")
        
        home_CollectionVw.dataSource = self
        home_CollectionVw.delegate = self
        if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
#else
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        home_CollectionVw.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        home_CollectionVw.dataSource = self
        home_CollectionVw.delegate = self
        if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
#endif
       
            home_CollectionVw.showsHorizontalScrollIndicator = false
            home_CollectionVw.showsVerticalScrollIndicator = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(with items: [String], section: Int) {
        self.items = items
        self.tableSection = section
        home_CollectionVw.reloadData()
    }
}
extension HomeTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
#if BackpackerHire
        if tableSection == 0 {
            return 4
        }else if tableSection == 1 {
            return 4
        }else{
            return 10
        }
#else
        return items.count
        
#endif
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
#if BackpackerHire
        if tableSection == 0{
            if indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 2{
               
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCountCVC", for: indexPath) as? JobCountCVC else {
                    return UICollectionViewCell()
                }
              //  let item = items[indexPath.item]
                // cell.titleLabel.text = item
                return cell
            }else{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAccomodationCVC", for: indexPath) as? AddAccomodationCVC else {
                    return UICollectionViewCell()
                }
              //  let item = items[indexPath.item]
                // cell.titleLabel.text = item
                return cell
            }
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                return UICollectionViewCell()
            }
          //  let item = items[indexPath.item]
            // cell.titleLabel.text = item
            return cell
        }
      
#else
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        // Assign item to your label/image inside the cell
        // cell.titleLabel.text = item
        return cell
#endif
       
    }
    // Size of each item (4 per row)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
#if BackpackerHire
        
        if tableSection == 0 {
            return CGSize(width: (width / 2) - 5, height: 200)
        }else if tableSection == 1 {
            return CGSize(width: (width / 2) - 12, height: 250)
        }else{
            return CGSize(width: (width / 2) - 12, height: 150)
        }
        
        
       
#else
        
        return CGSize(width: (width / 2) - 12, height: 180)
        
#endif
        
        
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
        if tableSection == 0 {
            return 0
        }else{
            return 10
        }
       
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if tableSection == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
        }
      
    }
    
    
}
