//
//  HomeTVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit
import SDWebImage
class HomeTVC: UITableViewCell {
    
    @IBOutlet weak var home_CollectionVw: UICollectionView!
    var items: [String] = []
    var tableSection: Int = 0
    var onAddAccommodation: ((Int) -> Void)?
    var onHangOut: ((Int) -> Void)?
    var isComeFromJob : Bool = false
    var onTap: ((Int) -> Void)?
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
            }else{
                
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
    
    //Employer
    var totalJobCount : Int?
    var declinedJobCount : Int?
    var acceptedJobCount : Int?
    var employerJobList : [EmployerJob]?
    
    var empCurrentJobslist : [EmployerJob]?
    var empNewjobList : [EmployerJob]?
    var empPostedjobList : [EmployerJob]?
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
            if role == "3" || role == "4"  {
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
        
        if isComeFromJobListSeeAll == true{
            let sectionType = activeSectionsList?[tableSection]
            switch sectionType {
            case .currentJob:
                // Assuming one banner cell that shows all banners
                return empCurrentJobslist?.count ?? 0
            case .upcomingJob:
                return empNewjobList?.count ?? 0
            case .declinedJobs:
                return empPostedjobList?.count ?? 0
            case .none:
                return 0
            }
        }else{
            
            let sectionType = activeSections?[tableSection]
            switch sectionType {
            case .banner:
                // Assuming one banner cell that shows all banners
                if role == "2"{
                    return 3
                }else{
                    return 1
                }
                
            case .accommodations:
                return accomodationList?.count ?? 0
            case .hangouts:
                return hangoutList?.count ?? 0
            case .jobs:
                if role == "2"{
                    return employerJobList?.count ?? 0
                }else{
                    return jobList?.count ?? 0
                }
                
            case .none:
                return 0
            }
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
                self.onTap?(indexPath.item)
            }
            // Assign item to your label/image inside the cell
            // cell.titleLabel.text = item
            cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: isComeForHireDetailPage)
            return cell
        }else{
            if isComeFromJobListSeeAll == true {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                    return UICollectionViewCell()
                }
                
                guard let sectionType = activeSectionsList?[tableSection] else {
                    return cell
                }
                
                switch sectionType {
                case .currentJob:
                    if let declineJob = empCurrentJobslist?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            self.onTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = empCurrentJobslist?[indexPath.item].name ?? "No Data"
                        if let amnt = empCurrentJobslist?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"
                        }
                        cell.lbl_SubTitle.text = empCurrentJobslist?[indexPath.item].description ?? "No Data"
                        let baseURL1 = ApiConstants.API.API_IMAGEURL
                        let baseURL2 = ApiConstants.API.API_IMAGEURL
                        
                        let imageURLString: String
                        if let imagePath = declineJob.image, !imagePath.isEmpty {
                            imageURLString = imagePath.hasPrefix("http") ? imagePath : baseURL1 + imagePath
                        } else {
                            imageURLString = ""
                        }
                        
                        cell.imgVw.sd_setImage(
                            with: URL(string: imageURLString),
                            placeholderImage: UIImage(named: "img_Placehodler")
                        ) { image, _, _, _ in
                            if image == nil, let imagePath = declineJob.image, !imagePath.isEmpty {
                                let fallbackURL = imagePath.hasPrefix("http") ? imagePath : baseURL2 + imagePath
                                cell.imgVw.sd_setImage(
                                    with: URL(string: fallbackURL),
                                    placeholderImage: UIImage(named: "img_Placehodler")
                                )
                            }
                        }
                        
                        
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                        let strtTime = empCurrentJobslist?[indexPath.item].startTime
                        let endTime = empCurrentJobslist?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                        cell.SetUpHeight(isHeightShow: false)
                    }
                    
                case .upcomingJob:
                    
                    if let new = empNewjobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            self.onTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = empNewjobList?[indexPath.item].name ?? "No Data"
                        if let amnt = empNewjobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"
                        }
                        cell.lbl_SubTitle.text = empNewjobList?[indexPath.item].description ?? "No Data"
                        let baseURL1 = ApiConstants.API.API_IMAGEURL
                        let baseURL2 = ApiConstants.API.API_IMAGEURL
                        
                        let imageURLString: String
                        if let imagePath = new.image, !imagePath.isEmpty {
                            imageURLString = imagePath.hasPrefix("http") ? imagePath : baseURL1 + imagePath
                        } else {
                            imageURLString = ""
                        }
                        
                        cell.imgVw.sd_setImage(
                            with: URL(string: imageURLString),
                            placeholderImage: UIImage(named: "img_Placehodler")
                        ) { image, _, _, _ in
                            if image == nil, let imagePath = new.image, !imagePath.isEmpty {
                                let fallbackURL = imagePath.hasPrefix("http") ? imagePath : baseURL2 + imagePath
                                cell.imgVw.sd_setImage(
                                    with: URL(string: fallbackURL),
                                    placeholderImage: UIImage(named: "img_Placehodler")
                                )
                            }
                        }
                        
                        
                        let strtTime = empNewjobList?[indexPath.item].startTime
                        let endTime = empNewjobList?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                        cell.SetUpHeight(isHeightShow: false)
                    }
                    
                case .declinedJobs:
                    if let declineJob = empPostedjobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            
                            self.onTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = empPostedjobList?[indexPath.item].name ?? "No Data"
                        if let amnt = empPostedjobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"
                        }
                        cell.lbl_SubTitle.text = empPostedjobList?[indexPath.item].description ?? "No Data"
                        let baseURL1 = ApiConstants.API.API_IMAGEURL
                        let baseURL2 = ApiConstants.API.API_IMAGEURL
                        
                        let imageURLString: String
                        if let imagePath = declineJob.image, !imagePath.isEmpty {
                            imageURLString = imagePath.hasPrefix("http") ? imagePath : baseURL1 + imagePath
                        } else {
                            imageURLString = ""
                        }
                        
                        cell.imgVw.sd_setImage(
                            with: URL(string: imageURLString),
                            placeholderImage: UIImage(named: "img_Placehodler")
                        ) { image, _, _, _ in
                            if image == nil, let imagePath = declineJob.image, !imagePath.isEmpty {
                                let fallbackURL = imagePath.hasPrefix("http") ? imagePath : baseURL2 + imagePath
                                cell.imgVw.sd_setImage(
                                    with: URL(string: fallbackURL),
                                    placeholderImage: UIImage(named: "img_Placehodler")
                                )
                            }
                        }
                        
                        
                        let strtTime = empPostedjobList?[indexPath.item].startTime
                        let endTime = empPostedjobList?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                        cell.SetUpHeight(isHeightShow: false)
                    }
                    
                default:
                    break
                }
                
                return cell
                
                
                
                
            }else{
                
#if BackpackerHire
                if role == "2"{
                    guard let sectionType = activeSections?[tableSection] else {
                        return UICollectionViewCell()
                    }
                    
                    switch sectionType {
                    case .banner:
                        // Banner cell logic elsewhere
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobCountCVC", for: indexPath) as? JobCountCVC else {
                            return UICollectionViewCell()
                        }
                        if indexPath.item == 0{
                            if let total = self.totalJobCount {
                                cell.lbl_Count.text = "\(total)"
                            }else{
                                cell.lbl_Count.text = "-"
                            }
                            cell.lbl_title.text = "Total Job Offer"
                        }else if indexPath.item == 1{
                            
                            if let decline = self.declinedJobCount {
                                cell.lbl_Count.text = "\(decline)"
                            }else{
                                cell.lbl_Count.text = "-"
                            }
                            cell.lbl_title.text = "Declined"
                        }else if indexPath.item == 2{
                            if let accepted = self.acceptedJobCount {
                                cell.lbl_Count.text = "\(accepted)"
                            }else{
                                cell.lbl_Count.text = "-"
                            }
                            cell.lbl_title.text = "Accepted"
                        }
                        return cell
                        
                    case .accommodations:
                        break
                    case .hangouts:
                        break
                    case .jobs :
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                            return UICollectionViewCell()
                        }
                        cell.onTap = { [weak self]  index in
                              guard let self = self else { return }
                              print("Cell tapped at index: \(indexPath.item)")
                              // Navigate or perform any action

                            self.onTap?(indexPath.item)
                          }


                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.setUpUI(iscomeFromAccept: true,isComeForHiredetailpagee: isComeForHireDetailPage)
                        if  let obj = employerJobList?[indexPath.item] {
                            cell.indexPath = indexPath.item
                            cell.lbl_Title.text = obj.name
                            cell.lbl_SubTitle.text = obj.address ?? obj.description
                            if let price = obj.price {
                                cell.lblAmount.text = "$\(price) per day"
                            }
                            if let firstIMage = obj.image{
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
                            let strtTime = obj.startTime
                            let endTime = obj.endTime
                            let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                            cell.lbl_duration.text = "Duration \(duration1)"
                        }

                        cell.setUpApeeranceOflbl_Amunt(isShow: true)
                        return cell
                    }
                    
                }else{
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
                        if let accomodationList = accomodationList?[indexPath.item] {
                            cell.item = indexPath.item
                            cell.lbl_Title.text = accomodationList.name
                            cell.lblAmount.text = "From $, \(accomodationList.price) per adult"
                            if let firstIMage = accomodationList.image.first{
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
                            cell.onItemTapped = { [weak self] item in
                                
                                print("Item",item)
                                self?.onAddAccommodation?(item)
                                
                            }
                        }
                        cell.lblAmount.isHidden = false
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.cosmosVw.isHidden = true
                        return cell
                    case .hangouts:
                        if let hangout = hangoutList?[indexPath.item] {
                            cell.item = indexPath.item
                            cell.lbl_Title.text = hangout.name
                            if let firstIMage = hangout.image.first{
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
                        }
                        cell.onItemTapped = { [weak self] item in
                            
                            print("Item",item)
                            self?.onHangOut?(item)
                            
                        }
                        cell.lblAmount.isHidden = true
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.cosmosVw.isHidden = true
                        
                        return cell
                    case .jobs :
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                            return UICollectionViewCell()
                        }
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            
                            self.onTap?(indexPath.item)
                        }
                        
                        
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.setUpUI(iscomeFromAccept: true,isComeForHiredetailpagee: isComeForHireDetailPage)
                        if  let obj = employerJobList?[indexPath.item] {
                            cell.indexPath = indexPath.item
                            cell.lbl_Title.text = obj.name
                            cell.lbl_SubTitle.text = obj.address ?? obj.description
                            if let price = obj.price {
                                cell.lblAmount.text = "$\(price) per day"
                            }
                            if let firstIMage = obj.image{
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
                            let strtTime = obj.startTime
                            let endTime = obj.endTime
                            let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                            cell.lbl_duration.text = "Duration \(duration1)"
                        }
                        
                        cell.setUpApeeranceOflbl_Amunt(isShow: true)
                        return cell
                    }
                    
                    
                }
                
