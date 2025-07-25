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
    var onAddAccommodation: (() -> Void)?
    var isComeFromJob : Bool = false
    var onTap: (() -> Void)?
    var onTapAcceptJob: ((Int) -> Void)?
    var isComeForHireDetailPage : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero
        
#if BackpackerHire
        let nib2 = UINib(nibName: "AddAccomodationCVC", bundle: nil)
        home_CollectionVw.register(nib2, forCellWithReuseIdentifier: "AddAccomodationCVC")
        let nib3 = UINib(nibName: "JobCountCVC", bundle: nil)
        home_CollectionVw.register(nib3, forCellWithReuseIdentifier: "JobCountCVC")
#else
      
#endif
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        home_CollectionVw.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        let nib4 = UINib(nibName: "AccomodationCVC", bundle: nil)
        home_CollectionVw.register(nib4, forCellWithReuseIdentifier: "AccomodationCVC")
        home_CollectionVw.dataSource = self
        home_CollectionVw.delegate = self
        if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
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
        
        if isComeForHireDetailPage == true  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                return UICollectionViewCell()
            }
            cell.onTap = { [weak self]  index in
                  guard let self = self else { return }
                  print("Cell tapped at index: \(indexPath.item)")
                  // Navigate or perform any action
                self.onTap?()
              }
            // Assign item to your label/image inside the cell
            // cell.titleLabel.text = item
            cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: isComeForHireDetailPage)
            return cell
        }else{
            if tableSection == 0{
                if indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 2{
                   
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCountCVC", for: indexPath) as? JobCountCVC else {
                        return UICollectionViewCell()
                    }
                    if indexPath.item == 0{
                        cell.lbl_Count.text = "20"
                        cell.lbl_title.text = "Total Job Offer"
                    }else if indexPath.item == 1{
                        cell.lbl_Count.text = "12"
                        cell.lbl_title.text = "Declined"
                    }else if indexPath.item == 2{
                        cell.lbl_Count.text = "8"
                        cell.lbl_title.text = "Accepted"
                    }
                  //  let item = items[indexPath.item]
                    // cell.titleLabel.text = item
                  
                    return cell
                }else{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAccomodationCVC", for: indexPath) as? AddAccomodationCVC else {
                        return UICollectionViewCell()
                    }
                    cell.onAddAccommodationTapped = {
                           print("Add button tapped at index \(indexPath.row)")
                           // Call your function or navigate here
                        self.onAddAccommodation?()
                       }
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
        }
      
      
#else
        if isComeFromJob == false{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                return UICollectionViewCell()
            }
            // Assign item to your label/image inside the cell
            // cell.titleLabel.text = item
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                return UICollectionViewCell()
            }
            cell.onTap = { [weak self]  index in
                  guard let self = self else { return }
                  print("Cell tapped at index: \(indexPath.item)")
                  // Navigate or perform any action
                self.onTap?()
              }
            // Assign item to your label/image inside the cell
            // cell.titleLabel.text = item
            cell.setUpUI(iscomeFromAccept: false)
            return cell
        }
      
#endif
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
#if Backapacker
        
        #else
        if tableSection == 0 {
            if indexPath.item == 0{
                self.onTapAcceptJob?(0)
            }else if indexPath.item == 1{
                self.onTapAcceptJob?(1)
            }else if indexPath.item == 2{
                self.onTapAcceptJob?(2)
            }
        }
        
#endif
    }
    // Size of each item (4 per row)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
#if BackpackerHire
        
        if tableSection == 0 {
            return CGSize(width: (width / 2) - 5, height: 180)
        }else if tableSection == 1 {
            if isComeForHireDetailPage  == true{
                return CGSize(width: (width / 2) - 5, height: 180)
            }else{
                return CGSize(width: (width / 2) - 12, height: 250)
            }
           
        }else{
            return CGSize(width: (width / 2) - 12, height: 150)
        }
        
        
       
#else
        if tableSection == 0 {
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 150)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
            
        }else if tableSection == 1 || tableSection == 2 {
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 250)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
           
        }else{
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 150)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
            
        }
      
        
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
            if isComeFromJob == true{
                return 10
            }else{
                if isComeForHireDetailPage == true{
                    return 10
                }else{
                    return 0
                }
               
            }
            
        }else{
            return 10
        }
       
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if tableSection == 0 {
            if isComeFromJob == true{
                return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
            }else{
                if isComeForHireDetailPage == true{
                    return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
                }else{
                    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
               
            }
           
        }else{
            return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
        }
      
    }
   
}
