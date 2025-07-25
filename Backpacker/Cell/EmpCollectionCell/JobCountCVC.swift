//
//  JobCountCVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit

class JobCountCVC: UICollectionViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var mainBgVw: UIView!
    var onAddAccommodationTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFonts()
    }

    private func setUpFonts(){
        self.lbl_Count.font = FontManager.inter(.bold, size: 37.0)
        self.lbl_title.font = FontManager.inter(.regular, size: 14.0)
        mainBgVw.layer.cornerRadius = 10.0
    }
    
    func setUpColors(color:String = "#EAF6FF"){
        mainBgVw.layer.cornerRadius = 10.0
        mainBgVw.backgroundColor = UIColor(hex: color)
    }
}
