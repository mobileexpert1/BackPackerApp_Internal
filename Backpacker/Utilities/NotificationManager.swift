//
//  NotificationManager.swift
//  Backpacker
//
//  Created by Mobile on 21/07/25.
//

import Foundation
import UIKit
enum NotificationCategory {
    case backpackerHire
    case backpacker
    case common
}
/*
 JobAcceptReject = 1,
 JobPost = 2,
 EmployerRating = 3,
 AccountActivation = 4,
 PlacesToStay = 5,
 Promotional = 6,
 AdminChatWithEmployer = 7,
 AdminChatWithBackpacker = 8,
 BackpackerChatWithEmployer = 9,
 AccountDeletion = 10,
 BackpackerRating = 11,
 */

enum NotificationType: String {
    // Employer
    case JobAcceptReject = "1"
    case JobPost = "2"
    case EmployerRating = "3"
    case AccountActivation = "4"
    case PlacesToStay = "5"
    
    // Backpacker
    case Promotional = "6"
    case AdminChatWithEmployer = "7"
    case AdminChatWithBackpacker = "8"
    case BackpackerChatWithEmployer = "9"
    case AccountDeletion = "10"
    case BackpackerRating = "11"
    
    // Categories for grouping
    var category: NotificationCategory {
        switch self {
        case .JobAcceptReject, .EmployerRating:
            return .backpackerHire
        case .JobPost, .AccountActivation, .PlacesToStay, .Promotional, .AccountDeletion, .BackpackerRating:
            return .backpacker
        case .AdminChatWithEmployer, .AdminChatWithBackpacker, .BackpackerChatWithEmployer:
            return .common
        }
    }
}




struct AppNotification {
    let type: NotificationType
    let title: String
    let body: String
    let data: [String: Any]
}

class NotificationManager {
    var viewModel = LogInVM()
    static let shared = NotificationManager()
    private init() {}
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
        guard
            let typeRaw = userInfo["notificationType"] as? String,
            let type = NotificationType(rawValue: typeRaw)
        else {
            print("⚠️ Unknown notification type: \(userInfo["notificationType"] ?? "nil")")
            return
        }
        
        let title = userInfo["title"] as? String ?? "Test"
        let body = userInfo["body"] as? String ?? "You have a new notification"
        let data = userInfo["data"] as? [String: Any] ?? [:]
        
        let notification = AppNotification(type: type, title: title, body: body, data: data)
        
