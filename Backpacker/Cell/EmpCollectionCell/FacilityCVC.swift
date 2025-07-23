//
//  FacilityCVC.swift
//  BackpackerHire
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class FacilityCVC: UICollectionViewCell {
    @IBOutlet weak var imageVw: UIImageView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUPUI()
    }
    func setUPUI(){
        self.lbl_Title.font = FontManager.inter(.regular, size: 12.0)
    }
    
    func setImageAndTitle(image:String,Title:String){
        self.imageVw.image = UIImage(named: image)
        self.lbl_Title.text = Title
    }
}
