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
             
             // -Check bearer token
             if UserDefaultsManager.shared.bearerToken?.isEmpty ?? true {
                 // Token is empty → show LoginVC as root
                 let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                 let nav = UINavigationController(rootViewController: loginVC)
                 nav.navigationBar.isHidden = true
                 UIApplication.setRootViewController(nav)
                 return
             }

             if let tabBarController = window.rootViewController as? UITabBarController {
                 
                 // Step 1: Ensure tab is switched to index 2
                 if tabBarController.selectedIndex != 2 {
                     tabBarController.selectedIndex = 2
                 }
                 
                 if let navController = tabBarController.viewControllers?[2] as? UINavigationController {
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                         
                         if let topVC = navController.topViewController as? JobDescriptionVC {
                             // Already on JobDescriptionVC → just refresh
                             topVC.JobId = jobId
                             if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                 appDelegate.isComeFromNotification = true
                             }
                             topVC.refreshData()
                         } else  if let topVC = navController.topViewController as? MainJobController {
                             if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                 appDelegate.isComeFromNotification = true
                             }
                             topVC.JobId = jobId
                             topVC.isComeFromNotification = true
                             AppState.shared.selectedJobIndex = 0
                             topVC.refreshData()
                         } else {
                             //  Not on JobDescriptionVC → replace stack with JobDescriptionVC
                             let storyboard = UIStoryboard(name: "Job", bundle: nil)
                             let detailVC = storyboard.instantiateViewController(withIdentifier: "MainJobController") as! MainJobController
                             detailVC.JobId = jobId
                             if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                 appDelegate.isComeFromNotification = true
                             }
                             AppState.shared.selectedJobIndex = 0
                             
                             //  Replace the navigation stack with only MainJobController
                             navController.setViewControllers([detailVC], animated: false)
                         }
                     }
                 }
             }

         }

        
        
        #else
        guard !jobId.isEmpty else { return }

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            
            //  Check bearer token
            if UserDefaultsManager.shared.employerbearerToken?.isEmpty ?? true {
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                let nav = UINavigationController(rootViewController: loginVC)
                nav.navigationBar.isHidden = true
                UIApplication.setRootViewController(nav)
                return
            }
            
            //  Check Role
            if let role = UserDefaults.standard.string(forKey: "UserRoleType") {
                if role == "2" {
                    if let tabBarController = window.rootViewController as? UITabBarController {
                        // Step 1: Ensure tab is switched to index 2
                        if tabBarController.selectedIndex != 1 {
                            tabBarController.selectedIndex = 1
                        }
                        if let navController = tabBarController.viewControllers?[1] as? UINavigationController {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                                if let topVC = navController.topViewController as? MainJobController {
                                    //  Already on MainJobController → refresh
                                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                        appDelegate.isComeFromNotification = true
                                    }
                                    topVC.JobId = jobId
                                    topVC.isComeFromNotification = true
                                    AppState.shared.selectedJobIndex = 0
                                    topVC.refreshData() //  Call your refresh API method here
                                } else if let topVC = navController.topViewController as? JobDescriptionVC {
                                    // If currently on JobDescriptionVC → refresh it instead
                                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                        appDelegate.isComeFromNotification = true
                                    }
                                    topVC.JobId = jobId
                                    topVC.refreshData()
                                } else {
                                    //  Otherwise reset stack to MainJobController
                                    let storyboard = UIStoryboard(name: "Job", bundle: nil)
                                    let detailVC = storyboard.instantiateViewController(withIdentifier: "MainJobController") as! MainJobController
                                    detailVC.JobId = jobId
                                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                        appDelegate.isComeFromNotification = true
                                    }
                                    AppState.shared.selectedJobIndex = 0
                                    
                                    //  Replace the navigation stack with only MainJobController
                                    navController.setViewControllers([detailVC], animated: false)
                                }
                            }
                        }
                    }

                } else {
                    // Call API → after success go to MainJobController
                    ChooseRoleTypeApiCall(jobID: jobId)
                }
            } else {
                // No role set yet → fallback → open tab 2 without jobId
                if let tabBarController = window.rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 1
                }
            }
        }
        #endif
   
}

    private func ChooseRoleTypeApiCall(jobID: String) {
        let role = "2"
        let req = ChooseRoleTypeRequest(subRoleType: role)
        
        viewModel.chooseRoleType(otpRequest: req) { success, result, statusCode in
            guard let statusCode = statusCode else { return }
            let httpStatus = HTTPStatusCode(rawValue: statusCode)
            
            DispatchQueue.main.async {
                switch httpStatus {
                case .ok, .created:
                    if ((result?.success) != nil) == true {
                            UserDefaults.standard.set("2", forKey: "UserRoleType")

                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = scene.windows.first,
                               let tabBarController = window.rootViewController as? MainTabBarEmpController {

                                // 🔄 Update the tabs for the new role
                                tabBarController.setupTabsForUserRole()

                                // 👇 Select Employer tab
                                tabBarController.selectedIndex = 1

                                // If you want to push to job detail page
                                if let navController = tabBarController.viewControllers?[1] as? UINavigationController {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        let jobStoryboard = UIStoryboard(name: "Job", bundle: nil)
                                        if let detailVC = jobStoryboard.instantiateViewController(withIdentifier: "MainJobController") as? MainJobController {
                                            detailVC.JobId = jobID
                                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                                appDelegate.isComeFromNotification = true
                                            }
                                            navController.setViewControllers([detailVC], animated: false)
                                        }
                                    }
                                }
                            }
                    } else {
                        print("- API responded but failed: \(result?.message ?? "Unknown error")")
                        self.navigateToSecondTabWithoutJob()
                    }
                    
                case .badRequest, .methodNotAllowed, .internalServerError, .unknown:
                    print("- API error: \(result?.message ?? "Something went wrong")")
                    self.navigateToSecondTabWithoutJob()
                    
                case .unauthorized:
                    self.viewModel.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.ChooseRoleTypeApiCall(jobID: jobID) // Retry
                        } else {
                            self.showLogin()
                        }
                    }
                    
                case .unauthorizedToken:
                    self.showLogin()
                }
            }
        }
    }

    // MARK: - Helper Fallbacks
    private func navigateToSecondTabWithoutJob() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }

    private func showLogin() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        let nav = UINavigationController(rootViewController: loginVC)
        nav.navigationBar.isHidden = true
        UIApplication.setRootViewController(nav)
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
}
