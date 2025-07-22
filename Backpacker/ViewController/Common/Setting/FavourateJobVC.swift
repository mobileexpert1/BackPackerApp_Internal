//
//  FavourateJobVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class FavourateJobVC: UIViewController {

    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
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
        self.searchVw.addShadowAllSides(radius:2)
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
           collectionView.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        filteredDesignations = designations  // Initialize with full data
           searchTxtFld.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchTextChanged() {
        let text = searchTxtFld.text ?? ""
        if text.isEmpty {
            filteredDesignations = designations
        } else {
            filteredDesignations = designations.filter { $0.lowercased().contains(text.lowercased()) }
        }
        collectionView.reloadData()
    }

}
extension FavourateJobVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDesignations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
        cell.lbl_Title.text = filteredDesignations[indexPath.row]
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
