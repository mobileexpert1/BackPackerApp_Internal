//
//  UIView+Gradient.swift
//  Backpacker
//
//  Created by Mobile on 08/07/25.
//

import Foundation
import UIKit
func applyGradientButtonStyle(to button: UIButton,
                              startColor: UIColor = UIColor(hex: "#29A1F8"),
                              endColor: UIColor = UIColor(hex: "#2F7AD1"),
                              cornerRadius: CGFloat = 10,
                              borderColor: UIColor = .white,
                              borderWidth: CGFloat = 1.0,
                              opacity: Float = 1.0,
                              isUserInteractionEnabled: Bool = true) {
    
    // Remove existing gradient layer if any
    button.layer.sublayers?.removeAll(where: { $0.name == "gradientLayer" })
    
    button.layoutIfNeeded()

    // Create and configure gradient layer
    let gradientLayer = CAGradientLayer()
    gradientLayer.name = "gradientLayer"
    gradientLayer.frame = button.bounds
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    gradientLayer.cornerRadius = cornerRadius
    gradientLayer.opacity = opacity

    // Button styling
    button.layer.cornerRadius = cornerRadius
    button.clipsToBounds = true
    button.layer.borderColor = borderColor.cgColor
    button.layer.borderWidth = borderWidth
    button.isUserInteractionEnabled = isUserInteractionEnabled

    button.layer.insertSublayer(gradientLayer, at: 0)
}


extension UIView {
    func addShadowAllSides(
        color: UIColor = .black,
        opacity: Float = 0.2,
        radius: CGFloat = 4,
        offset: CGSize = .zero
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
        // Optional: Improves performance
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    func addShadowBottomOnly(
        color: UIColor = .black,
        opacity: Float = 0.2,
        radius: CGFloat = 4,
        height: CGFloat = 4
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: height)
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        // Only shadow at the bottom
        let shadowRect = CGRect(
            x: 0,
            y: self.bounds.height - height,
            width: self.bounds.width,
            height: height
        )
        self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath

        // Improve performance
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

}
extension UIView {
   
}
