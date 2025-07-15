//
//  UserChatTVC.swift
//  Backpacker
//
//  Created by Mobile on 15/07/25.
//

import UIKit

class UserChatTVC: UITableViewCell {
    @IBOutlet weak var lbl_Tim: UILabel!
    
    @IBOutlet weak var txtMsg: UILabel!
    @IBOutlet weak var chat_Vw: UIView!
    @IBOutlet weak var main_BgVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbl_Tim.font = FontManager.inter(.regular, size: 12.0)
        self.txtMsg.font = FontManager.inter(.regular, size: 14.0)
        chat_Vw.layer.cornerRadius = 12  // Adjust radius as needed
           chat_Vw.layer.maskedCorners = [
               .layerMinXMinYCorner,  // top-left
               .layerMinXMaxYCorner,  // bottom-left
               .layerMaxXMaxYCorner   // bottom-right
           ]
           chat_Vw.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
