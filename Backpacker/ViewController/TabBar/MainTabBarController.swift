//
//  MainTabBarController.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
            super.viewDidLoad()
            configureTabBarAppearance()
        }


    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // ← Set this to white (or replace with your asset name)
        appearance.backgroundColor = .white

        // draw a 40×40 pill with corner radius 10
        let itemCount    = CGFloat(viewControllers?.count ?? 1)
        let widthPerItem = tabBar.bounds.width / itemCount
        let height       = tabBar.bounds.height

        UIGraphicsBeginImageContextWithOptions(CGSize(width: widthPerItem, height: height), false, 0)
        let pillW: CGFloat = 40
        let pillH: CGFloat = 40
        let pillX = (widthPerItem - pillW) / 2
        let pillY = (height - pillH) / 2
        let pillRect = CGRect(x: pillX, y: pillY, width: pillW, height: pillH)

        let path = UIBezierPath(roundedRect: pillRect, cornerRadius: 10)
        UIColor.systemPurple.withAlphaComponent(0.3).setFill()
        path.fill()
        let pillImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: .zero)
        UIGraphicsEndImageContext()

        appearance.selectionIndicatorImage = pillImage
        appearance.stackedLayoutAppearance.normal.titleTextAttributes   = [.font: FontManager.inter(.regular,size: 12.0),.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)  ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0, green: 0.7098039216, blue: 0.8352941176, alpha: 1)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0, green: 0.71, blue: 0.83, alpha: 1)

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor             = #colorLiteral(red: 0, green: 0.7098039216, blue: 0.8352941176, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

       // in case the bar’s size changes (e.g. on rotation), regenerate the indicator
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           configureTabBarAppearance()
       }
       

}
import UIKit

class RoundedTabBar: UITabBar {
    private var highlightLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        drawRoundedRectAroundSelectedIcon()
    }

    private func drawRoundedRectAroundSelectedIcon() {
        // 1. Remove any existing highlight
        highlightLayer?.removeFromSuperlayer()

        // 2. Locate selected index
        guard
            let items    = items,
            let selected = selectedItem,
            let index    = items.firstIndex(of: selected)
        else { return }

        // 3. Grab the UIControl buttons, sorted left→right
        let buttons = subviews
            .filter { $0 is UIControl }
            .sorted { $0.frame.minX < $1.frame.minX }
        guard index < buttons.count else { return }
        let button = buttons[index]

        // 4. Find the icon’s UIImageView (fallback to the button itself)
        let iconView = button.subviews.compactMap { $0 as? UIImageView }.first ?? button

        // 5. Convert its center into tabBar’s coordinate space
        let center = convert(iconView.center, from: button)

        // 6. Build a 40×40 rounded‑rect centered on that point
        let rectWidth: CGFloat  = 45
         let rectHeight: CGFloat = 25
         let rect = CGRect(
             x: center.x - rectWidth/2,
             y: center.y - rectHeight/2,
             width: rectWidth,
             height: rectHeight
         )
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 12)

        // 7. Create & configure the shape layer
        let shape = CAShapeLayer()
        shape.path        = path.cgPath
        shape.fillColor   = UIColor.clear.cgColor
        shape.strokeColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        shape.lineWidth   = 1.05
        // ensure it’s above the icon
        shape.zPosition   = .greatestFiniteMagnitude

        // 8. Add it on top
        layer.addSublayer(shape)
        highlightLayer = shape
    }
}
