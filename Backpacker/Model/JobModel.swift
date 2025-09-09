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
    var address : String?
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


//MARK: - Employer Job List See All


// MARK: - Root Response
struct EmployerJobsResponse: Codable {
    let success: Bool
    let message: String
    let data: JobData?
    let errors: [String]?
}

// MARK: - Job Data
struct JobData: Codable {
    let currentJobslist: [EmployerJob]?
    let postedJobList: [EmployerJob]?
    let upcomingJobList: [EmployerJob]?
}



// MARK: - Favourate Job Reques
struct FavouriteJobRequest: Codable {
    let jobId: String
}
struct FavouriteHangoutbRequest: Codable {
    let hangoutId: String
}
struct FavouriteAccomodationRequest: Codable {
    let accommodationId: String
}
//MARK: - Favourate Job
struct FavoriteJobResponse: Codable {
    let success: Bool
    let message: String
    let data: FavoriteJobData?
    let errors: [String]
}

struct FavoriteJobData: Codable {
    let jobs: [FavoriteJob]
    let page: Int
    let perPage: Int
    let totalPages: Int
    let total: Int
}
struct FavoriteJob: Codable {
    let id: String
    let description: String
    let image: String
    let favoriteStatus: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case description, image, favoriteStatus
    }
}

//MARK: - History of comleted jobs

struct CompletedJobsResponse: Codable {
    let success: Bool
    let message: String
    let data: CompletedJobsData
    let errors: [String]
}

struct CompletedJobsData: Codable {
    let completedJobsList: [CompletedJob]
    let page: Int
      let perPage: Int
      let totalPages: Int
      let total: Int
}
struct CompletedJob: Codable {
    let _id: String
    let name: String
    let address: String
    let description: String
    let image: String
    let startDate: String   
    let endDate: String
    let startTime: String
    let endTime: String
    let price: Int
    let favoriteStatus: Int
}