        // Route to the appropriate screen or handler
        route(notification)
    }
    
    
    private func route(_ notification: AppNotification) {
        switch notification.type.category {
        case .backpackerHire:
            handleEmployer(notification)
        case .backpacker:
            handleBackpacker(notification)
        case .common:
            handleCommon(notification)
            
            
        }
    }
    
    private func handleEmployer(_ notification: AppNotification) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if appDelegate.isComeFromNotification,
           let jobId = appDelegate.pendingNotificationJobId,
           let appType = appDelegate.pendingAppType , let notificationID = appDelegate.pendingNotificationId {
            
            print(" Scene active with pending notification: \(jobId) \(appType)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appDelegate.handleNotification(jobId: jobId, appType: appType, notificationId: notificationID)
                
            }
            
            // Reset
            appDelegate.isComeFromNotification = false
            appDelegate.pendingNotificationJobId = nil
            appDelegate.pendingAppType = nil
        }
        
        // e.g., Navigate to job detail or rating screen
    }
    
    private func handleBackpacker(_ notification: AppNotification) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDelegate.isComeFromNotification,
           let jobId = appDelegate.pendingNotificationJobId,
           let appType = appDelegate.pendingAppType , let notificationID = appDelegate.pendingNotificationId {
            print(" Scene active with pending notification: \(jobId) \(appType)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appDelegate.handleNotification(jobId: jobId, appType: appType, notificationId: notificationID)
                
            }
            
            // Reset
            appDelegate.isComeFromNotification = false
            appDelegate.pendingNotificationJobId = nil
            appDelegate.pendingAppType = nil
        }
    }
    
    private func handleCommon(_ notification: AppNotification) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDelegate.isComeFromNotification,
           let appType = appDelegate.pendingAppType , let notificationID = appDelegate.pendingNotificationId {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.handleNavigtaionForChat(info: appDelegate.userInfo!)
                
            }
            
            // Reset
            appDelegate.isComeFromNotification = false
            appDelegate.pendingNotificationJobId = nil
            appDelegate.pendingAppType = nil
            appDelegate.pendingNotificationType = nil
        }
    }
    
    
    
    func handleNavigtaionForChat(info: [AnyHashable:Any]){
        print("User info fro chat notifcation ",info)
        
#if Backapacker
        let notificationId  = info["notificationId"] as? String
        let senderId  = info["senderId"] as? String
        let receiverId  = info["receivers"] as? String
        if let senderId = info["senderId"] as? String, !senderId.isEmpty {
            let notificationId = info["notificationId"] as? String
            let notificationtype = info["notificationType"] as? String
            let ticketId = info["ticketId"] as? String
            let receiverId = info["receivers"] as? String
            
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
                    if tabBarController.selectedIndex != 0 {
                        tabBarController.selectedIndex = 0
                    }
                    
                    if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            
                            if let topVC = navController.topViewController as? BackPackerHomeVC {
                                // Already on JobDescriptionVC → just refresh
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    appDelegate.isComeFromNotification = true
                                }
                                topVC.senderId = senderId
                                topVC.receiverId = receiverId
                                topVC.isComeFromNotification = true
                                if notificationtype == "8"{
                                    topVC.isComeFromAdmin = true
                                    topVC.ticketId = ticketId
                                }else{
                                    topVC.isComeFromAdmin = false
                                }
                                topVC.refreshData()
                            } else  if let topVC = navController.topViewController as? MessageLisVC {
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    appDelegate.isComeFromNotification = true
                                }
                                topVC.senderId = senderId
                                topVC.receiverId = receiverId
                                topVC.isComeFromNotification = true
                                if notificationtype == "8"{
                                    topVC.isComefFromAdmin = true
                                    topVC.ticketId = ticketId
                                }else{
                                    topVC.isComefFromAdmin = false
                                }
                                topVC.refreshData()
                            } else if let topVC = navController.topViewController as? ChatVC {
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    appDelegate.isComeFromNotification = true
                                }
                                topVC.resceiverID  = senderId
                                topVC.refreshData()
                            } else {
                                
                                //  createTab(fromStoryboard: "Home", identifier: "BackPackerHomeVC", title: "Home", image: "Home"),
                                //  Not on JobDescriptionVC → replace stack with JobDescriptionVC
                                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                let detailVC = storyboard.instantiateViewController(withIdentifier: "BackPackerHomeVC") as! BackPackerHomeVC
                                
                                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                    appDelegate.isComeFromNotification = true
                                }
                                detailVC.senderId = senderId
                                detailVC.receiverId = receiverId
                                detailVC.isComeFromNotification = true
                                if notificationtype == "8"{
                                    detailVC.isComeFromAdmin = true
                                    detailVC.ticketId = ticketId
                                }else{
                                    detailVC.isComeFromAdmin = false
                                }
                                
                                //  Replace the navigation stack with only MainJobController
                                navController.setViewControllers([detailVC], animated: false)
                                detailVC.refreshData()
                            }
                        }
                    }
                }
            } else {
                return
            }
        }
        
