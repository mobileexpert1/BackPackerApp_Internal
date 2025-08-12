//
//  CompanyDetailTVC.swift
//  BackpackerHire
//
//  Created by Mobile on 12/08/25.
//

import UIKit

class CompanyDetailTVC: UITableViewCell {

    @IBOutlet weak var main_Vw: UIView!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var title_Location: UILabel!
    @IBOutlet weak var lbl_jobsCount: UILabel!
    @IBOutlet weak var title_ActiveJobs: UILabel!
    @IBOutlet weak var btn_More: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.main_Vw.addShadowAllSides(radius:2)
        self.main_Vw.layer.cornerRadius = 10.0
        self.lbl_Location.font = FontManager.inter(.semiBold, size: 13.0)
        self.lbl_jobsCount.font = FontManager.inter(.semiBold, size: 13.0)
        self.title_Location.font = FontManager.inter(.regular, size: 13.0)
        self.title_ActiveJobs.font = FontManager.inter(.regular, size: 13.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
