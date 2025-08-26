//
//  NotificationModel.swift
//  Backpacker
//
//  Created by Mobile on 26/08/25.
//

import Foundation

// MARK: - Notification Response
struct NotificationResponse: Codable {
    let success: Bool
    let message: String
    let data: NotificationData?
    let errors: [String]?
}

// MARK: - Notification Data
struct NotificationData: Codable {
    let notificationList: [NotificationItems]?
    let page: Int?
    let perPage: Int?
    let totalPages: Int?
    let total: Int?
}

// MARK: - Notification Item
struct NotificationItems: Codable {
    let id: String
    let title: String?
    let message: String?
    let notificationTypeId: Int?
    let senderId: String?
    let redirectId: String?
    let createdAt: String?
    let readStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case message
        case notificationTypeId
        case senderId
        case redirectId
        case createdAt
        case readStatus
    }
}
