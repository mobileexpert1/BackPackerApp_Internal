//
//  BackPackerListTVC.swift
//  Backpacker
//
//  Created by Mobile on 08/07/25.
//

import UIKit
import Cosmos
class BackPackerListTVC: UITableViewCell {

    @IBOutlet weak var mainVw: UIView!
    @IBOutlet weak var rating_Vw: CosmosView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_CompletedJob: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbl_Name.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_CompletedJob.font = FontManager.inter(.medium, size: 12.0)
      //  self.mainVw.layer.cornerRadius = 10.0
       // self.mainVw.layer.borderWidth = 1.0
      //  self.mainVw.layer.borderColor = UIColor(named:"borderColor")?.cgColor
        self.mainVw.addShadowAllSides(opacity: 0.2, radius: 2)
        self.rating_Vw.settings.updateOnTouch = false       // 🔒 Disable touch rating
           self.rating_Vw.isUserInteractionEnabled = false     // 🔒 Fully disables interaction
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
