//
//  MainJobCVC.swift
//  Backpacker
//
//  Created by Mobile on 21/07/25.
//

import UIKit

class MainJobCVC: UICollectionViewCell {

    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var title_header: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title_header.font = FontManager.inter(.semiBold, size: 14.0)
    }

    // MARK: - Helper Methods
    func showBottomView(_ show: Bool) {
            bottomVw.isHidden = !show
        if show {
            bottomVw.backgroundColor = .black
            self.title_header.textColor = .black
            self.title_header.font = FontManager.inter(.semiBold, size: 14.0)
        }else{
            bottomVw.backgroundColor = UIColor(hex: "#9E9E9E")
            self.title_header.textColor = UIColor(hex: "#9E9E9E")
            self.title_header.font = FontManager.inter(.regular, size: 14.0)
        }
        }
    
    
}
