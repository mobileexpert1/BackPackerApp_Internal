//
//  CommonImageCell.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import UIKit

class CommonImageCell: UICollectionViewCell {

    @IBOutlet weak var Btn_Fav: UIButton!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var Bg_FavVw: UIView!
    @IBOutlet weak var img_Vw: UIImageView!
    @IBOutlet weak var Bg_Vw: UIView!
    var  isComeFromHangout : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Any styling if needed
        Bg_Vw.layer.cornerRadius = 8
        Bg_Vw.clipsToBounds = true
        if isComeFromHangout == true{
            img_Vw.image = UIImage(named: "restaurantImg") // fallback
        }else{
            img_Vw.image = UIImage(named: "aCCOMODATION") // fallback
        }
    }

    func setImage(with imageURL: String, isFavorite: Bool) {
        // Load image from URL string (you can use Kingfisher or SDWebImage)
        if let url = URL(string: imageURL) {
            // Example using native URLSession (for simplicity)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.img_Vw.image = image
                    }
                }
            }
        } else {
            if isComeFromHangout == true{
                img_Vw.image = UIImage(named: "restaurantImg") // fallback
            }else{
                img_Vw.image = UIImage(named: "aCCOMODATION") // fallback
            }
           
        }

        // Set favorite heart image
        let heartImage = isFavorite ? UIImage(named: "Heart") : UIImage(named: "ic_heart_unfilled")
        imgHeart.image = heartImage
    }
}
