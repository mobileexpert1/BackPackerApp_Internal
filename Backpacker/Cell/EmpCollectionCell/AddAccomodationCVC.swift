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
    // Closure to notify controller
#if BackpackerHire
    var onAddAccommodationTapped: (() -> Void)?
#endif
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpFonts()
        // Set up button action
#if BackpackerHire
        btn_Addacoomodatin.addTarget(self, action: #selector(addAccommodationButtonTapped), for: .touchUpInside)
#endif
               
           }
    private func setUpFonts(){
        self.lbl_Title.font = FontManager.inter(.regular, size: 14.0)
        mainBgVw.layer.cornerRadius = 10.0
        mainBgVw.layer.borderColor = UIColor.black.cgColor
        mainBgVw.layer.borderWidth = 1.0
        
        
    }
    @objc private func addAccommodationButtonTapped() {
            onAddAccommodationTapped?()
        }
   
}
