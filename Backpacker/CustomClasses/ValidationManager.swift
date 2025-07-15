//
//  ValidationManager.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import PhoneNumberKit

import PhoneNumberKit

struct ValidationManager {

    static let phoneNumberUtility = PhoneNumberUtility()
    static func isValidPhoneNumber(_ number: String, countryCode: String) -> Bool {
        let trimmedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedNumber = countryCode + trimmedNumber

        do {
            _ = try phoneNumberUtility.parse(formattedNumber)
            // If parsing succeeds, number is valid
            return true
        } catch {
            print("❌ PhoneNumber parsing failed: \(error.localizedDescription)")
            return false
        }
    }
}
