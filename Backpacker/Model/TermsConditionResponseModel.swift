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

//Pri
struct PrivacyPolicyResponse: Codable {
    let success: Bool
    let message: String
    let data: PrivacyPolicyData
    let errors: [String]
}

struct PrivacyPolicyData: Codable {
    let privacyPolicy: PrivacyPolicy
}

struct PrivacyPolicy: Codable {
    let title: String
    let content: String
    let version: Int
}
//TrmsAnd Condition
struct TermsAndConditionsResponse: Codable {
    let success: Bool
    let message: String
    let data: TermsAndConditionsData
    let errors: [String]
}

struct TermsAndConditionsData: Codable {
    let termsAndConditions: TermsAndConditions
}

struct TermsAndConditions: Codable {
    let title: String
    let content: String
    let version: Int
    var plainTextContent: String {
           guard let data = content.data(using: .utf8) else { return content }
           if let attributedString = try? NSAttributedString(
               data: data,
               options: [.documentType: NSAttributedString.DocumentType.html,
                         .characterEncoding: String.Encoding.utf8.rawValue],
               documentAttributes: nil
           ) {
               return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
           }
           return content
       }
}
extension String {
    var htmlToPlainText: String {
        guard let data = data(using: .utf8) else { return self }
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            return attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self
    }
}
