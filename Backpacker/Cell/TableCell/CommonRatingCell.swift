//
//  CommonRatingCell.swift
//  Backpacker
//
//  Created by Mobile on 10/07/25.
//

import UIKit
import Cosmos
class CommonRatingCell: UITableViewCell {

    @IBOutlet weak var ratingVw: CosmosView!
    @IBOutlet weak var lbl_Title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbl_Title.font = FontManager.inter(.medium, size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(title:String){
        self.ratingVw.settings.updateOnTouch = false       // 🔒 Disable touch rating
           self.ratingVw.isUserInteractionEnabled = false     // 🔒 Fully disables interaction
        if title == "5 Star"{
            self.ratingVw.rating = 5.0
        }else if title == "4 Star" {
            self.ratingVw.rating = 4.0
        }else if title == "3 Star" {
            self.ratingVw.rating = 3.0
        }else if title == "2 Star" {
            self.ratingVw.rating = 2.0
        }else if title == "1 Star" {
            self.ratingVw.rating = 1.0
        }else{
            self.ratingVw.isHidden = true
        }
    }
    
    
}
