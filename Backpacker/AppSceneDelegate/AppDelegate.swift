//
//  AppDelegate.swift
//  Backpacker
//
//  Created by Mobile on 02/07/25.
//

import UIKit
import CoreData
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestNotificationPermission()    //com.Backpacker
        // Register for remote notifications
        sleep(2)
        CalendarEventManager.shared.requestAccess { granted in
            print(granted ? "✅ Calendar access granted" : "❌ Calendar access denied")
        }
           LocationManager.shared.requestLocationPermission()
           LocationManager.shared.startUpdatingLocation()
        application.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    private func requestNotificationPermission() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if let error = error {
                   print("❌ Notification permission error: \(error)")
               } else if granted {
                   print("✅ Notification permission granted")
                   DispatchQueue.main.async {
                       UIApplication.shared.registerForRemoteNotifications()
                   }
               } else {
                   print("❌ Notification permission denied")
               }
           }
        
       }
 
  
    // MARK: - Core Data Stack
       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "BackPackersModel") // ⚠️ Replace with your actual .xcdatamodeld file name
           container.loadPersistentStores { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("❌ Unresolved error \(error), \(error.userInfo)")
               }
           }
           return container
       }()

       // MARK: - Core Data Save Context
       func saveContext() {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("❌ Save error \(nserror), \(nserror.userInfo)")
               }
           }
       }

}

import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Show notifications even when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Show as banner and play sound
        completionHandler([.banner, .sound])
    }

    // Handle taps on notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("🔔 Notification tapped with info: \(userInfo)")
        
        // Handle navigation or deep linking here if needed
        NotificationManager.shared.handleNotification(userInfo: userInfo)
        completionHandler()
    }
    
    // Called when device token is received
      func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
          let token = tokenParts.joined()
          print("✅ Device Token: \(token)")
          UserDefaultsManager.shared.fcmToken = "hfhfh6576hgf675"
          // Save or send to server
          UserDefaults.standard.set(token, forKey: "device_token")
      }

}

import UIKit

extension UIApplication {
    static func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
