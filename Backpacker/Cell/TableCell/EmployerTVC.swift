//
//  EmployerTVC.swift
//  Backpacker
//
//  Created by Mobile on 15/07/25.
//

import UIKit

class EmployerTVC: UITableViewCell {

    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet weak var lbl_SeenTime: UILabel!
    @IBOutlet weak var lbl_Subheader: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetUpFonts(){
        self.lblHeader.font = FontManager.poppins(.semiBold, size: 18.0)
        self.lbl_Subheader.font = FontManager.poppins(.semiBold, size: 16.0)
        self.lbl_SeenTime.font = FontManager.poppins(.regular, size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
