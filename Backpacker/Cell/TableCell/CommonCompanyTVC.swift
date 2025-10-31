//
//  CommonCompanyTVC.swift
//  Backpacker
//
//  Created by Mobile on 31/10/25.
//

import UIKit

class CommonCompanyTVC: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var main_Vw: UIView!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_company: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUi()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setUpUi(){
        self.main_Vw.addShadowAllSides(radius:2)
        self.main_Vw.layer.cornerRadius = 10.0
        self.lbl_company.font = FontManager.inter(.semiBold, size: 13.0)
      //  self.lbl_jobsCount.font = FontManager.inter(.semiBold, size: 13.0)
        self.lbl_location.font = FontManager.inter(.regular, size: 13.0)
    }
}
