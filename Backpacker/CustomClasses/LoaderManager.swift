//
//  LoaderManager.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import UIKit

class LoaderManager {

    static let shared = LoaderManager()
    private var spinner: UIActivityIndicatorView?

    private init() {}

    func show(on view: UIView? = nil) {
        guard spinner == nil else { return }

        let loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.3)

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)

        if let targetView = view ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            targetView.addSubview(loadingView)
            spinner = activityIndicator
            spinner?.superview?.tag = 999 // tag to identify and remove later
        }
    }

    func hide() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let loadingView = window.viewWithTag(999) {
            loadingView.removeFromSuperview()
            spinner = nil
        }
    }
}

extension UIApplication {
    static func showOfflineAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Get top-most presented view controller
        var topVC = rootVC
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        topVC.present(alert, animated: true, completion: nil)
    }
}
