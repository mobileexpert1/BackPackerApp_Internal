//
//  SceneDelegate.swift
//  Backpacker
//
//  Created by Mobile on 02/07/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.setRoot()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    private func setRoot(){
        let hasSeenWalkthrough = UserDefaults.standard.bool(forKey: "hasSeenWalkthrough")
        // Grab stored values from UserDefaultsManager
#if BackpackerHire
        let userId = UserDefaultsManager.shared.employeruserId
let accessToken = UserDefaultsManager.shared.employerbearerToken
#else
let userId = UserDefaultsManager.shared.userId
let accessToken = UserDefaultsManager.shared.bearerToken
#endif

        
        // Decide which screen to show
        let rootVC: UIViewController

        if !hasSeenWalkthrough {
            // First-time launch → Show Walkthrough screen
            let storyboard = UIStoryboard(name: "WalkThrough", bundle: nil)
            rootVC = storyboard.instantiateViewController(withIdentifier: "WalkThoroughVC")
        } else if userId?.isEmpty != false || accessToken?.isEmpty != false {
            // Not logged in (either userId or token is nil or empty) → Show Login
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            let navController = UINavigationController(rootViewController: loginVC)
            navController.navigationBar.isHidden = true
            rootVC = navController
        } else {
            // Logged in → Go to MainTabBarController
#if BackpackerHire
            let role =  UserDefaults.standard.string(forKey: "UserRoleType")
             if role != "2" && role != "3" && role != "4"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let chooseRoleVC = storyboard.instantiateViewController(withIdentifier: "ChooseRoleTypeVC") as? ChooseRoleTypeVC {
                    chooseRoleVC.isBackButtonHidden = true
                    rootVC = chooseRoleVC
                } else {
                    rootVC = UIViewController() // fallback if casting fails
                }
                
            }else{
                let storyboard = UIStoryboard(name: "MainTabBarEmpStoryboard", bundle: nil)
                rootVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarEmpController")
            }
            
            #else
            let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
            rootVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            
#endif
            
        }

        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    // SceneDelegate.swift
    // MARK: - Scene Lifecycle
       func sceneDidBecomeActive(_ scene: UIScene) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           if appDelegate.isComeFromNotification,
              let jobId = appDelegate.pendingNotificationJobId,
              let appType = appDelegate.pendingAppType {
               
               print("⚡ Scene active with pending notification: \(jobId) \(appType)")
               
               // -Small delay so rootVC is stable
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   appDelegate.handleNotification(jobId: jobId, appType: appType)
               }
               
               // Reset
               appDelegate.isComeFromNotification = false
               appDelegate.pendingNotificationJobId = nil
               appDelegate.pendingAppType = nil
           }
       }



    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    // MARK: - Notification Handling (iOS 13+ cold start)
       private func handleNotificationFromResponse(_ response: UNNotificationResponse) {
           let userInfo = response.notification.request.content.userInfo
           if let jobId = userInfo["jobId"] as? String,
              let appType = userInfo["appType"] as? String {
               
               print("📩 Cold launch via SceneDelegate: \(jobId) \(appType)")
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                   (UIApplication.shared.delegate as? AppDelegate)?
                       .handleNotification(jobId: jobId, appType: appType)
               }
           }
       }

}

import UIKit

extension SceneDelegate {
    static func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate,
              let window = delegate.window else { return }

#if BackpackerHire
        UserDefaultsManager.shared.employerbearerToken = nil
        UserDefaultsManager.shared.employerrefreshToken = nil
        UserDefaultsManager.shared.userId = nil
        
#else
        UserDefaultsManager.shared.bearerToken = nil
        UserDefaultsManager.shared.refreshToken = nil
        
        UserDefaultsManager.shared.employeruserId = nil
#endif
       
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
