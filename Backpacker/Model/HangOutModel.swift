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
