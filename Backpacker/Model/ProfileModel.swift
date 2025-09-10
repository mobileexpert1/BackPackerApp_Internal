//
//  ProfileModel.swift
//  Backpacker
//
//  Created by Mobile on 06/08/25.
//

import Foundation
struct UserProfileResponse: Codable {
    let success: Bool
    let message: String
    let data: UserProfileData
    let errors: [String]
}

// MARK: - Data
struct UserProfileData: Codable {
    let name: String
    let email: String
    let countryCode: String
    let countryName: String
    let mobileNumber: String
    let state: String
    let area: String
    let visaType: String
    let lat: Double
    let long: Double
    let notificationStatus: Bool
}


//MARK: - Update Profile

// MARK: - Root Response
struct UpdateProfileResponse: Codable {
    let success: Bool
    let message: String
    let data: UpdateProfileData?
    let errors: [String]
}

// MARK: - Data
struct UpdateProfileData: Codable {
    let notificationStatus: Bool
}


//MARK: - Employer Historyy Bac packer

struct EmpBackpackerListResponse: Codable {
    let success: Bool
    let message: String
    let data: EmpBackpackerListData?
    let errors: [String]
}

struct EmpBackpackerListData: Codable {
    let backpackers: [EmpBackpacker]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

struct EmpBackpacker: Codable {
    let name: String
    let email: String
    let mobileNumber: String
    let image: String
    let lat: Double
    let long: Double
    let area: String
    let state: String
    let totalJobs: Int
    let averageRating: Double
    let userId: String
}

//MARK: - Completed History jbs emploeyr
struct EmpJobsListResponse: Codable {
    let success: Bool
    let message: String
    let data: EmpJobsListData?
    let errors: [String]
}

struct EmpJobsListData: Codable {
    let jobs: [EmpJob]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

struct EmpJob: Codable {
    let _id: String?
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
    let acceptedBackpackers: [EmpAcceptedBackpacker]
}

struct EmpAcceptedBackpacker: Codable {
    let _id: String
    let name: String
    let email: String
    let mobileNumber: String
    let image: String
}

