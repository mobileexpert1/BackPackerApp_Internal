//
//  JobDetailModel.swift
//  Backpacker
//
//  Created by Mobile on 12/08/25.
//

import Foundation

struct JobDetailResponse: Codable {
    let success: Bool
    let message: String
    let data: JobDetailData
    let errors: [String]?
}

struct JobDetailData: Codable {
    let job: JobDetail
}

struct JobDetail: Codable {
    let id: String
    let employerId: Employer
    let name: String
    let address: String
    let lat: Double
    let long: Double
    let locationText: String
    let description: String
    let requirements: String
    let image: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let price: Double
    let v: Int
    let jobAcceptStatus: Int
    let completedJobsCount: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case employerId, name, address, lat, long, locationText, description, requirements, image, startDate, endDate, startTime, endTime, price
        case v = "__v"
        case jobAcceptStatus, completedJobsCount
    }
}

struct Employer: Codable {
    let id: String
    let name: String
    let state: String
    let area: String
    let lat: Double
    let long: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, state, area, lat, long
    }
}
