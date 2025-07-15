//
//  FontManager.swift
//  Backpacker
//
//  Created by Mobile on 02/07/25.
//

import Foundation
import UIKit

final class FontManager {
    
    enum PoppinsWeight: String {
        case regular = "Poppins-Regular"
        case medium = "Poppins-Medium"
        case semiBold = "Poppins-SemiBold"
        case bold = "Poppins-Bold"
        case light = "Poppins-Light"
    }
    
    enum InterWeight: String {
        case regular = "Inter28pt-Regular"
        case medium = "Inter28pt-Medium"
        case semiBold = "Inter28pt-SemiBold"
        case bold = "Inter28pt-Bold"
        case light = "Inter28pt-Light"
    }
    
    static func poppins(_ weight: PoppinsWeight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func inter(_ weight: InterWeight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    
    func applyGradientButtonStyle(to button: UIButton,
                                  startColor: UIColor = UIColor(hex: "#29A1F8"),
                                  endColor: UIColor = UIColor(hex: "#2F7AD1"),
                                  cornerRadius: CGFloat = 10,
                                  borderColor: UIColor = .white,
                                  borderWidth: CGFloat = 1.0) {

        // Remove any existing gradient
        button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius

        // Apply corner radius & border to button itself
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = borderWidth

        button.layer.insertSublayer(gradientLayer, at: 0)
    }
}
