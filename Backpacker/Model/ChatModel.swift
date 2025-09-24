//
//  ChatModel.swift
//  Backpacker
//
//  Created by Mobile on 15/09/25.
//

import Foundation
import Foundation

// MARK: - EmployerListResponse
import Foundation

// MARK: - EmployerListResponse
struct EmployerChatListResponse: Codable {
    let success: Bool
    let message: String
    let data: EmployerChatListData?
}

// MARK: - EmployerListData
struct EmployerChatListData: Codable {
    let employers: [EmployerChat]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

// MARK: - Employer
struct EmployerChat: Codable {
    let id: String
    let name: String
    let countryCode: String
    let mobileNumber: String
    let unreadCount: Int
    let lastMessageInfo: ChatLastMessageInfo?
    let sortDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case countryCode
        case mobileNumber
        case unreadCount
        case lastMessageInfo
        case sortDate
    }
}

// MARK: - LastMessageInfo
struct ChatLastMessageInfo: Codable {
    let lastMessage: String?
    let lastMessageDate: String?
}
//MARK: -  Backpaker cha list

// MARK: - EmployerListResponse
struct BackpackerChatListResponse: Codable {
    let success: Bool
    let message: String
    let data: BackpackerChatListData?
}

// MARK: - EmployerListData
struct BackpackerChatListData: Codable {
    let backpacker: [EmployerChat]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}


//MARK: - chat

import Foundation

// MARK: - ChatListResponse
struct ChatListResponse: Codable {
    let success: Bool
    let message: String
    let data: ChatListData?
}

// MARK: - ChatListData
struct ChatListData: Codable {
    let user: ChatUser
    let otherUserName : String?
    let chats: [Chat]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

// MARK: - ChatUser
struct ChatUser: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}

// MARK: - Chat
struct Chat: Codable {
    let id: String
    let sender: String
    let receiver: String
    let message: String
    let messageType: String
    let status: String
    let timestamp: String
    let createdAt: String
    let updatedAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sender, receiver, message, messageType, status, timestamp, createdAt, updatedAt
        case v = "__v"
    }
}



//MARK: - SEnd Chat Request

struct ChatRequest: Codable {
    let receiver: String
    let message: String
}

struct AdminChatRequest: Codable {
    let ticketId: String
    let message: String
    let receiverId :String
}

