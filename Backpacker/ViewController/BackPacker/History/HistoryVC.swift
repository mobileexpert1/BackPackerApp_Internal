//
//  HistoryVC.swift
//  Backpacker
//
//  Created by Sahil Sharma on 12/07/25.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var historyCV: UICollectionView!
  //  @IBOutlet weak var Main_SettinhgVw: UIView!
    @IBOutlet weak var lbl_SubHeader: UILabel!
 //   @IBOutlet weak var lblHeader: UILabel!
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
    var filteredDesignations: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        Main_SettinhgVw.addShadowAllSides()
//        self.lblHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_SubHeader.font = FontManager.inter(.semiBold, size: 16.0)
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        historyCV.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        self.historyCV.delegate = self
        self.historyCV.dataSource = self
        if let layout = historyCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        self.filteredDesignations = designations
    }
    

    @IBAction func action_Setting(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as? SettingVC {
               self.navigationController?.pushViewController(settingVC, animated: true)
           } else {
               print("- Could not instantiate SettingVC")
           }
    }
}


extension HistoryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDesignations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
        cell.lbl_Title.text = filteredDesignations[indexPath.row]
#if Backapacker
        cell.setUpUI(iscomeFromAccept: false)
        
#else
        cell.setUpUI(iscomeFromAccept: true)
#endif
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 180) // Adjust height based on content
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}
