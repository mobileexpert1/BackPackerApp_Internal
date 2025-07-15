//
//  SettingTVCTableViewCell.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class SettingTVC: UITableViewCell {

    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainview.addShadowAllSides(radius:2)
        self.lblTitle.font = FontManager.poppins(.medium, size: 13.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
