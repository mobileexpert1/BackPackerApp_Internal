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

// Job  List Response Qith Pagination

import Foundation

// MARK: - Main Response
import Foundation

struct JobsResponse: Codable {
    let success: Bool
    let message: String
    let data: JobsData
    let errors: [String]?
}

struct JobsData: Codable {
    let jobslist: [Job]
    let page: Int
    let perPage: Int
    let totalPages: Int
    let total: Int
}

struct Job: Codable {
    let id: String
    let name: String
    let description: String
    let image: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let price: Double
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case image
        case startDate
        case endDate
        case startTime
        case endTime
        case price
        case favoriteStatus
    }
}
