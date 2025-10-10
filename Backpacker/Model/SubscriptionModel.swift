//
//  SubscriptionModel.swift
//  Backpacker
//
//  Created by Mobile on 06/10/25.
//

import Foundation

// MARK: - GetSubscriptionModel
struct GetSubscriptionModel: Codable {
    let success: Bool?
    let message: String?
    let data: PlansResponse?
    let errors: [String]?
}

// MARK: - PlansResponse
struct PlansResponse: Codable {
    let plans: [Plan]?
    let currentPlan : Plan?
}

// MARK: - Plan
struct Plan: Codable {
    let id: String?
    let name: String?
    let price: Double?
    let feature: [String]?
    let desc: String?
    let image: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case price
        case feature
        case desc
        case image
        case status
        case createdAt
        case updatedAt
    }
}
