//
//  FacilityTVC.swift
//  Backpacker
//
//  Created by Mobile on 25/07/25.
//

import UIKit

class FacilityTVC: UITableViewCell {

    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.font = FontManager.inter(.regular, size: 13.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