#else
        if let senderId = info["senderId"] as? String, !senderId.isEmpty {
            let receiverId = info["receivers"] as? String
            let notificationtype = info["notificationType"] as? String
            let ticketId = info["ticketId"] as? String ?? ""
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
                // createTab(fromStoryboard: "EmployerHome", identifier: "EmployerHomeVC", title: "Home", image: "Home"),
                //  Check Role
                if let role = UserDefaults.standard.string(forKey: "UserRoleType") {
                    if role == "2" {
                        if let tabBarController = window.rootViewController as? UITabBarController {
                            // Step 1: Ensure tab is switched to index 2
                            if tabBarController.selectedIndex != 0 {
                                tabBarController.selectedIndex = 0
                            }
                            if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    
                                    if let topVC = navController.topViewController as? EmployerHomeVC {
                                        //  Already on MainJobController → refresh
                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.isComeFromNotification = true
                                        }
                                        topVC.senderId = senderId
                                        topVC.receiverId = receiverId ?? ""
                                        topVC.isComeFromNotification = true
                                        if notificationtype == "7"{
                                            topVC.isComeFromAdmin = true
                                            topVC.ticketId = ticketId
                                        }else{
                                            topVC.isComeFromAdmin = false
                                        }
                                        topVC.refreshData() //  Call your refresh API method here
                                    } else if let topVC = navController.topViewController as? MessageLisVC {
                                        // If currently on JobDescriptionVC → refresh it instead
                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.isComeFromNotification = true
                                        }
                                        topVC.senderId = senderId
                                        topVC.receiverId = receiverId
                                        topVC.isComeFromNotification = true
                                        if notificationtype == "7"{
                                            topVC.isComefFromAdmin = true
                                            topVC.ticketId = ticketId
                                        }else{
                                            topVC.isComefFromAdmin = false
                                        }
                                        topVC.refreshData()
                                    } else if  let topVC = navController.topViewController as? ChatVC  {
                                        //  Otherwise reset stack to MainJobController
                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.isComeFromNotification = true
                                        }
                                        topVC.resceiverID  = senderId
                                        if notificationtype == "7"{
                                            topVC.isComeFromAdmin = true
                                            topVC.ticketId = ticketId
                                        }else{
                                            topVC.isComeFromAdmin = false
                                        }
                                        topVC.refreshData()
                                    }else{
                                        let storyboard = UIStoryboard(name: "EmployerHome", bundle: nil)
                                        let detailVC = storyboard.instantiateViewController(withIdentifier: "EmployerHomeVC") as! EmployerHomeVC
                                        
                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.isComeFromNotification = true
                                        }
                                        detailVC.senderId = senderId
                                        detailVC.receiverId = receiverId ?? ""
                                        detailVC.isComeFromNotification = true
                                        if notificationtype == "7"{
                                            detailVC.isComeFromAdmin = true
                                            detailVC.ticketId = ticketId
                                        }else{
                                            detailVC.isComeFromAdmin = false
                                        }
                                        //  Replace the navigation stack with only MainJobController
                                        navController.setViewControllers([detailVC], animated: false)
                                        detailVC.refreshData()
                                    }
                                }
                            }
                        }
                        
                    } else {
                        // Call API → after success go to MainJobController
                        ChooseRoleTypeApiCall(senderId: senderId, receiverId: receiverId ?? "", ticketId: ticketId, info: info)
                    }
                } else {
                    // No role set yet → fallback → open tab 2 without jobId
                    if let tabBarController = window.rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 1
                    }
                }
            }
        }
        
#endif
        
        
        
        
        
    }
    
    func ChooseRoleTypeApiCall(senderId: String,receiverId:String,ticketId:String,info:[AnyHashable:Any] ) {
        let role = "2"
        let req = ChooseRoleTypeRequest(subRoleType: role)
        let notificationtype = info["notificationType"] as? String
        let ticketId = info["ticketId"] as? String ?? ""
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

                                //  Update the tabs for the new role
                                tabBarController.setupTabsForUserRole()

                                //  Select Employer tab
                                tabBarController.selectedIndex = 0

                                // If you want to push to job detail page
                                if let navController = tabBarController.viewControllers?[0] as? UINavigationController {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        if let topVC = navController.topViewController as? EmployerHomeVC {
                                            //  Already on MainJobController → refresh
                                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                                appDelegate.isComeFromNotification = true
                                            }
                                            topVC.senderId = senderId
                                            topVC.receiverId = receiverId
                                            topVC.isComeFromNotification = true
                                            if notificationtype == "7"{
                                                topVC.isComeFromAdmin = true
                                                topVC.ticketId = ticketId
                                            }else{
                                                topVC.isComeFromAdmin = false
                                            }
                                            topVC.refreshData() //  Call your refresh API method here
                                        }
                                    }
                                }
                            }
                    } else {
                        print("- API responded but failed: \(result?.message ?? "Unknown error")")
                       
                    }
                    
                case .badRequest, .methodNotAllowed, .internalServerError, .unknown:
                    print("- API error: \(result?.message ?? "Something went wrong")")
                    
                    
                case .unauthorized:
                    self.viewModel.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.ChooseRoleTypeApiCall(senderId: senderId, receiverId: receiverId, ticketId: ticketId, info: info) // Retry
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
}



class AppState {
    static let shared = AppState()  // Singleton instance
    
    private init() {} // Prevent external initialization
    
    // Example stored variable
    var selectedJobIndex: Int = 0
}
