//  LoaderManager.swift
//  Backpacker
//  Created by Mobile on 03/07/25.

import Foundation
import UIKit
class LoaderManager {
    
    static let shared = LoaderManager()
    private var spinnerView: UIView?
    private init() {}
    
    private func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func show(on view: UIView? = nil) {
        guard spinnerView == nil else { return }
        
        let loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        
        let targetView = view ?? getKeyWindow()
        
        if let targetView {
            targetView.addSubview(loadingView)
            spinnerView = loadingView
        }
    }
    
    func hide() {
        let keyWindow = getKeyWindow()
        
        if let loadingView = keyWindow?.viewWithTag(999) {
            loadingView.removeFromSuperview()
            spinnerView = nil
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