#endif
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
                    cell.lblAmount.text = "From $\(accommodation.price) per adult" //From $40 per adult
                    cell.lblAmount.isHidden = false
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
                        self?.onAddAccommodation?(indexPath.item)
                    }
                }
                
            case .hangouts:
                if let hangout = hangoutList?[indexPath.item] {
                    cell.lbl_Title.text = hangout.name
                    cell.lblAmount.isHidden = true
                    cell.lblRating.isHidden = true
                    cell.lbl_review.isHidden = true
                    cell.cosmosVw.isHidden = true
                    cell.item = indexPath.item
                    if let firstIMage = hangout.image.first{
                        let baseURL3000 = ApiConstants.API.API_IMAGEURL
                        let baseURL3001 = ApiConstants.API.API_IMAGEURL
                        
                        // Choose which one you want to use
                        let baseURL = baseURL3000 // or baseURL3001
                        
                        let imageURLString = firstIMage.hasPrefix("http") ? firstIMage : baseURL + firstIMage
                        
                        cell.imgVw.sd_setImage(
                            with: URL(string: imageURLString),
                            placeholderImage: UIImage(named: "img_Placehodler")
                        )
                        
                    }else{
                        cell.imgVw.image = UIImage(named: "img_Placehodler")
                    }
                    cell.onItemTapped = { [weak self]  index in
                        self?.onHangOut?(indexPath.item)
                    }
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
                            self.onTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = currentJobslist?[indexPath.item].name ?? "No Data"
                        if let amnt = currentJobslist?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"//per day
                        }
                        cell.lbl_SubTitle.text = currentJobslist?[indexPath.item].description ?? "No Data"
                        if declineJob.image.hasPrefix("http") {
                            cell.imgVw.sd_setImage(
                                with: URL(string: declineJob.image),
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
                        
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                        let strtTime = currentJobslist?[indexPath.item].startTime
                        let endTime = currentJobslist?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
                    }
                    
                case .upcomingJob:
                    
                    if let new = newjobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            self.onTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = newjobList?[indexPath.item].name ?? "No Data"
                        if let amnt = newjobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"
                        }
                        cell.lbl_SubTitle.text = newjobList?[indexPath.item].description ?? "No Data"
                        if new.image.hasPrefix("http") {
                            cell.imgVw.sd_setImage(with: URL(string: new.image), placeholderImage: UIImage(named: "img_Placehodler"))
                        } else {
                            let url3000 = "\(ApiConstants.API.API_IMAGEURL)\(new.image)"
                            let url3001 = "\(ApiConstants.API.API_IMAGEURL)\(new.image)"
                            
                            cell.imgVw.sd_setImage(with: URL(string: url3000), placeholderImage: UIImage(named: "img_Placehodler")) { img, _, _, _ in
                                if img == nil {
                                    cell.imgVw.sd_setImage(with: URL(string: url3001), placeholderImage: UIImage(named: "img_Placehodler"))
                                }
                            }
                        }
                        
                        let strtTime = newjobList?[indexPath.item].startTime
                        let endTime = newjobList?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
                        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                    }
                    
                case .declinedJobs:
                    if let declineJob = declinedjobList?[indexPath.item] {
                        cell.onTap = { [weak self]  index in
                            guard let self = self else { return }
                            print("Cell tapped at index: \(indexPath.item)")
                            // Navigate or perform any action
                            
                            self.onTap?(indexPath.item)
                        }
                        // Assign item to your label/image inside the cell
                        // cell.titleLabel.text = item
                        cell.lbl_Title.text = declinedjobList?[indexPath.item].name ?? "No Data"
                        if let amnt = declinedjobList?[indexPath.item].price {
                            cell.lblAmount.text = "$\(amnt) per day"
                        }
                        cell.lbl_SubTitle.text = declinedjobList?[indexPath.item].description ?? "No Data"
                        let imageURLString = declineJob.image.hasPrefix("http") ? declineJob.image : "\(ApiConstants.API.API_IMAGEURL)\(declineJob.image)"
                        cell.imgVw.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "img_Placehodler"))
                        let strtTime = declinedjobList?[indexPath.item].startTime
                        let endTime = declinedjobList?[indexPath.item].endTime
                        let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                        cell.lbl_duration.text = "Duration \(duration1)"
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
                    self.onTap?(indexPath.item)
                    //  self.onTap?(<#Int#>)
                }
                // Assign item to your label/image inside the cell
                // cell.titleLabel.text = item
                cell.lbl_Title.text = jobList?[indexPath.item].name ?? "No Data"
                if let amnt = jobList?[indexPath.item].price {
                    cell.lblAmount.text = "$\(amnt) per day"
                }
                cell.lbl_SubTitle.text = jobList?[indexPath.item].description ?? "No Data"
                if let jobImage = jobList?[indexPath.item] {
                    let base3000 = ApiConstants.API.API_IMAGEURL
                    let base3001 = ApiConstants.API.API_IMAGEURL
                    
                    if jobImage.image.hasPrefix("http") {
                        cell.imgVw.sd_setImage(
                            with: URL(string: jobImage.image),
                            placeholderImage: UIImage(named: "img_Placehodler")
                        )
                    } else {
                        let url3000 = URL(string: base3000 + jobImage.image)
                        let url3001 = URL(string: base3001 + jobImage.image)
                        
                        cell.imgVw.sd_setImage(
                            with: url3000,
                            placeholderImage: UIImage(named: "img_Placehodler")
                        ) { image, error, _, _ in
                            if image == nil { // failed to load from 3000, try 3001
                                cell.imgVw.sd_setImage(
                                    with: url3001,
                                    placeholderImage: UIImage(named: "img_Placehodler")
                                )
                            }
                        }
                    }
                    
                }
                let strtTime = jobList?[indexPath.item].startTime
                let endTime = jobList?[indexPath.item].endTime
                let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
                cell.lbl_duration.text = "Duration \(duration1)"
                cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
                return cell
            }
            
        }
        
