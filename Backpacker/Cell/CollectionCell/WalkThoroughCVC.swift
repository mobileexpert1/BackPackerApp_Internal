//
//  WalkThoroughCVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit

class WalkThoroughCVC: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_Title.font = FontManager.inter(.bold, size: 30)
        lbl_Title.numberOfLines = 0
        
        lblSubTitle.font = FontManager.inter(.regular, size: 15)
        lblSubTitle.numberOfLines = 0
    }

    func configure(with item: WalkthroughItem) {
        imgVw.image = item.image
        lbl_Title.text = item.title
        lblSubTitle.text = item.subTitle
    }
}
