//
//  EmployerJobModel.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import Foundation
// MARK: - Root Response
struct BackpackerListResponse: Codable {
    let success: Bool
    let message: String
    let data: BackpackersData?
    let errors: [String]?
}

// MARK: - Data
struct BackpackersData: Codable {
    let backpackersList: [Backpacker]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

// MARK: - Backpacker
struct Backpacker: Codable {
    let id: String
    let name: String
    let email: String
    let countryCode: String
    let countryName: String
    let mobileNumber: String
    let jobsCount: Int
    let rating: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email, countryCode, countryName, mobileNumber, jobsCount, rating
    }
}
