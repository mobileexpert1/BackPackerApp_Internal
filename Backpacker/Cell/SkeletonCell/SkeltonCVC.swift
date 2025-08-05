//
//  SkeltonCVC.swift
//  Backpacker
//
//  Created by Mobile on 05/08/25.
//

import UIKit
import SkeletonView
class SkeltonCVC: UICollectionViewCell {

    @IBOutlet weak var min_vw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        min_vw.isSkeletonable = true
           self.isSkeletonable = true

        min_vw.layer.cornerRadius = 10
        min_vw.layer.masksToBounds = true

           let skeletonConfig = SkeletonGradient(baseColor: .clouds)
           let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        min_vw.showAnimatedGradientSkeleton(
               usingGradient: skeletonConfig,
               animation: skeletonAnimation,
               transition: .none
           )
        min_vw.layer.cornerRadius = 10 // Re-apply if overridden
    }

}
