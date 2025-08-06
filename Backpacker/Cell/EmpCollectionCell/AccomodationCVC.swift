//
//  AccomodationCVC.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import UIKit
import Cosmos
import SDWebImage
class AccomodationCVC: UICollectionViewCell {
    
    @IBOutlet weak var btn_Heart: UIButton!
    @IBOutlet weak var heartVw: UIView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var cosmosVw: CosmosView!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var imgNgVw: UIView!
    @IBOutlet weak var mainVw: UIView!
    
    
    
    var onHeartTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
    }
    
    private func setupFonts() {
        btn_Heart.tag = 0
        // Customize fonts according to your design system
        lbl_Title.font = FontManager.inter(.semiBold, size: 12.0)
        lblRating.font =  FontManager.inter(.regular, size: 10.0)
        lbl_review.font =  FontManager.inter(.regular, size: 10.0)
        lblAmount.font =  FontManager.inter(.medium, size: 10.0)
        self.imgNgVw.addShadowAllSides(radius: 0.5)
    }
    /// Configure cell with values
    func configureCell(title: String, rating: Double, reviewCount: Int,amount: Int) {
        lbl_Title.text = title
        lblRating.text = "\(rating)"
        lbl_review.text = "(\(reviewCount) reviews)"
        cosmosVw.rating = rating
        lblAmount.text = "From $,\(amount) per adult"
    }
    @objc private func heartTapped() {
        onHeartTapped?()
    }
    
}
