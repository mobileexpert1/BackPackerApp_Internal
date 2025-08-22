//
//  AppDelegate.swift
//  Backpacker
//
//  Created by Mobile on 02/07/25.
//

import UIKit
import CoreData
import UserNotifications
import FirebaseMessaging
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.configureGoogleInfoPlist()
        // Override point for customization after application launch.
        requestNotificationPermission()    //com.Backpacker
        // Register for remote notifications
        sleep(2)
        CalendarEventManager.shared.requestAccess { granted in
            print(granted ? "✅ Calendar access granted" : "❌ Calendar access denied")
        }
           LocationManager.shared.requestLocationPermission()
           LocationManager.shared.startUpdatingLocation()
        Messaging.messaging().delegate = self
        // Setup notifications
            let center = UNUserNotificationCenter.current()
            center.delegate = self
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

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
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
        print("USer Info",userInfo)
        if let jobId = userInfo["jobId"] as? String,
           let appType = userInfo["appType"] as? String,
           let notificationType = userInfo["notificationType"] as? String {
            
            print("📌 jobId: \(jobId), appType: \(appType), notificationType: \(notificationType)")
            
            // 👉 Navigate based on notificationType
           handleNotification(jobId: jobId, appType: appType)
        }
        
        completionHandler()
    }
        func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
        }
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("📲 FCM Token: \(fcmToken ?? "")")
#if BackpackerHire
            UserDefaultsManager.shared.employerfcmToken = fcmToken
#else
            UserDefaultsManager.shared.fcmToken = fcmToken
#endif
            
            
        }
        
        func configureGoogleInfoPlist() {
            var plistName = "GoogleService-Info"
            
#if BackpackerHire
            plistName = "GoogleService-Info-Hire"
#else
            plistName = "GoogleService-Info"
#endif
            
            guard let filePath = Bundle.main.path(forResource: plistName, ofType: "plist"),
                  let options = FirebaseOptions(contentsOfFile: filePath) else {
                fatalError("Couldn't load Firebase config file: \(plistName).plist")
            }
            
            FirebaseApp.configure(options: options)
        }
        
        
    }

    
    extension UIApplication {
        static func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
            guard let window = UIApplication.shared.windows.first else {
                return
            }
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
