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
    let startDate : String?
    let endDate : String?
    let dob : String?
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

// MARK: - CompanyCreateResponse
struct CompanyCreateResponse: Codable {
    let success: Bool?
    let message: String?
    let data: CompanyResponseData?
    let errors: [String]?
}
// MARK: - CompanyData
struct CompanyResponseData: Codable {
    let company: CompanyDetail?
}

// MARK: - CompanyDetail
struct CompanyDetail: Codable {
    let id: String?
    let userId: String?
    let name: String?
    let industryType: CompanyIndustry?
    let logo: String?
    let website: String?
    let contactNumber: String?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, name
        case industryType = "industryTypeId" // maps API field to property
        case logo, website, contactNumber, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - Industry
struct CompanyIndustry: Codable {
    let id: String?
    let name: String?
    let image: String?
    let v: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image
        case v = "__v"
        case createdAt, updatedAt
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
import Foundation

// MARK: - Main Response
struct LocationResponse: Codable {
    let success: Bool
    let message: String
    let data: LocationData
}

// MARK: - Data
struct LocationData: Codable {
    let locations: [LocationList]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

// MARK: - Location
struct LocationList: Codable {
    let id: String
    let userId: String
    let businessCompanyId: String
    let name: String
    let lat: Double
    let long: Double
    let createdAt: String
    let updatedAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case businessCompanyId
        case name
        case lat
        case long
        case createdAt
        case updatedAt
        case v = "__v"
    }
}
import Foundation

// MARK: - UpdateCompanyResponse
struct UpdateCompanyResponse: Codable {
    let success: Bool
    let message: String
    let data: UpdatedCompanyDetail
    let errors: [String]
}

// MARK: - UpdatedCompanyDetail
struct UpdatedCompanyDetail: Codable {
    let id: String
    let userId: String
    let name: String
    let industryTypeId: String
    let logo: String
    let website: String
    let contactNumber: String
    let createdAt: String
    let updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, name, industryTypeId, logo, website, contactNumber, createdAt, updatedAt
        case v = "__v"
    }
}

//MARK: - CompanyList
// MARK: - Root Response
struct CompanyListResponse: Codable {
    let success: Bool
    let message: String
    let data: CompanyListData
}

// MARK: - Company Data
struct CompanyListData: Codable {
    let company: [CompanyList]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}

// MARK: - Company
struct CompanyList: Codable {
    let id: String
    let userId: String
    let name: String
    let industryType: IndustryType
    let logo: String
    let website: String
    let contactNumber: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case name
        case industryType = "industryTypeId"
        case logo
        case website
        case contactNumber
        case createdAt
        case updatedAt
    }
}

// MARK: - Industry Type
struct IndustryType: Codable {
    let id: String
    let name: String
    let image: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case image
        case createdAt
        case updatedAt
    }
}
