//
//  NotificationTVC.swift
//  Backpacker
//
//  Created by Sahil Sharma on 12/07/25.
//

import UIKit

class NotificationTVC: UITableViewCell {

    @IBOutlet weak var mainVw: UIView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbl_title.font = FontManager.inter(.medium, size: 14.0)
        self.lblSubTitle.font = FontManager.inter(.regular, size: 10.0)
    }

    override func layoutSubviews() {
            super.layoutSubviews()
        self.mainVw.addShadowAllSides(radius:1.5)
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
}
