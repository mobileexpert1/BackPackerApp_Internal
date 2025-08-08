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
   // var isComeForHireDetailPage : Bool = false
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    var isComeForHireDetailPage: Bool = false {
        didSet {
            print("isComeForHireDetailPage set to: \(isComeForHireDetailPage)")
            if isComeForHireDetailPage == true{
                if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            }
        }
    }
    var isComeFromJobListSeeAll: Bool = false
    
    var activeSections: [SectionType]?
    var activeSectionsList: [SectionTypeList]?
    var jobList : [JobItem]?
    var accomodationList : [AccommodationItem]?
    var hangoutList : [HangoutItem]?
    
    var currentJobslist : [JobItem]?
    var newjobList : [JobItem]?
    var declinedjobList : [JobItem]?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        home_CollectionVw.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        let nib4 = UINib(nibName: "AccomodationCVC", bundle: nil)
        home_CollectionVw.register(nib4, forCellWithReuseIdentifier: "AccomodationCVC")
#if BackpackerHire
        self.setupCollection()
       
#else
        if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
#endif
       
        home_CollectionVw.dataSource = self
        home_CollectionVw.delegate = self
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
    func setupCollection(){
        let nib2 = UINib(nibName: "AddAccomodationCVC", bundle: nil)
        home_CollectionVw.register(nib2, forCellWithReuseIdentifier: "AddAccomodationCVC")
        let nib3 = UINib(nibName: "JobCountCVC", bundle: nil)
        home_CollectionVw.register(nib3, forCellWithReuseIdentifier: "JobCountCVC")
        if isComeForHireDetailPage == true{
            if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        }else{
            if role == "3" || role == "4" ||  role == "2" {
                if isComeForHireDetailPage == false{
                    if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
                        layout.scrollDirection = .vertical
                    }
                }
               
            }else{
                if let layout = home_CollectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
            }
           
        }
    }
}
extension HomeTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
#if BackpackerHire
        if tableSection == 0 {
            return 3
        }else if tableSection == 1 {
            return 4
        }else{
            return 10
        }
#else
        if isComeFromJobListSeeAll == true{
            let sectionType = activeSectionsList?[tableSection]
                 switch sectionType {
                 case .currentJob:
                     // Assuming one banner cell that shows all banners
                     return currentJobslist?.count ?? 0
                 case .upcomingJob:
                     return newjobList?.count ?? 0
                 case .declinedJobs:
                     return declinedjobList?.count ?? 0
                 case .none:
                     return 0
                 }
        }else{
            let sectionType = activeSections?[tableSection]
                 switch sectionType {
                 case .banner:
                     // Assuming one banner cell that shows all banners
                     return 1
                 case .accommodations:
                     return accomodationList?.count ?? 0
                 case .hangouts:
                     return hangoutList?.count ?? 0
                 case .jobs:
                     return jobList?.count ?? 0
                 case .none:
                     return items.count
                 }
        }
       
      
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
                
                if role  == "4"{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }

                    // Configure your cell
                    // cell.titleLabel.text = dataArr[indexPath.item]
                    cell.imgVw.image = UIImage(named: "restaurantImg")
                    cell.lbl_Title.text = "Mendoza's Social Club"
                    cell.lblAmount.isHidden = true
                    cell.lblRating.isHidden = true
                    cell.lbl_review.isHidden = true
                    cell.cosmosVw.isHidden = true
                    return cell
                } else if role  == "3"{
                    
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }

                    // Configure your cell
                    // cell.titleLabel.text = dataArr[indexPath.item]
                    cell.imgVw.image = UIImage(named: "aCCOMODATION")
                    cell.lbl_Title.text = "Mendoza's Social Club"
                    cell.lblAmount.isHidden = false
                    cell.lblRating.isHidden = true
                    cell.lbl_review.isHidden = true
                    cell.cosmosVw.isHidden = true
                    return cell
                }
                else{
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
                }
            
            }
        }
      
      
