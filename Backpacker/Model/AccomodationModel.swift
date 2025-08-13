//
//  AccomodationModel.swift
//  Backpacker
//
//  Created by Mobile on 07/08/25.
//

import Foundation
import Foundation

// MARK: - Top-level response
struct AccommodationResponseModel: Codable {
    let success: Bool
    let message: String
    let data: AccommodationData
    let errors: [String]?
}

// MARK: - Data container
struct AccommodationData: Codable {
    let accommodationList: [Accommodation]
    let page: Int
    let perPage: Int
    let totalPages: Int
    let total: Int
}

// MARK: - Single accommodation item
struct Accommodation: Codable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
    let description: String
    let image: [String]
    let price: Int
    let facilities: [String]
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, lat, long, description, image, price, facilities, favoriteStatus
    }
}


//MARK: - Backpacker Accommodation detail model
import Foundation

struct AccommodationDetailResponse: Codable {
    let success: Bool
    let message: String
    let data: AccommodationDetailData
    let errors: [String]
}

struct AccommodationDetailData: Codable {
    let accommodation: AccommodationDetail
}

struct AccommodationDetail: Codable {
    let id: String
    let name: String
    let address: String
    let lat: Double
    let long: Double
    let locationText: String
    let description: String
    let image: [String]
    let price: Int
    let facilities: [String]
    let v: Int
  //  let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, address, lat, long, locationText, description, image, price, facilities//, favoriteStatus
        case v = "__v"
    }
}

//MARK: -
