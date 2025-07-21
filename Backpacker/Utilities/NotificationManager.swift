//
//  NotificationManager.swift
//  Backpacker
//
//  Created by Mobile on 21/07/25.
//

import Foundation

enum NotificationCategory {
    case backpackerHire
    case backpacker
    case common
}

enum NotificationType: String {
    
    // Employer
    case jobPost
    case accept
    case decline
    case report
    case employerRating

    // Backpacker
    case applyPlaceToStay
    case acceptDeclineStay
    case acceptJob
    case jobPosted
    case premiumEmployerHired
    case newJob
    case backpackerChat
    case backpackerDecline
    case backpackerActivate
    case backpackerRating

    // Common
    case commonChat

    var category: NotificationCategory {
        switch self {
        case .jobPost, .accept, .decline, .report, .employerRating:
            return .backpackerHire
        case .applyPlaceToStay, .acceptDeclineStay, .acceptJob, .jobPosted,
             .premiumEmployerHired, .newJob, .backpackerChat,
             .backpackerDecline, .backpackerActivate, .backpackerRating:
            return .backpacker
        case .commonChat:
            return .common
        }
    }

    var description: String {
        switch self {
        case .jobPost: return "Job Posted"
        case .accept: return "Job Accepted"
        case .decline: return "Job Declined"
        case .report: return "Reported by User"
        case .employerRating: return "Employer Rating Received"

        case .applyPlaceToStay: return "Applied for Place to Stay"
        case .acceptDeclineStay: return "Stay Request Responded"
        case .acceptJob: return "Job Accepted by Backpacker"
        case .jobPosted: return "Job Posted by Employer"
        case .premiumEmployerHired: return "Hired by Premium Employer"
        case .newJob: return "New Job Notification"
        case .backpackerChat: return "Chat from Employer"
        case .backpackerDecline: return "Backpacker Declined"
        case .backpackerActivate: return "Backpacker Activated"
        case .backpackerRating: return "Backpacker Rating Received"

        case .commonChat: return "New Chat Message"
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

    static let shared = NotificationManager()
    private init() {}

    func handleNotification(userInfo: [AnyHashable: Any]) {
        guard
            let typeRaw = userInfo["type"] as? String,
            let type = NotificationType(rawValue: typeRaw)
        else {
            print("⚠️ Unknown notification type: \(userInfo["type"] ?? "nil")")
            return
        }

        let title = userInfo["title"] as? String ?? type.description
        let body = userInfo["body"] as? String ?? "You have a new notification"
        let data = userInfo["data"] as? [String: Any] ?? [:]

        let notification = AppNotification(type: type, title: title, body: body, data: data)

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
        print("BackpackerHire - \(notification.type.description): \(notification.body)")
        // e.g., Navigate to job detail or rating screen
    }

    private func handleBackpacker(_ notification: AppNotification) {
        print("Backpacker - \(notification.type.description): \(notification.body)")
        // e.g., Navigate to chat, job page, etc.
    }

    private func handleCommon(_ notification: AppNotification) {
        print("🔔 Common - \(notification.type.description): \(notification.body)")
        // e.g., Show chat screen
    }
}

