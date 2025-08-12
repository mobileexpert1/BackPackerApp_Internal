//
//  Extensions.swift
//  Backpacker
//
//  Created by Mobile on 12/08/25.
//

import Foundation
import UIKit

extension String {
    
    /// Formats an ISO date string into "dd, MMM yyyy"
    func formattedISODate() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var date: Date? = isoFormatter.date(from: self)
        
        // Try without fractional seconds if the first attempt fails
        if date == nil {
            isoFormatter.formatOptions = [.withInternetDateTime]
            date = isoFormatter.date(from: self)
        }
        
        guard let finalDate = date else { return nil }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd, MMM yyyy"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return displayFormatter.string(from: finalDate)
    }
    
    /// Converts 24-hour time ("HH:mm") to 12-hour format ("hh:mm a")
    func toAmPmFormat() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

extension UILabel {
    
    /// Calculates and returns required height for label content
    func requiredHeight(forWidth width: CGFloat) -> CGFloat {
        guard let text = self.text else { return 0 }
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: self.font ?? UIFont.systemFont(ofSize: 14)],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}

extension String {
    
    /// Calculates height for given string, font, and width
    func heightForLabel(font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return max(40, ceil(boundingBox.height))
    }

}
