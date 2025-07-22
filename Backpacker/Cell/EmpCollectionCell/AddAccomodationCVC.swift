//
//  AddAccomodationCVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit

class AddAccomodationCVC: UICollectionViewCell {
    @IBOutlet weak var mainBgVw: UIView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var btn_Addacoomodatin: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpFonts()
    }
    private func setUpFonts(){
        self.lbl_Title.font = FontManager.inter(.regular, size: 14.0)
        mainBgVw.layer.cornerRadius = 10.0
        mainBgVw.layer.borderColor = UIColor.black.cgColor
        mainBgVw.layer.borderWidth = 1.0
        
        
    }
}
