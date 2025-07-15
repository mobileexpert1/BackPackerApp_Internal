//
//  NavigationHelper.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import UIKit

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
