//
//  UserDefaultManager.swift
//  Backpacker
//
//  Created by Mobile on 14/07/25.
//

import Foundation
import UIKit
class UserDefaultsManager {

    // MARK: - Keys
    private enum Keys {
        static let fcmToken = "fcmToken"
        static let bearerToken = "bearerToken"
        static let refreshToken = "refreshToken"
        static let userId = "userId"
        static let isLoggedIn = "isLoggedIn"
    }

    // MARK: - Shared Instance
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private init() {}

    // MARK: - FCM Token
    var fcmToken: String? {
        get { defaults.string(forKey: Keys.fcmToken) }
        set { defaults.set(newValue, forKey: Keys.fcmToken) }
    }

    // MARK: - Bearer Token
    var bearerToken: String? {
        get { defaults.string(forKey: Keys.bearerToken) }
        set { defaults.set(newValue, forKey: Keys.bearerToken) }
    }

    // MARK: - Refresh Token
    var refreshToken: String? {
        get { defaults.string(forKey: Keys.refreshToken) }
        set { defaults.set(newValue, forKey: Keys.refreshToken) }
    }

    // MARK: - User ID
    var userId: String? {
        get { defaults.string(forKey: Keys.userId) }
        set { defaults.set(newValue, forKey: Keys.userId) }
    }

    // MARK: - Login State
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Keys.isLoggedIn) }
        set { defaults.set(newValue, forKey: Keys.isLoggedIn) }
    }

    // MARK: - Clear All (e.g. on logout)
    func clearAll() {
        defaults.removeObject(forKey: Keys.fcmToken)
        defaults.removeObject(forKey: Keys.bearerToken)
        defaults.removeObject(forKey: Keys.refreshToken)
        defaults.removeObject(forKey: Keys.userId)
        defaults.removeObject(forKey: Keys.isLoggedIn)
    }
}




func getDeviceInfo() -> DeviceInfo {
    // App version & build
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    
    // OS type detection
    let osType: String = {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return "iPhone"
        case .pad: return "iPad"
        case .tv: return "Apple TV"
        case .mac: return "Mac"
        default: return "Unknown"
        }
    }()
    
    let osVersion = UIDevice.current.systemVersion
    let deviceBrand = "Apple"
    let deviceModel = UIDevice.current.model
    let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"

    return DeviceInfo(
        appVersion: appVersion,
        buildNumber: buildNumber,
        osType: osType,
        osVersion: osVersion,
        deviceBrand: deviceBrand,
        deviceModel: deviceModel,
        deviceId: deviceId
    )
}
struct DeviceInfo {
    let appVersion: String
    let buildNumber: String
    let osType: String
    let osVersion: String
    let deviceBrand: String
    let deviceModel: String
    let deviceId: String
}
