//
//  AvailabilityModel.swift
//  Backpacker
//
//  Created by Mobile on 04/09/25.
//

import Foundation
//MARK: - Availability Request


struct AvailabilityRequest: Codable {
    let overallAvailability: Bool
    let days: [DayAvailability]
}

struct DayAvailability: Codable {
    var day: String
    var enabled: Bool
    var slots: [Slot]
}

struct Slot: Codable {
    var start: String
    var end: String
    var enabled: Bool
    
    // Computed properties for 24-hour format
    var start24: String {
        return Slot.to24HourFormat(time: start)
    }
    
    var end24: String {
        return Slot.to24HourFormat(time: end)
    }
    
    private static func to24HourFormat(time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        if let date = formatter.date(from: time) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return time // fallback
    }
    
    enum CodingKeys: String, CodingKey {
        case start = "start"
        case end = "end"
        case enabled = "enabled"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start24, forKey: .start)
        try container.encode(end24, forKey: .end)
        try container.encode(enabled, forKey: .enabled)
    }
}

//MARK: - OVerAllAvaibilty request

struct OverAllAvailabilityRequest: Codable {
    let overallAvailability: Bool
}



//MARK: - Availability Response
struct GetAvailabilityResponse: Codable {
    let success: Bool
    let message: String
    let data: GetAvailabilityData
    let errors: [String]
}

struct GetAvailabilityData: Codable {
    let id: String
    let userId: String
    let overallAvailability: Bool
    let days: [GetAvailabiltyDay]
    let createdAt: String
    let updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case overallAvailability
        case days
        case createdAt
        case updatedAt
        case v = "__v"
    }
}

struct GetAvailabiltyDay: Codable {
    let day: String
    let enabled: Bool
    let slots: [GetAvailabiltySlot]
    let id: String

    enum CodingKeys: String, CodingKey {
        case day, enabled, slots
        case id = "_id"
    }
}

struct GetAvailabiltySlot: Codable {
    let start: String
    let end: String
    let enabled: Bool
    let id: String

    enum CodingKeys: String, CodingKey {
        case start, end, enabled
        case id = "_id"
    }
}

//MARK: - Employer callnedar Backpacker list

struct AvailableBackpackerListResponse: Codable {
    let success: Bool
    let message: String
    let data: AvailableBackpackerListData
    let errors: [String]
}
struct AvailableBackpackerListData: Codable {
    let backpackers: [AvailableBackpacker]
    let total: Int
    let page: Int
    let perPage: Int
    let totalPages: Int
}
struct AvailableBackpacker: Codable {
    let userId: String
    let name: String
    let completedJobsCount: Int
    let averageRating: Double
    let lat: Double
    let long: Double
    let area: String
    let state: String
}
