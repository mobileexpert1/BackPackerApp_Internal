//
//  EmplyerChatTVC.swift
//  Backpacker
//
//  Created by Mobile on 15/07/25.
//

import UIKit

class EmplyerChatTVC: UITableViewCell {

    @IBOutlet weak var TimeLbl_Height: NSLayoutConstraint!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var txtLbl: UILabel!
    @IBOutlet weak var msgVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbl_Time.font = FontManager.inter(.regular, size: 12.0)
        self.txtLbl.font = FontManager.inter(.regular, size: 14.0)
        msgVw.layer.cornerRadius = 12 // Or any radius you want
        msgVw.layer.maskedCorners = [
            .layerMaxXMinYCorner,  // top-right
            .layerMinXMaxYCorner,  // bottom-left
            .layerMaxXMaxYCorner   // bottom-right
        ]
        msgVw.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func handleApeearcnceForImage(isShow: Bool = true){
//        if isShow  == false {
//            self.imgWidth.constant = 45.0
//            self.TimeLbl_Height.constant = 20.0
//        }else{
//            self.imgWidth.constant = 0.0
//            self.TimeLbl_Height.constant = 0.0
//        }
//       
//    }
    func handleApeearcnceForLblTime(){
        self.TimeLbl_Height.constant = 0.0
    }
//    func handleAppearanceForImage(isShow: Bool) {
//        if isShow  == true {
//            self.imgWidth.constant = 45.0
//            self.TimeLbl_Height.constant = 20.0
//        }else{
//            self.imgWidth.constant = 0.0
//            self.TimeLbl_Height.constant = 0.0
//        }
//        //Latest Comit
//    }
}
