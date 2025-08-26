//
//  EmployerHomeModel.swift
//  Backpacker
//
//  Created by Mobile on 13/08/25.
//

import Foundation

struct EmployerHomeResponse: Codable {
    let success: Bool
    let message: String
    let data: EmployerHomeData?
    let errors: [String]?
}

// MARK: - Data
struct EmployerHomeData: Codable {
    let jobslist: [EmployerJob]?
    let name: String?
    let email: String?
    let totalJobs: Int?
    let acceptedJobs: Int?
    let declinedJobs: Int?
    let notificationCount : Int?
}

// MARK: - Job
struct EmployerJob: Codable {
    let id: String
    let name: String?
    let address: String?
    let description: String?
    let image: String?
    let startDate: String?
    let endDate: String?
    let startTime: String?
    let endTime: String?
    let price: Double?
    let favoriteStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, address, description, image, startDate, endDate, startTime, endTime, price, favoriteStatus
    }
}
