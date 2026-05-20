//  AppDelegate.swift
//  Backpacker
//  Created by Mobile on 02/07/25.

import UIKit
import CoreData
import UserNotifications
import FirebaseMessaging
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var viewModel = LogInVM()
    var isComeFromNotification: Bool = false
    var pendingNotificationJobId: String?
    var pendingNotificationId: String?
    var pendingAppType: String?
    var pendingNotificationType: Int?
    var userInfo: [AnyHashable: Any]?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            UIWindow.appearance().overrideUserInterfaceStyle = .light
        }
        
        self.configureGoogleInfoPlist()
        
        // Set delegates BEFORE requesting permissions
        Messaging.messaging().delegate = self
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // Request notification permission
        requestNotificationPermission()    //com.Backpacker
        
        // Register for remote notifications (already called inside requestNotificationPermission)
        sleep(2)  // optional, left as-is
        CalendarEventManager.shared.requestAccess { granted in
            print(granted ? "-Calendar access granted" : "- Calendar access denied")
        }
        
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.startUpdatingLocation()
        _ = SubscriptionManager.shared // start listener
        // Handle cold-launch notification if exists
        if let remoteNotification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            if let jobId = remoteNotification["jobId"] as? String,
               let appType = remoteNotification["appType"] as? String {
                isComeFromNotification = true
                pendingNotificationJobId = jobId
                pendingAppType = appType
                print("📩 Stored cold-launch notification: \(jobId) \(appType)")
            }
        }
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
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BackPackersModel") //  Replace with your actual .xcdatamodeld file name
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(" Unresolved error \(error), \(error.userInfo)")
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
                fatalError(" Save error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(" Notification permission error: \(error)")
            } else if granted {
                print("Notification permission granted")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied")
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
        let userInfo = notification.request.content.userInfo
        
        // Example: print payload for debugging
        print("Notification UserInfo: \(userInfo)")
        if let  typeRaw = userInfo["notificationType"] as? String {
            if typeRaw == "9" || typeRaw == "8" || typeRaw == "7"{// 
                RefreshChatController(info: userInfo)
            }
        }
        
        completionHandler([.banner, .sound])
    }
    
    // Handle taps on notifications
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(" Notification tapped: \(userInfo)")
        self.userInfo = userInfo
        let jobId = userInfo["jobId"] as? String
        let appType = userInfo["appType"] as? String
        
        let notificationID = userInfo["notificationId"] as? String
        
        let notificationType = userInfo["notificationType"] as? Int
        
        isComeFromNotification = true
        pendingNotificationJobId = jobId
        pendingNotificationId = notificationID
        pendingAppType = appType
        pendingNotificationType = notificationType
        
        NotificationManager.shared.handleNotification(userInfo: userInfo)
        
        completionHandler()
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(" FCM Token: \(fcmToken ?? "")")
#if BackpackerHire
        UserDefaultsManager.shared.employerfcmToken = fcmToken
#else
        UserDefaultsManager.shared.fcmToken = fcmToken
#endif
        
    }
    
    func configureGoogleInfoPlist() {
        var plistName = "GoogleService-Info"
        
#if BackpackerHire
        plistName = "GoogleService-Info_Hire"//"GoogleService-Info-Hire"
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
