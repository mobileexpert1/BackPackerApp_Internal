//
//  EmployerAccomodationHomeModel.swift
//  Backpacker
//
//  Created by Mobile on 13/08/25.
//

import Foundation
import UIKit

// MARK: - Root Response
struct EmployerAccommodationResponse: Codable {
    let success: Bool
    let message: String
    let data: EmployerAccommodationData
    let errors: [String]?
}

// MARK: - Data Container
struct EmployerAccommodationData: Codable {
    let accommodationList: [AccommodationItem]
    let banners: [BannerItem]
    let name: String
    let email: String
}

// MARK: - Accommodation Model
struct EmployerAccommodation: Codable {
    let id: String
    let name: String
    let lat: Double
    let long: Double
    let description: String
    let image: [String]
    let price: Double
    let facilities: [String]
    let favoriteStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, lat, long, description, image, price, facilities, favoriteStatus
    }
}

// MARK: - Banner Model
struct EmployerBanner: Codable {
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
