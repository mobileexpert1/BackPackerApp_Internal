//
//  CommonHistoryTVC.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import UIKit

class CommonHistoryTVC: UITableViewCell {

    @IBOutlet weak var collVw: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero
        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        collVw.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        collVw.dataSource = self
        collVw.delegate = self
        collVw.showsHorizontalScrollIndicator = false
        collVw.showsVerticalScrollIndicator = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension CommonHistoryTVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
        cell.onTap = { [weak self]  index in
            guard let self = self else { return }
            print("Cell tapped at index: \(indexPath.item)")
            // Navigate or perform any action
        }
        // Assign item to your label/image inside the cell
        // cell.titleLabel.text = item
        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    // Size of each item (4 per row)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width

            return CGSize(width: (width / 2) - 12, height: 200)
       
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
        return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
        
    }
}
