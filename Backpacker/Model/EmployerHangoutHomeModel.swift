//
//  EmployerHangoutHomeModel.swift
//  Backpacker
//
//  Created by Mobile on 13/08/25.
//

import Foundation
import Foundation

// MARK: - Root Response
struct EmployerHangoutHomeResponse: Codable {
    let success: Bool
    let message: String
    let data: EmployerHangoutData
    let errors: [String]?
}

// MARK: - Data Container
struct EmployerHangoutData: Codable {
    let hangoutList: [HangoutItem]
    let banners: [BannerItem]
    let name: String
    let email: String
}

