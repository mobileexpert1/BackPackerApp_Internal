//
//  ValidationManager.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import Foundation
import PhoneNumberKit

struct ValidationManager {
    static let phoneNumberKit = PhoneNumberUtility()

    static func isValidPhoneNumber(_ number: String, regionCode: String) -> Bool {
        let trimmedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let parsedNumber = try phoneNumberKit.parse(trimmedNumber, withRegion: regionCode, ignoreType: false)
            return phoneNumberKit.isValidPhoneNumber(trimmedNumber, withRegion: regionCode)
        } catch {
            print("❌ PhoneNumber parsing failed: \(error.localizedDescription)")
            return false
        }
    }
}
