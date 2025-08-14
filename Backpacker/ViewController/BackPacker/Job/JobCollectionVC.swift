//
//  JobCollectionVC.swift
//  Backpacker
//
//  Created by Mobile on 08/07/25.
//

import UIKit

class JobCollectionVC: UIViewController {
    
    
    @IBOutlet weak var searchVw: UIView!
    
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtFldSearch: UITextField!
    
    @IBOutlet weak var searchVw_BtmConstraint: NSLayoutConstraint!
    
    var filteredDesignations = [JobsDesignation]()
    @IBOutlet weak var collectionView: UICollectionView!
    var isSearchViewVisible : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
           collectionView.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        self.txtFldSearch.delegate = self
        txtFldSearch.attributedPlaceholder = NSAttributedString(
            string: "Search Job",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: FontManager.inter(.regular, size: 14.0)
            ])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if BackpackerHire
        if isSearchViewVisible == true{
            self.searchVw.layer.borderColor = UIColor.black.cgColor
            self.searchVw.layer.borderWidth = 1.0
            
            self.searchVw.isHidden = false
            self.searchViewHeight.constant = 45.0
            self.searchVw_BtmConstraint.constant = 10.0
        }else{
            self.searchVw.isHidden = true
            self.searchViewHeight.constant = 0.0
            self.searchVw_BtmConstraint.constant = 0.0
        }
        #else
        self.searchVw.isHidden = true
        self.searchViewHeight.constant = 0.0
        self.searchVw_BtmConstraint.constant = 0.0
#endif
        
    }
    func updateDesignations(_ newList: [JobsDesignation]) {
        self.filteredDesignations = newList
        self.collectionView.reloadData()
    }
    
    
    func NavigateToDetailVC(indexPath:Int){
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
               
               // Optional: pass selected job title
               let selectedJob = filteredDesignations[indexPath]
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
    }

}
extension JobCollectionVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDesignations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
        cell.indexPath = indexPath.row
        cell.lbl_Title.text = filteredDesignations[indexPath.row].Name
        cell.setUpUI(iscomeFromAccept: false)
        cell.onTap = { [weak self ] index in
            print("Job Post BackPAcker Hire Index",index)
            self?.NavigateToDetailVC(indexPath: index)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Job", bundle: nil)
//           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as? JobDescriptionVC {
//               
//               // Optional: pass selected job title
//               let selectedJob = filteredDesignations[indexPath.row]
//               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
//           }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let width = collectionView.bounds.width
        return CGSize(width: (width / 2) - 4, height: 178)
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
        return UIEdgeInsets(top: 5, left: 0, bottom: 4, right: 0)
    }
    
}
extension JobCollectionVC  : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension JobCollectionVC {
    
    
    func EmployerJobList(){
        
    }
    
}
