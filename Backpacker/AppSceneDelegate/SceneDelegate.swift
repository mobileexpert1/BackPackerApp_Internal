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
        let userId = UserDefaultsManager.shared.userId
        let accessToken = UserDefaultsManager.shared.bearerToken

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
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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


}

import UIKit

extension SceneDelegate {
    static func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate,
              let window = delegate.window else { return }

        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
