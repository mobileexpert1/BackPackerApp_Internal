//
//  HangOutModel.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import Foundation
import UIKit
struct HangoutRequest {
    var name: String
    var address: String
    var lat: Double
    var long: Double
    var locationText: String
    var description: String
    var image: UIImage
}

struct HangoutResponseData: Codable {
    let _id: String
}


import Foundation

struct BackPackerHangoutResponse: Codable {
    let success: Bool
    let message: String
    let data: BackPackerHangoutData
    let errors: [String]?
}

struct BackPackerHangoutData: Codable {
    let hangoutList: [BackPackerHangoutItem]
    let page: Int
    let perPage: Int
    let totalPages: Int
    let total: Int
}

struct BackPackerHangoutItem: Codable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
    let locationText: String
    let description: String
    let image: [String]
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, lat, long, locationText, description, image, favoriteStatus
    }
}

struct BackPackerHangoutUser: Codable {
    let id: String
    let name: String
    let email: String
    let image: String
    let lat: Double
    let long: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, image, lat, long
    }
}



//MARK: - Hangout etail Backpacker response model

struct HangoutDetailResponse: Codable {
    let success: Bool
    let message: String
    let data: HangoutData
    let errors: [String]?
}

struct HangoutData: Codable {
    let hangout: Hangout
    var nearbyUsers: [NearbyUser]
}

struct Hangout: Codable {
    let id: String
    let name: String
    let address: String
    let lat: Double
    let long: Double
  //  let locationId : String
    let locationText: String
    let description: String
    let image: [String]
    let v: Int
//    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, address, lat, long, locationText, description, image//, locationId//, favoriteStatus
        case v = "__v"
    }
}

struct NearbyUser: Codable {
    var id: String
    var name: String
    var email: String
    var image: String
    var lat: Double
    var long: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, image, lat, long
    }
}


//MARK: - Response moedl
struct ApiResponseModel<T: Codable>: Codable {
    let success: Bool
    let message: String
    let data: T?
    let errors: [String]?
}
struct EmptyData: Codable {}



//MARK: - Fav Hangout

struct FavHangoutResponse: Codable {
    let success: Bool
    let message: String
    let data: FavHangoutData?
    let errors: [String]
}

struct FavHangoutData: Codable {
    let hangoutList: [FavHangout]  
    let page: Int
    let perPage: Int
    let totalPages: Int
    let total: Int
}

struct FavHangout: Codable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
    let locationText: String
    let description: String
    let image: [String]
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, lat, long, locationText, description, image, favoriteStatus
    }
}



//MARK: - Fetch Current Prucahae plan User


struct SubscriptionResponse: Codable {
    let success: Bool
    let message: String
    let data: SubscriptionData
    let errors: [String]
}

struct SubscriptionData: Codable {
    let counts: Counts
    let subscription: Subscription?
    let subscriptionStatus: String
}

struct Counts: Codable {
    let accommodation: Int
    let jobs: Int
    let hangouts: Int
}

struct Subscription: Codable {
    let id: String?
    let userId: String?
    let planId: PlanJob?
    let platform: String?
    let startDate: String?
    let endDate: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let transactionId: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case planId
        case platform
        case startDate
        case endDate
        case status
        case createdAt
        case updatedAt
        case transactionId
    }
}

struct PlanJob: Codable {
    let id: String?
    let commonName: String?
    let desc: String?
    let feature: [String]?
    let image: String?
    let status: String?
    let googleProductId: String?
    let iosAttributes: IOSAttributesNewJob?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case commonName
        case desc
        case feature
        case image
        case status
        case googleProductId
        case iosAttributes
    }
}

struct IOSAttributesNewJob: Codable {
    let productId: String?
}

struct Reminder: Codable {
    let productId: String?
}
