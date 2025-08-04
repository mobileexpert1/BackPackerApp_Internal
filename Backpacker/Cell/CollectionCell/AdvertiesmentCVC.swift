//
//  AdvertiesmentCVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import SkeletonView
class AdvertiesmentCVC: UICollectionViewCell {

    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUI()
    }
    private func setUpUI(){
        self.lbl_Name.font = FontManager.inter(.semiBold, size: 24.0)
        self.isSkeletonable = true
        lbl_Name.isSkeletonable = true
       imageVw.isSkeletonable = true
    }
}
struct Advertisement {
    let name: String
    let address: String
    let image: UIImage
}
