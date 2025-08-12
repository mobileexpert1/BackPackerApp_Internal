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
struct ApiResponseModel<T: Codable>: Codable {
    let success: Bool
    let message: String
    let data: T?
    let errors: [String]?
}

struct EmptyData: Codable {}
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
   // let userList: [BackPackerHangoutUser]
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