#endif
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
#if Backapacker
        self.onTapAcceptJob?(indexPath.row)
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
        
        
        
        
        
        let sectionType = activeSections?[tableSection]
        switch sectionType {
        case .banner:
            return CGSize(width: (width / 2) - 5, height: 180)
        case .accommodations:
            return CGSize(width: (width / 2) - 12, height: 235)
        case  .hangouts:
            return CGSize(width: (width / 2) - 12, height: 210)
        case .jobs :
            if isComeForHireDetailPage  == true{
                return CGSize(width: (width / 2) - 5, height: 200)
            }else{
                if isComeFromJobListSeeAll == true{
                    return CGSize(width: (width / 2) - 12, height: 185)
                }else{
                    return CGSize(width: (width / 2) - 12, height: 190)
                }
                
            }
        case .none:
            if isComeForHireDetailPage  == true{
                return CGSize(width: (width / 2) - 5, height: 180)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
        }
        
#else
        
        
        let sectionType = activeSections?[tableSection]
        switch sectionType {
        case .banner:
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 215)
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
            return CGSize(width: (width / 2) - 12, height: 210)
        case .jobs :
            if isComeFromJob == false{
                return CGSize(width: (width / 2) - 12, height: 160)
            }else{
                return CGSize(width: (width / 2) - 12, height: 180)
            }
        case .none:
            return CGSize(width: (width / 2) - 12, height: 185)
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

