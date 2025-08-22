//
//  Ext_AppDelegate.swift
//  Backpacker
//
//  Created by Mobile on 22/08/25.
//

import Foundation
import  UserNotifications
import UIKit
extension AppDelegate {


    
    func handleNotification(jobId: String, appType: String) {
#if Backapacker
        guard !jobId.isEmpty else { return }
         
         if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first {
             
             // ✅ Check bearer token
             if UserDefaultsManager.shared.bearerToken?.isEmpty ?? true {
                 // Token is empty → show LoginVC as root
                 let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                 let nav = UINavigationController(rootViewController: loginVC)
                 nav.navigationBar.isHidden = true
                 UIApplication.setRootViewController(nav)
                 return
             }
             
             // ✅ Token is valid → show JobDescriptionVC inside tab 2
             if let tabBarController = window.rootViewController as? UITabBarController {
                 tabBarController.selectedIndex = 2
                 
                 if let navController = tabBarController.viewControllers?[2] as? UINavigationController {
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
                         let storyboard = UIStoryboard(name: "Job", bundle: nil)
                            let detailVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as! JobDescriptionVC
                            detailVC.JobId = jobId
                            
                                navController.pushViewController(detailVC, animated: true)
                        
                     }
                    
                 }
             }
         }

        
        
        #else
        guard !jobId.isEmpty else { return }
         
         if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first {
             
             // ✅ Check bearer token
             if UserDefaultsManager.shared.bearerToken?.isEmpty ?? true {
                 // Token is empty → show LoginVC as root
                 let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                 let nav = UINavigationController(rootViewController: loginVC)
                 nav.navigationBar.isHidden = true
                 UIApplication.setRootViewController(nav)
                 return
             }
             
             // ✅ Token is valid → show JobDescriptionVC inside tab 2
             
             if let role = UserDefaults.standard.string(forKey: "UserRoleType") {
                 
                 if role == "2"{
                     
                     
                     
                 }
                 
                 
             }
             
             
//             if let tabBarController = window.rootViewController as? UITabBarController {
//                 tabBarController.selectedIndex = 2
//                 
//                 if let navController = tabBarController.viewControllers?[2] as? UINavigationController {
//                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
//                         let storyboard = UIStoryboard(name: "Job", bundle: nil)
//                            let detailVC = storyboard.instantiateViewController(withIdentifier: "JobDescriptionVC") as! JobDescriptionVC
//                            detailVC.JobId = jobId
//                            
//                                navController.pushViewController(detailVC, animated: true)
//                        
//                     }
//                    
//                 }
//             }
         }
        
        
        #endif
   
}

}
