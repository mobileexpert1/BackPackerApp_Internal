//
//  EmployerAccomodationVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit

class EmployerAccomodationVC: UIViewController {

    @IBOutlet weak var coollVw: UICollectionView!
    @IBOutlet weak var txtFld_Search: UITextField!
    @IBOutlet weak var searchBgVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var filterImgWidth: NSLayoutConstraint!
    
    let hotels = [
        "Little National Hotel Sydney",
        "Dorsett Melbourne",
        "The Langham Sydney",
        "Crown Towers Melbourne",
        "QT Melbourne",
        "Park Hyatt Sydney",
        "Shangri-La Hotel Sydney",
        "The Westin Melbourne",
        "Sofitel Sydney Darling Harbour",
        "Four Seasons Hotel Sydney"
    ]

    var filteredDesignations: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.searchBgVw.layer.borderColor = UIColor.black.cgColor
        self.searchBgVw.layer.borderWidth = 1.0
        let nib = UINib(nibName: "AccomodationCVC", bundle: nil)
        coollVw.register(nib, forCellWithReuseIdentifier: "AccomodationCVC")
        self.coollVw.delegate = self
        self.coollVw.dataSource = self
        if let layout = coollVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        txtFld_Search.attributedPlaceholder = NSAttributedString(
            string: "Search Accommodation",
            attributes: [
                .foregroundColor: UIColor.black,
                .font:FontManager.inter(.regular, size: 14.0)
            ]
        )
        txtFld_Search.delegate = self
        filteredDesignations = hotels  // Initialize with full data
        txtFld_Search.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    

    @objc func searchTextChanged() {
        let text = txtFld_Search.text ?? ""
        if text.isEmpty {
            filteredDesignations = hotels
        } else {
            filteredDesignations = hotels.filter { $0.lowercased().contains(text.lowercased()) }
        }
        coollVw.reloadData()
    }

    @IBAction func action_Sort(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)

        
    }
}
extension EmployerAccomodationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDesignations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
            return UICollectionViewCell()
        }
        cell.lbl_Title.text = filteredDesignations[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 250) // Adjust height based on content
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Accomodation", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "AccomodationDetailVC") as? AccomodationDetailVC {
            self.navigationController?.pushViewController(settingVC, animated: true)
        } else {
            print("❌ Could not instantiate SettingVC")
        }
    }
}
extension EmployerAccomodationVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          print("Search for: \(textField.text ?? "")")
          return true
      }
}
