//
//  FavourateJobVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class FavourateJobVC: UIViewController {
    @IBOutlet weak var CoLLectIonVwMain: UICollectionView!
    @IBOutlet weak var headerCollView: UICollectionView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    var selectedIndexHeader =  0
    var isComeFromAcceptDeclineJobs : Bool = false
    @IBOutlet weak var height_headerCollection: NSLayoutConstraint!
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
#if Backapacker
    var headerTirle = ["Accomodations","Hangout","Jobs"]
#else
    var headerTirle = ["Accomodations","Jobs"]
#endif
    var jobsTitle = ["Accepted","Declined"]
    let designations = [
        "Software Engineer",
        "UI/UX Designer",
        "Product Manager",
        "Data Analyst",
        "Mobile Developer",
        "QA Tester",
        "DevOps Engineer",
        "Project Coordinator",
        "Backend Developer",
        "Technical Lead"
    ]
    let hangoutPlaces = [
        "The Food Lounge",
        "Chillax Café",
        "Urban Bites",
        "The Rustic Table",
        "Midnight Munch",
        "Brew & Chew",
        "The Spice Route",
        "Fork & Fire",
        "Bean & Barrel",
        "NomNom Nook"
    ]
    let accommodations = [
        "Sunset View Hotel",
        "Royal Orchid Suites",
        "Palm Grove Resort",
        "Coastal Breeze Inn",
        "Skyline Grand Hotel",
        "Blue Lagoon Stay",
        "Urban Nest Suites",
        "Mountain Peak Lodge",
        "Serenity Bay Hotel",
        "Golden Hour Residency"
    ]
    
    
    var filteredDesignations: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.lbl_MainHeader.text = "Favorite"
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        CoLLectIonVwMain.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        self.filteredDesignations = designations
        let nib2 = UINib(nibName: "AccomodationCVC", bundle: nil)
        CoLLectIonVwMain.register(nib2, forCellWithReuseIdentifier: "AccomodationCVC")
        headerCollView.register(UINib(nibName: "MainJobCVC", bundle: nil), forCellWithReuseIdentifier: "MainJobCVC")
        
        
        self.headerCollView.delegate = self
        self.headerCollView.dataSource = self
        headerCollView.scrollToItem(at: IndexPath(item: selectedIndexHeader, section: 0), at: .centeredHorizontally, animated: false)
        
        self.CoLLectIonVwMain.delegate = self
        self.CoLLectIonVwMain.dataSource = self
        if let layout = CoLLectIonVwMain.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
#if BackpackerHire
        if isComeFromAcceptDeclineJobs != true  {
            if role == "3"{
                self.selectedIndexHeader = 0
              //  headerTirle = ["Accomodation"]
            }else if role == "4"{
                self.selectedIndexHeader = 0
            }else{
                self.selectedIndexHeader = 1
              //  headerTirle = ["Jobs"]
            }
        }
        if role == "3"{
            selectedIndexHeader = 0
            self.height_headerCollection.constant = 0
            self.headerCollView.isHidden = true
            self.lbl_MainHeader.text = "Favorite Accomodations"
        } else if role == "4"{
            selectedIndexHeader = 0
            self.height_headerCollection.constant = 0
            self.headerCollView.isHidden = true
            self.lbl_MainHeader.text = "Favorite HangOut"
        }else if role == "2"{
            selectedIndexHeader = 1
            self.height_headerCollection.constant = 0
            self.headerCollView.isHidden = true
            self.lbl_MainHeader.text = "Favorite Jobs"
        }
        #else
        
        
