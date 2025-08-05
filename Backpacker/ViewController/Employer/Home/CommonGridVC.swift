//
//  CommonGridVC.swift
//  Backpacker
//
//  Created by Mobile on 05/08/25.
//

import UIKit

class CommonGridVC: UIViewController {
    
    @IBOutlet weak var main_Header: UILabel!
    @IBOutlet weak var collVw: UICollectionView!
    var currentPage = 1
    var isFetchingData = false
    var hasMorePages = true
    var isLoadingMore = false
    
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var seacrh_Vw: UIView!
    var isComeFromHomeJob : Bool = false
    var isComeFromHomeAccomodation : Bool = false
    var isComeFromHomeHangout : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register the collection view cell
        collVw.register(UINib(nibName: "AccomodationCVC", bundle: nil), forCellWithReuseIdentifier: "AccomodationCVC")
        collVw.register(UINib(nibName: "HomeJobCVC", bundle: nil), forCellWithReuseIdentifier: "HomeJobCVC")
        collVw.delegate = self
        collVw.dataSource = self
        
        if let layout = collVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        self.setUpStatus()
        self.main_Header.font = FontManager.inter(.semiBold, size: 16.0)
        self.seacrh_Vw.layer.cornerRadius = 25.0
        self.seacrh_Vw.layer.borderWidth = 0.8
        self.seacrh_Vw.layer.borderColor = UIColor(hex: "#000000").cgColor
        txtFldSearch.delegate = self
    }
    func setUpStatus(){
        if isComeFromHomeJob == true{
            self.isComeFromHomeHangout = false
            self.isComeFromHomeAccomodation = false
            print("IsComefrom JOb")
            self.main_Header.text = "Jobs"
            
        }else  if isComeFromHomeHangout == true{
            self.isComeFromHomeJob = false
            self.isComeFromHomeAccomodation = false
            print("IsComefrom Hangout")
            self.main_Header.text = "Backpacker Hangout"
            
        }else  if isComeFromHomeAccomodation == true{
            self.isComeFromHomeJob = false
            self.isComeFromHomeHangout = false
            print("IsComefrom Accomodation")
            self.main_Header.text = "Accpmmodations"
            
        }
        self.setTitleForSearch()
    }
    func setTitleForSearch(){
        
        if isComeFromHomeJob == true{
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Jobs",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
           
            
        }else  if isComeFromHomeHangout == true{
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Hangouts",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
            
        }else  if isComeFromHomeAccomodation == true{
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Accpmmodations",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
        }
    }
    @IBAction func action_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension CommonGridVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if isComeFromHomeHangout == true || isComeFromHomeAccomodation == true{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
                return UICollectionViewCell()
            }
            // Optionally configure cell
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
                return UICollectionViewCell()
            }
            // Optionally configure cell
            return cell
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isComeFromHomeJob == true{
            let width = collectionView.bounds.width
            return CGSize(width: (width / 2) - 4, height: 178)
        }else{
            return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 225) // Adjust height based on content
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
        return 10
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if isComeFromHomeJob == true {
            return UIEdgeInsets(top: 5, left: 0, bottom: 4, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
       
    }
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            if !isFetchingData && hasMorePages {
                currentPage += 1
                print("Curretn Page",currentPage)
            }
        }
    }
    
}

extension CommonGridVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFldSearch.resignFirstResponder()
        return true
    }
}
