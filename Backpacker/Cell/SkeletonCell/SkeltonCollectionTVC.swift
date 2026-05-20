//  SkeltonCollectionTVC.swift
//  Backpacker
//  Created by Mobile on 05/08/25.

import UIKit

class SkeltonCollectionTVC: UITableViewCell {
    
    @IBOutlet weak var collVw: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "SkeltonCVC", bundle: nil)
        self.collVw.register(nib, forCellWithReuseIdentifier: "SkeltonCVC")
        
        collVw.delegate = self
        collVw.dataSource = self
        collVw.isSkeletonable = true
        
        self.collVw.showsHorizontalScrollIndicator = false
        self.collVw.showsVerticalScrollIndicator = false
        self.collVw.isScrollEnabled = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension SkeltonCollectionTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeltonCVC", for: indexPath) as? SkeltonCVC else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10 // spacing between cells
        let sectionInsets: CGFloat = 4 // left + right insets
        let columns: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
        
        let totalSpacing = (columns - 1) * spacing + sectionInsets
        let width = (collectionView.frame.width - totalSpacing) / columns
        
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2, bottom: 4, right: 2)
    }
}
