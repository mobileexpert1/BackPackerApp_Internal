//
//  EmployerJobTVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit

class EmployerJobTVC: UITableViewCell {

    @IBOutlet weak var lbl_Duration: UILabel!
    @IBOutlet weak var dutationVw: UIView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var IMGVW: UIImageView!
    @IBOutlet weak var mainBGVW: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   

       private func setupFonts() {
           // Customize fonts according to your design system
           lbl_Title.font = FontManager.inter(.medium, size: 14.0)
           lblSubTitle.font =  FontManager.inter(.regular, size: 10.0)
           lbl_Duration.font =  FontManager.inter(.regular, size: 10.0)
           mainBGVW.addShadowAllSides(radius:2.0)
       }
}