#else
        if isComeFromJob == false{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                return UICollectionViewCell()
            }

            guard let sectionType = activeSections?[tableSection] else {
                return cell
            }

            switch sectionType {
            case .banner:
                // Banner cell logic elsewhere
                break

            case .accommodations:
                if let accommodation = accomodationList?[indexPath.item] {
                    
                    cell.lbl_Title.text = accommodation.name
                    cell.lblAmount.text = "$\(accommodation.price)"
                    cell.lblAmount.isHidden = false
                    cell.lblRating.isHidden = true
                    cell.lbl_review.isHidden = true
                    cell.cosmosVw.isHidden = true
                    if let firstIMage = accommodation.image.first{
                        let imageURLString = firstIMage.hasPrefix("http") ? firstIMage : "http://192.168.11.4:3001/assets/\(firstIMage)"
                        cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "aCCOMODATION"))
                    }else{
                        cell.imgVw.image = UIImage(named: "aCCOMODATION")
                    }
                  
                }

            case .hangouts:
                if let hangout = hangoutList?[indexPath.item] {
                    cell.lbl_Title.text = hangout.name
                    cell.lblAmount.isHidden = true
                    cell.lblRating.isHidden = true
                    cell.lbl_review.isHidden = true
                    cell.cosmosVw.isHidden = true
                    let imageURLString = hangout.image.hasPrefix("http") ? hangout.image : "http://192.168.11.4:3000/assets/\(hangout.image)"
                    cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "restaurantImg"))
                }

            default:
                break
            }

            return cell
          
        }else{
            
            if isComeFromJobListSeeAll == true{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                    return UICollectionViewCell()
                }

                guard let sectionType = activeSectionsList?[tableSection] else {
                    return cell
                }

                switch sectionType {
                case .currentJob:
                    if let declineJob = currentJobslist?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                              guard let self = self else { return }
                              print("Cell tapped at index: \(indexPath.item)")
                              // Navigate or perform any action
                            self.onTap?()
                          }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = currentJobslist?[indexPath.item].name ?? "No Data"
                        if let amnt = currentJobslist?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt)"
                        }
                        cell.lbl_SubTitle.text = currentJobslist?[indexPath.item].description ?? "No Data"
                        let imageURLString = declineJob.image.hasPrefix("http") ? declineJob.image : "http://192.168.11.4:3001/assets/\(declineJob.image)"
                        cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "Profile"))
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                    }

                case .upcomingJob:
                
                    if let new = newjobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                              guard let self = self else { return }
                              print("Cell tapped at index: \(indexPath.item)")
                              // Navigate or perform any action
                            self.onTap?()
                          }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = newjobList?[indexPath.item].name ?? "No Data"
                        if let amnt = newjobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt)"
                        }
                        cell.lbl_SubTitle.text = newjobList?[indexPath.item].description ?? "No Data"
                        let imageURLString = new.image.hasPrefix("http") ? new.image : "http://192.168.11.4:3001/assets/\(new.image)"
                        cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "Profile"))
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                    }

                case .declinedJobs:
                    if let declineJob = declinedjobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                              guard let self = self else { return }
                              print("Cell tapped at index: \(indexPath.item)")
                              // Navigate or perform any action
                            self.onTap?()
                          }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = declinedjobList?[indexPath.item].name ?? "No Data"
                        if let amnt = declinedjobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt)"
                        }
                        cell.lbl_SubTitle.text = declinedjobList?[indexPath.item].description ?? "No Data"
                        let imageURLString = declineJob.image.hasPrefix("http") ? declineJob.image : "http://192.168.11.4:3001/assets/\(declineJob.image)"
                        cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "Profile"))
                        cell.setUpUI(iscomeFromAccept: true,isComeForHiredetailpagee: true)
                    }

                default:
                    break
                }

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
                cell.lbl_Title.text = jobList?[indexPath.item].name ?? "No Data"
                if let amnt = jobList?[indexPath.item].price {
                    cell.lblAmount.text = "$\(amnt)"
                }
                cell.lbl_SubTitle.text = jobList?[indexPath.item].description ?? "No Data"
                cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                return cell
            }
            
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
            if role == "4"{
                return CGSize(width: (width / 2) - 12, height: 205)
            }else if role  == "3"{
                return CGSize(width: (width / 2) - 12, height: 235)
            }else if role  == "2"{
                
                if isComeForHireDetailPage  == true{
                    return CGSize(width: (width / 2) - 5, height: 200)
                }else{
                    return CGSize(width: (width / 2) - 12, height: 190)
                }
            }else{
                if isComeForHireDetailPage  == true{
                    return CGSize(width: (width / 2) - 5, height: 180)
                }else{
                    return CGSize(width: (width / 2) - 12, height: 180)
                }
            }
          
           
        }else{
            return CGSize(width: (width / 2) - 12, height: 150)
        }
          
#else
        
        
        let sectionType = activeSections?[tableSection]
        switch sectionType {
        case .banner:
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 205)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
        case .accommodations:
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 230)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
        case  .hangouts:
                return CGSize(width: (width / 2) - 12, height: 205)
        case .jobs :
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 150)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
        case .none:
            return CGSize(width: (width / 2) - 12, height: 190)
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
#if BackpackerHire
            if role == "4" {
                return 0
            }else if role == "3" {
                return 0
            }else{
                return 10
            }
            
            #else
            
            return 10
#endif
            
            
            
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
            
#if BackpackerHire
            if role == "4" {
                return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
            }else{
                return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
            }
            
            #else
            
            return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
#endif
        
           
        }
      
    }
   
}
