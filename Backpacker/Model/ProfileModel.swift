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



//MARK: - Company Detail

import Foundation

// MARK: - CompanyResponse
struct CompanyResponse: Codable {
    let success: Bool?
    let message: String?
    let data: CompanyData?
}

// MARK: - CompanyData/New Comany
struct CompanyData: Codable {
    let company: Company?
    let locations: [Location]?
}

// MARK: - Company
struct Company: Codable {
    let id: String?
    let userId: String?
    let name: String?
    let industryTypeId: String?
    let logo: String?
    let website: String?
    let contactNumber: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, name, industryTypeId, logo, website, contactNumber, createdAt, updatedAt
    }
}

// MARK: - Location
struct Location: Codable {
    let id: String?
    let userId: String?
    let businessCompanyId: String?
    let name: String?
    let lat: Double?
    let long: Double?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, businessCompanyId, name, lat, long, createdAt, updatedAt
    }
}


import Foundation

// MARK: - CompanyCreateResponse
struct CompanyCreateResponse: Codable {
    let success: Bool?
    let message: String?
    let data: CompanyDetail?
    let errors: [String]?
}

// MARK: - CompanyDetail
struct CompanyDetail: Codable {
    let id: String?
    let userId: String?
    let name: String?
    let industryTypeId: String?
    let logo: String?
    let website: String?
    let contactNumber: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, name, industryTypeId, logo, website, contactNumber, createdAt, updatedAt
    }
}
import Foundation

// MARK: - LocationCreateResponse
struct CompanyLocationCreateResponse: Codable {
    let success: Bool?
    let message: String?
    let data: CompanyLocationDetail?
}

// MARK: - LocationDetail
struct CompanyLocationDetail: Codable {
    let id: String?
    let userId: String?
    let businessCompanyId: String?
    let name: String?
    let lat: Double?
    let long: Double?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, businessCompanyId, name, lat, long, createdAt, updatedAt
    }
}
import Foundation

// MARK: - IndustryResponse
struct IndustryResponse: Codable {
    let success: Bool
    let message: String
    let data: IndustryData
}

// MARK: - IndustryData
struct IndustryData: Codable {
    let industries: [Industry]
}

// MARK: - Industry
struct Industry: Codable, Identifiable {
    let id: String
    let name: String
    let image: String
    let v: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case image
        case v = "__v"
        case createdAt
        case updatedAt
    }
}
