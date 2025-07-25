//
//  HangOutVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import MapKit
class HangOutVC: UIViewController {

    @IBOutlet weak var txtFld: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectIOnVw: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectIOnVw.delegate = self
        self.collectIOnVw.dataSource = self

        let nib = UINib(nibName: "AccomodationCVC", bundle: nil)
        self.collectIOnVw.register(nib, forCellWithReuseIdentifier: "AccomodationCVC")
        
        self.collectIOnVw.isScrollEnabled = false
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        self.searchVw.layer.borderWidth = 1.0
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        txtFld.attributedPlaceholder = NSAttributedString(
                   string: "Search Restaurant",
                   attributes: [
                    .foregroundColor: UIColor.black,
                       .font: FontManager.inter(.regular, size: 14.0)
                   ])
        txtFld.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }
    func updateCollectionViewHeight() {
        self.collectIOnVw.layoutIfNeeded()
        self.collectionViewHeight.constant = self.collectIOnVw.collectionViewLayout.collectionViewContentSize.height
    }

    @IBAction func action_filter(_ sender: Any) {
    }
    
}
extension HangOutVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccomodationCVC", for: indexPath) as? AccomodationCVC else {
            return UICollectionViewCell()
        }

        // Configure your cell
        // cell.titleLabel.text = dataArr[indexPath.item]
        cell.imgVw.image = UIImage(named: "restaurantImg")
        cell.lbl_Title.text = "Mendoza's Social Club"
        cell.lblAmount.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "HangOut", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "HangOutDetailVC") as? HangOutDetailVC {
               
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width/2) - 5 , height: 220) // Adjust height based on content
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            print("Search for: \(textField.text ?? "")")
            return true
        }
}
