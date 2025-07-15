//
//  AlertManager.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import UIKit

class AlertManager {

    static func showAlert(on viewController: UIViewController,
                          title: String,
                          message: String,
                          buttonTitle: String = "OK",
                          completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Apply font to message
              let messageAttr = NSAttributedString(string: message, attributes: [
                .font: FontManager.inter(.regular, size: 14.0),
                  .foregroundColor: UIColor.black.withAlphaComponent(0.7)
              ])
              alert.setValue(messageAttr, forKey: "attributedMessage")

              let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
                  completion?()
              }

        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }

    static func showConfirmationAlert(on viewController: UIViewController,
                                      title: String,
                                      message: String,
                                      confirmTitle: String = "Yes",
                                      cancelTitle: String = "No",
                                      confirmAction: @escaping () -> Void,
                                      cancelAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let messageAttr = NSAttributedString(string: message, attributes: [
                    .font: FontManager.inter(.regular, size: 14.0),
                    .foregroundColor:UIColor.black.withAlphaComponent(0.7)
                ])
                alert.setValue(messageAttr, forKey: "attributedMessage")

        
        
        let yesAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmAction()
        }
        
        let noAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showSingleButtonAlert(on viewController: UIViewController,
                                      title: String? = nil,
                                      message: String,
                                      buttonTitle: String = "OK",
                                      font: UIFont = FontManager.inter(.regular, size: 14.0),
                                      action: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Set attributed message
        let messageFont = [NSAttributedString.Key.font: font,
                           NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)]
        let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            action?()
        }
        
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }


}