#endif
        
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
extension FavourateJobVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollView{
            if isComeFromAcceptDeclineJobs {
                return jobsTitle.count
            }else{
                return headerTirle.count
            }
        }else{
#if BackpackerHire
            
            if selectedIndexHeader == 0 {
                if isComeFromAcceptDeclineJobs {
                    return filteredDesignations.count
                }else{
                    return filteredDesignations.count
                }
            }else{
                return filteredDesignations.count
            }
            
#else
            if selectedIndexHeader == 0 {
                return accommodations.count
            }else if selectedIndexHeader == 1 {
                return hangoutPlaces.count
            }else{
                return filteredDesignations.count
            }
#endif
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainJobCVC", for: indexPath) as? MainJobCVC else {
                return UICollectionViewCell()
            }
            if isComeFromAcceptDeclineJobs {
                cell.title_header.text = jobsTitle[indexPath.item]
            }else{
                cell.title_header.text = headerTirle[indexPath.item]
            }
            cell.showBottomView(indexPath.item == selectedIndexHeader)
            return cell
        }else{
            
#if BackpackerHire
            if isComeFromAcceptDeclineJobs{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                    return UICollectionViewCell()
                }
                if selectedIndexHeader == 0{
                    cell.lbl_jobStatus.text = "Accepted"
                    cell.statusVw.backgroundColor = UIColor(hex: "#00A925")
                    cell.setUpUI(iscomeFromAccept: isComeFromAcceptDeclineJobs)
                }
                else{
                    
                    cell.lbl_jobStatus.text = "Declined"
                    cell.statusVw.backgroundColor = UIColor(hex: "#F80505")
                    cell.setUpUI(iscomeFromAccept: isComeFromAcceptDeclineJobs)
                }
                return cell
            }else{
                if selectedIndexHeader == 0{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                        return UICollectionViewCell()
                    }
                    if role == "3"{
                        cell.lbl_Title.text = accommodations[indexPath.row]
                        cell.imgVw.image = UIImage(named: "aCCOMODATION")
                        cell.lblAmount.isHidden = false
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.cosmosVw.isHidden = true
                    }else if role == "4"{
                        cell.lbl_Title.text = accommodations[indexPath.row]
                        cell.imgVw.image = UIImage(named: "restaurantImg")
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.lblAmount.isHidden = true
                        cell.cosmosVw.isHidden = true
                    }else{
                        cell.lbl_Title.text = accommodations[indexPath.row]
                        cell.imgVw.image = UIImage(named: "aCCOMODATION")
                        cell.lblRating.isHidden = true
                        cell.lbl_review.isHidden = true
                        cell.lblAmount.isHidden = true
                    }
                   
                    return cell
                }
                else{
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                        return UICollectionViewCell()
                    }
                    
                    cell.lbl_Title.text = filteredDesignations[indexPath.row]
                    cell.setUpUI(iscomeFromAccept: isComeFromAcceptDeclineJobs)
                    return cell
                }
            }
            
          
#else
            if selectedIndexHeader == 0{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                    return UICollectionViewCell()
                }
                cell.lbl_Title.text = accommodations[indexPath.row]
                cell.imgVw.image = UIImage(named: "aCCOMODATION")
                cell.lblAmount.isHidden = false
                return cell
            }else if selectedIndexHeader == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                    return UICollectionViewCell()
                }
                cell.lbl_Title.text =   hangoutPlaces[indexPath.row]
                cell.imgVw.image = UIImage(named: "restaurantImg")
                cell.lblAmount.isHidden = true
                return cell
            }
            else{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                    return UICollectionViewCell()
                }
                cell.lbl_Title.text = filteredDesignations[indexPath.row]
                cell.setUpUI(iscomeFromAccept: false)
                return cell
            }
#endif
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollView{
            let previousIndex = selectedIndexHeader
            selectedIndexHeader = indexPath.item
            
            let indexesToReload = [
                IndexPath(item: previousIndex, section: 0),
                IndexPath(item: selectedIndexHeader, section: 0)
            ]
            collectionView.reloadItems(at: indexesToReload)
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            self.CoLLectIonVwMain.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == headerCollView{
            let title = headerTirle[indexPath.item]
            let font = FontManager.inter(.medium, size: 12.0) // Adjust if you use custom font
            let padding: CGFloat = 12 // Add padding for horizontal margins
            
            let textWidth = title.size(withAttributes: [.font: font]).width
            if isComeFromAcceptDeclineJobs {
                return CGSize(width: textWidth + padding + 20, height: 50) // Adjust height as per design
            }else{
                return CGSize(width: textWidth + padding + 13, height: 50) // Adjust height as per design
            }
            
        }else{
#if BackpackerHire
            if isComeFromAcceptDeclineJobs{
               
                    return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 200) // Adjust height based on content
               
            }else{
                if selectedIndexHeader == 0{
                    if role == "4"{
                        return CGSize(width: (collectionView.bounds.width/2) - 3 , height: 205) // Adjust height based on content
                    }else  if role == "3"{
                        return CGSize(width: (collectionView.bounds.width/2) - 3 , height: 235) // Adjust height based on content
                    }else{
                        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 240) // Adjust height based on content
                    }
                   
                }
                else{
                    return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 180) // Adjust height based on content
                }
            }
            
            
#else
            if selectedIndexHeader == 0{
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 240) // Adjust height based on content
            }else if selectedIndexHeader == 1 {
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 220) // Adjust height based on content
            }
            else{
                return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 180) // Adjust height based on content
            }
#endif
          
            
        }
        
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
        if collectionView == CoLLectIonVwMain{
            if role == "4"{
                return 2
            }else if role == "3"{
                return 2
            }else{
                return 10
            }
            
        }else{
            return 0
        }
        
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    }
}
