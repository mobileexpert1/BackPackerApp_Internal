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
