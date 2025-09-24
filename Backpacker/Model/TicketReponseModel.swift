//
//  TicketReponseModel.swift
//  Backpacker
//
//  Created by Mobile on 16/09/25.
//

import Foundation
struct TicketResponse: Codable {
    let success: Bool
    let message: String
    let data: TicketData?
    let errors: [String]?
}

struct TicketData: Codable {
    let userId: String
    let ticketId: String
    let title: String
    let desc: String
    let userType: Int
    let ticketStatus: Int
    let reason: String
    let id: String
    let createdAt: String
    let updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case userId
        case ticketId
        case title
        case desc
        case userType
        case ticketStatus
        case reason
        case id = "_id"
        case createdAt
        case updatedAt
        case v = "__v"
    }
}


//MARK: - Ticket list Reponse model
struct TicketsResponse: Codable {
    let success: Bool
    let message: String
    let data: TicketsData?
}

struct TicketsData: Codable {
    let tickets: [Ticket]?
    let total: Int?
    let page: Int?
    let perPage: Int?
    let totalPages: Int?
}

struct Ticket: Codable {
    let id: String?
    let userId: String?
    let ticketId: String?
    let title: String?
    let desc: String?
    let userType: Int?
    let ticketStatus: Int?
    let reason: String?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    let lastMessage: LastMessage?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case ticketId
        case title
        case desc
        case userType
        case ticketStatus
        case reason
        case createdAt
        case updatedAt
        case v = "__v"
        case lastMessage
    }
}

struct LastMessage: Codable {
    let id: String?
    let ticketId: String?
    let senderId: String?
    let senderModel: String?
    let receiverId: String?
    let receiverModel: String?
    let message: String?
    let messageType: String?
    let status: String?
    let timestamp: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ticketId
        case senderId
        case senderModel
        case receiverId
        case receiverModel
        case message
        case messageType
        case status
        case timestamp
    }
}

//MARK: - Admin Chat Reposn e


struct AdminChatResponse: Codable {
    let success: Bool
    let message: String
    let data: AdminChatData?
}

struct AdminChatData: Codable {
    let ticket: TicketDetail?
    let adminDetail: AdminDetail?
    let chats: [AdminChatMessage]?
    let total: Int?
    let page: Int?
    let perPage: Int?
    let totalPages: Int?
}
struct AdminDetail: Codable {
    let id: String?
    let name: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image
    }
}
struct TicketDetail: Codable {
    let id: String?
    let userId : String?
    let title: String?
    let desc: String?
    let ticketId: String?
    let userType: Int?
    let reason: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, title, desc, ticketId, userType, reason, createdAt, updatedAt
    }
}

struct AdminChatMessage: Codable {
    let id: String?
    let ticketId: String?
    let senderId: String?
    let senderModel: String?
    let receiverId: String?
    let receiverModel: String?
    let message: String?
    let messageType: String?
    let status: String?
    let timestamp: String?
    let sender: AdminChatMessageChatUser?
    let receiver: AdminChatMessageChatUser?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ticketId, senderId, senderModel, receiverId, receiverModel, message, messageType, status, timestamp, sender, receiver, createdAt, updatedAt
    }
}

struct AdminChatMessageChatUser: Codable {
    let id: String?
    let name: String?
    let email: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, image
    }
}

