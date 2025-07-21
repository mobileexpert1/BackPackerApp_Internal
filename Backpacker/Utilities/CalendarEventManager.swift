//
//  CalendarEventManager.swift
//  Backpacker
//
//  Created by Mobile on 21/07/25.
//

import Foundation
import EventKit

class CalendarEventManager {

    static let shared = CalendarEventManager()
    private let eventStore = EKEventStore()

    private init() {}

    // Request permission to access Calendar
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("❌ Calendar access error: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }

    // Add event with title, date, duration (in minutes), optional notes
    func addEvent(title: String,
                  startDate: Date,
                  durationMinutes: Int = 60,
                  notes: String? = nil,
                  completion: ((Bool, Error?) -> Void)? = nil) {

        let endDate = Calendar.current.date(byAdding: .minute, value: durationMinutes, to: startDate) ?? startDate.addingTimeInterval(3600)

        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            print("✅ Event added to calendar.")
            completion?(true, nil)
        } catch {
            print("❌ Failed to save event: \(error.localizedDescription)")
            completion?(false, error)
        }
    }
    static func combine(date: Date, hour: Int, minute: Int) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute

        return calendar.date(from: components)
    }

}
