//
//  AdvertiesmentCVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

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
        self.lbl_Name.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_Address.font = FontManager.inter(.regular, size: 12.0)
    }
}
struct Advertisement {
    let name: String
    let address: String
    let image: UIImage
}
