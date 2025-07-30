//
//  NavigationHelper.swift
//  Backpacker
//
//  Created by Mobile on 30/07/25.
//

import Foundation
import UIKit

class NavigationHelper {
    
    static func showLoginRedirectAlert(on viewController: UIViewController, message: String) {
        AlertManager.showSingleButtonAlert(on: viewController, message: message) {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
            let nav = UINavigationController(rootViewController: loginVC)
            nav.navigationBar.isHidden = true
            UIApplication.setRootViewController(nav)
        }
    }
     
}
extension UIViewController {
    func push<T: UIViewController>(
        _ type: T.Type,
        fromStoryboard name: String,
        identifier: String,
        configure: ((T) -> Void)? = nil
    ) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            configure?(viewController)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
