//
//  TermsConditionResponseModel.swift
//  Backpacker
//
//  Created by Mobile on 10/09/25.
//

import Foundation
import Foundation

// MARK: - Main Response
struct ContentResponse: Codable {
    let success: Bool
    let message: String
    let data: ContentData?
    let errors: [String]
}

// MARK: - Data Container
struct ContentData: Codable {
    let aboutUs: AboutUs?
}

// MARK: - About Us
struct AboutUs: Codable {
    let title: String?
    let content: String?
    let version: Int?
}
