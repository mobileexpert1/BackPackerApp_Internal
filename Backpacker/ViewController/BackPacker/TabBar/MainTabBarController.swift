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
           self.delegate = self
           setupTabsForUserRole()
           configureTabBarAppearance()
       }

       private func setupTabsForUserRole() {
           let role = UserDefaults.standard.string(forKey: "UserRoleType")

           var viewControllers: [UIViewController] = []
           viewControllers = [
               createTab(fromStoryboard: "Home", identifier: "BackPackerHomeVC", title: "Home", image: "Home"),
               createTab(fromStoryboard: "Accomodation", identifier: "EmployerAccomodationVC", title: "Accommodation", image: "Accommodation"),
               createTab(fromStoryboard: "Job", identifier: "MainJobController", title: "Jobs", image: "Job Seeker"),
               createTab(fromStoryboard: "HangOut", identifier: "HangOutVC", title: "HangOut", image: "hangout"),
               createTab(fromStoryboard: "Setting", identifier: "SettingVC", title: "Settings", image: "Setting")
           ]
           self.viewControllers = viewControllers
       }

    private func createTab(fromStoryboard name: String, identifier: String, title: String, image: String) -> UINavigationController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.title = title
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(named: image )
        return nav
    }


    private func configureTabBarAppearance() {
        let tabBar = self.tabBar

        let tabBarWidth = tabBar.bounds.width
        let tabBarHeight = tabBar.bounds.height
        let itemCount = CGFloat(viewControllers?.count ?? 1)

        guard tabBarWidth > 0, tabBarHeight > 0,
              tabBarWidth.isFinite, tabBarHeight.isFinite,
              itemCount > 0 else {
            print("❌ Invalid tabBar layout: width = \(tabBarWidth), height = \(tabBarHeight)")
            return
        }

        let widthPerItem = tabBarWidth / itemCount
        let height = tabBarHeight

        // Create selection indicator image using UIGraphicsImageRenderer
        let size = CGSize(width: widthPerItem, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        let pillImage = renderer.image { context in
            let pillW: CGFloat = 40
            let pillH: CGFloat = 40
            let pillX = (widthPerItem - pillW) / 2
            let pillY = (height - pillH) / 2
            let pillRect = CGRect(x: pillX, y: pillY, width: pillW, height: pillH)

            let path = UIBezierPath(roundedRect: pillRect, cornerRadius: 10)
            UIColor.systemPurple.withAlphaComponent(0.3).setFill()
            path.fill()
        }.resizableImage(withCapInsets: .zero)

        // Set up tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.selectionIndicatorImage = pillImage

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: FontManager.inter(.regular, size: 10.0),
            .foregroundColor: UIColor.black
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: FontManager.inter(.regular, size: 10.0),
            .foregroundColor: UIColor(red: 0, green: 0.71, blue: 0.83, alpha: 1)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0, green: 0.71, blue: 0.83, alpha: 1)

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = UIColor(red: 0, green: 0.71, blue: 0.83, alpha: 1)
        tabBar.unselectedItemTintColor = .black
    }

       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           configureTabBarAppearance()
       }
}
