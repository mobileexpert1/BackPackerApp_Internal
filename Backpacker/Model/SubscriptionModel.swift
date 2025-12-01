//
//  SubscriptionModel.swift
//  Backpacker
//
//  Created by Mobile on 06/10/25.
//

import Foundation

// MARK: - GetSubscriptionModel
struct GetSubscriptionModel: Codable {
    let success: Bool
       let message: String
       let data: [Plan]
       let errors: [String]?
}

// MARK: - PlansResponse
struct PlansResponse: Codable {
    let plans: [Plan]?
//    let currentPlan : Plan?
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
    let v: Int
    let createdAt: String?
    let updatedAt: String?
    let planStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case price
        case feature
        case desc
        case image
        case status
        case v = "__v"
        case createdAt
        case updatedAt
        case planStatus
    }
}
struct SubscriptionPlansResponse: Codable {
    let success: Bool
    let message: String
    let data: [PlanS]
    let errors: [String]?
}

// MARK: - Plan
struct PlanS: Codable {
    let id: String
    let planStatus: String
    let googlePackageName: String
    let googleProductId: String
    let basePlan: BasePlan
    let iosSubId: String
    let iosAttributes: IOSAttributes
    let iosBasePlan: IOSBasePlan
    let commonName: String
    let feature: [String]
    let desc: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case planStatus
        case googlePackageName
        case googleProductId
        case basePlan
        case iosSubId
        case iosAttributes
        case iosBasePlan
        case commonName
        case feature
        case desc
    }
}

// MARK: - BasePlan
struct BasePlan: Codable {
    let basePlanId: String
    let region: Region
}

struct Region: Codable {
    let regionCode: String
    let newSubscriberAvailability: Bool
    let price: RegionPrice
}

struct RegionPrice: Codable {
    let currencyCode: String
    let units: String
    let nanos: Int
}

// MARK: - iOS Attributes
struct IOSAttributes: Codable {
    let name: String
    let productId: String
    let familySharable: Bool
    let state: String
    let subscriptionPeriod: String
    let reviewNote: String
    let groupLevel: Int
}

// MARK: - iOS Base Plan
struct IOSBasePlan: Codable {
    let country: String
    let price: IOSPrice
    let currency: String
}

struct IOSPrice: Codable {
    let customerPrice: String
    let proceeds: String
    let proceedsYear2: String
}
