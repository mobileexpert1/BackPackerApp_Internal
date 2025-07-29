//
//  MainTabBarEmpController.swift
//  BackpackerHire
//
//  Created by Mobile on 22/07/25.
//

import Foundation
//
//  MainTabBarController.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import UIKit

class MainTabBarEmpController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabsForUserRole()
    }
    
    private func setupTabsForUserRole() {
        let role = UserDefaults.standard.integer(forKey: "UserRoleType")
        
        var viewControllers: [UIViewController] = []
        
        switch role {
        case 2: // Employer
            viewControllers = [
                createTab(fromStoryboard: "EmployerHome", identifier: "EmployerHomeVC", title: "Home", image: "Home"),
                createTab(fromStoryboard: "Job", identifier: "MainJobController", title: "Jobs", image: "Job Seeker"),
                createTab(fromStoryboard: "Setting", identifier: "SettingVC", title: "Settings", image: "Setting")
            ]
        case 3: // Accommodation
            viewControllers = [
                createTab(fromStoryboard: "EmployerHome", identifier: "EmployerHomeVC", title: "Home", image: "Home"),
                createTab(fromStoryboard: "Accomodation", identifier: "EmployerAccomodationVC", title: "Accommodation", image: "Accommodation"),
                createTab(fromStoryboard: "Setting", identifier: "SettingVC", title: "Settings", image: "Setting")
            ]
        case 4: // Hangout
            viewControllers = [
                createTab(fromStoryboard: "EmployerHome", identifier: "EmployerHomeVC", title: "Home", image: "Home"),
                createTab(fromStoryboard: "HangOut", identifier: "HangOutVC", title: "HangOut", image: "hangout"),
                createTab(fromStoryboard: "Setting", identifier: "SettingVC", title: "Settings", image: "Setting")
            ]
        default:
            print("No valid role found.")
        }
        
        
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
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // Custom pill selection indicator
        let itemCount = CGFloat(viewControllers?.count ?? 1)
        let widthPerItem = tabBar.bounds.width / itemCount
        let height = tabBar.bounds.height
        
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
