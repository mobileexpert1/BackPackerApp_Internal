//
//  SkeltonTVC.swift
//  Backpacker
//
//  Created by Mobile on 05/08/25.
//

import UIKit
import SkeletonView
class SkeltonTVC: UITableViewCell {

    @IBOutlet weak var main_Vw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        main_Vw.isSkeletonable = true
           self.isSkeletonable = true

           main_Vw.layer.cornerRadius = 10
           main_Vw.layer.masksToBounds = true 

           let skeletonConfig = SkeletonGradient(baseColor: .clouds)
           let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
           main_Vw.showAnimatedGradientSkeleton(
               usingGradient: skeletonConfig,
               animation: skeletonAnimation,
               transition: .none
           )
           main_Vw.layer.cornerRadius = 10 // Re-apply if overridden
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
