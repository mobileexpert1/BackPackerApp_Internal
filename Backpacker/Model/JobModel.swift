//
//  JobModel.swift
//  Backpacker
//
//  Created by Mobile on 06/08/25.
//

import Foundation

// MARK: - Root Response
struct JobListResponse: Codable {
    let success: Bool
    let message: String
    let data: JobListData
    let errors: [String]
}

// MARK: - Data Section
struct JobListData: Codable {
    let currentJobslist: [JobItem]
    let newJobslist: [JobItem]
    let declinedJobslist: [JobItem]
}

//// MARK: - Individual Job
//struct Job: Codable {
//    let id: String
//    let name: String
//    let address: String
//    let description: String
//    let image: String
//    let startDate: String
//    let endDate: String
//    let startTime: String
//    let endTime: String
//    let price: Int
//    let favoriteStatus: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case name, address, description, image, startDate, endDate, startTime, endTime, price, favoriteStatus
//    }
//}
