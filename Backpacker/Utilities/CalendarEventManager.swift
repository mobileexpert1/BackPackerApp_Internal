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
                print("- Calendar access error: \(error.localizedDescription)")
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
            print("-Event added to calendar.")
            completion?(true, nil)
        } catch {
            print("- Failed to save event: \(error.localizedDescription)")
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
import UIKit

class RoundedTabBar: UITabBar {
    private var highlightLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        drawRoundedRectAroundSelectedIcon()
    }

    private func drawRoundedRectAroundSelectedIcon() {
        // 1. Remove any existing highlight
        highlightLayer?.removeFromSuperlayer()

        // 2. Locate selected index
        guard
            let items    = items,
            let selected = selectedItem,
            let index    = items.firstIndex(of: selected)
        else { return }

        // 3. Grab the UIControl buttons, sorted left→right
        let buttons = subviews
            .filter { $0 is UIControl }
            .sorted { $0.frame.minX < $1.frame.minX }
        guard index < buttons.count else { return }
        let button = buttons[index]

        // 4. Find the icon’s UIImageView (fallback to the button itself)
        let iconView = button.subviews.compactMap { $0 as? UIImageView }.first ?? button

        // 5. Convert its center into tabBar’s coordinate space
        let center = convert(iconView.center, from: button)

        // 6. Build a 40×40 rounded‑rect centered on that point
        let rectWidth: CGFloat  = 45
         let rectHeight: CGFloat = 25
         let rect = CGRect(
             x: center.x - rectWidth/2,
             y: center.y - rectHeight/2,
             width: rectWidth,
             height: rectHeight
         )
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 12)

        // 7. Create & configure the shape layer
        let shape = CAShapeLayer()
        shape.path        = path.cgPath
        shape.fillColor   = UIColor.clear.cgColor
        shape.strokeColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        shape.lineWidth   = 1.05
        // ensure it’s above the icon
        shape.zPosition   = .greatestFiniteMagnitude

        // 8. Add it on top
        layer.addSublayer(shape)
        highlightLayer = shape
    }
}
