//
//  EmployerJobModel.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import Foundation

import Foundation

// MARK: - Root Response
struct BackpackerListResponse: Codable {
    let success: Bool
    let message: String
    let data: BackpackerData?
    let errors: [String]?
}

// MARK: - Data Object
struct BackpackerData: Codable {
    let backpackersList: [Backpacker]
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
}

// MARK: - Backpacker Entry
struct Backpacker: Codable {
    let id: String
    let name: String
    let email: String
    let countryCode: String
    let countryName: String
    let mobileNumber: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case countryCode
        case countryName
        case mobileNumber
    }
}
//MARK: - Add New Job
