//
//  BackpackerHomeModel.swift
//  Backpacker
//
//  Created by Mobile on 04/08/25.
//

import Foundation

struct BackpackerHomeResponseModel: Codable {
    let jobslist: [JobItem]
    let hangoutList: [HangoutItem]
    let accommodationList: [AccommodationItem]
    let banners: [BannerItem]
    let name : String
    let email : String
    let notificationCount : Int
}
struct JobItem: Codable {
    let id: String
    let name: String
    let description: String
    let image: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let price: Int
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, description, image, startDate, endDate, startTime, endTime, price, favoriteStatus
    }
}

struct HangoutItem: Codable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
    let description: String
    let image: [String]
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, lat, long, description, image, favoriteStatus
    }
}

struct AccommodationItem: Codable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
    let description: String
    let image: [String]
    let price: Int
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, lat, long, description, image, price, favoriteStatus
    }
}

struct BannerItem: Codable {
    let id: String
    let name: String
    let link: String
    let description: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, link, description, image
    }
}
enum SectionType {
    case jobs
    case hangouts
    case accommodations
    case banner
}
