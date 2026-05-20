//  CommonImageCell.swift
//  Backpacker
//  Created by Mobile on 01/08/25.

import UIKit

class CommonImageCell: UICollectionViewCell {
    
    @IBOutlet weak var Btn_Fav: UIButton!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var Bg_FavVw: UIView!
    @IBOutlet weak var img_Vw: UIImageView!
    @IBOutlet weak var Bg_Vw: UIView!
    
    var  isComeFromHangout : Bool = false
    // Closure that passes Int (0 or 1)
    var onFavoriteStatusChange: ((Int) -> Void)?
    var fav : Bool = false
    var indexpathItem : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Any styling if needed
        Bg_Vw.layer.cornerRadius = 8
        Bg_Vw.clipsToBounds = true
        if isComeFromHangout == true{
            img_Vw.image = UIImage(named: "restaurantImg") // fallback
        } else {
            img_Vw.image = UIImage(named: "aCCOMODATION") // fallback
        }
        self.Bg_Vw.addShadowAllSides(radius: 0.5)
        self.img_Vw.layer.cornerRadius = 10.0
    }
    
    func setImage(with imageURL: String, isFavorite: Bool) {
        
        // Set favorite heart image
        let heartImage = isFavorite ? UIImage(named: "Heart") : UIImage(named: "ic_heart_unfilled")
        self.fav = isFavorite
#if Backapacker
        imgHeart.image =  heartImage
#else
        imgHeart.image =   UIImage(named: "")//heartImage
#endif
        
    }
    
    @IBAction func btn_favAction(_ sender: Any) {
        onFavoriteStatusChange?(indexpathItem ?? 0) // 0 = non-favorite
    }
}
