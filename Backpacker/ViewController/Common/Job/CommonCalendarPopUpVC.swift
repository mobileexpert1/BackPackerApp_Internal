//
//  CommonCalendarPopUpVC.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import UIKit
import FSCalendar
protocol CommonCalendarPopUpVCDelegate: AnyObject {
    func calendarDidSelectSingleDate(_ date: Date)
    func calendarDidSelectRange(startDate: Date, endDate: Date)
}

class CommonCalendarPopUpVC: UIViewController {
    
    @IBOutlet weak var lbl_year: UILabel!
    @IBOutlet weak var lbl_SelectYear: UILabel!
    @IBOutlet weak var vw_SelectYear: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    var selectedDate: Date?
    @IBOutlet weak var btn_save: UIButton!
    var startDate: Date?
    var endDate: Date?
    @IBOutlet weak var btn_SelectYear: UIButton!
    private var dropdownHelper: DropdownHelper?
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df
    }()
    weak var delegate: CommonCalendarPopUpVCDelegate?
    var isComeFromEdit : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setUpCalendar()
        self.setUpYearList()
        // Do any additional setup after loading the view.
    }
    
    func setUpYearList(){
        let currentYear = Calendar.current.component(.year, from: Date())
        let years = (currentYear...2030).map { "\($0)" }
        
        dropdownHelper = DropdownHelper(
            parentView: self.view,
            anchorButton: btn_SelectYear,
            options: years,
            optionImages: Array(repeating: "role_EmpTick", count: years.count) // or use empty string/image if not needed
        )
        
        dropdownHelper?.onOptionSelected = { [weak self] selectedYear in
            guard let self = self else { return }
            
            print("-Selected year:", selectedYear)
            self.lbl_year.text = selectedYear
            
            // 1. Deselect all selected dates
            self.calendarView.selectedDates.forEach { self.calendarView.deselect($0) }
            
            // 2. Scroll and select Jan 1st of selected year
            if let yearInt = Int(selectedYear) {
                var components = DateComponents()
                components.year = yearInt
                components.month = 1
                components.day = 1
                
                if let targetDate = Calendar.current.date(from: components) {
                    self.calendarView.setCurrentPage(targetDate, animated: true)
                    
                    // -Select Jan 1st
                    self.calendarView.select(targetDate)
                    self.startDate = targetDate
                    self.selectedDate = targetDate
                }
            }
            
            // 3. Reset end date if range was previously selected
            self.endDate = nil
        }
    }
    func setupUI(){
        self.lbl_year.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_SelectYear.font = FontManager.inter(.medium, size: 14.0)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        vw_SelectYear.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        calendarView.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        applyGradientButtonStyle(to: self.btn_save)
        self.btn_save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
    }
    @IBAction func action_Cross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func action_selctYear(_ sender: Any) {
        dropdownHelper?.toggleDropdown()
    }
    private func setUpCalendar(){
        
        calendarView.appearance.headerTitleFont = FontManager.inter(.semiBold, size: 22.0)
        calendarView.appearance.weekdayFont = FontManager.inter(.semiBold, size: 12.0)
        calendarView.appearance.titleFont = FontManager.inter(.semiBold, size: 17.0)
        calendarView.scrollEnabled = true
        calendarView.allowsSelection = true
        calendarView.allowsSelection = true
        calendarView.locale = Locale(identifier: "en")
        calendarView.appearance.weekdayTextColor = UIColor.black
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.eventSelectionColor = UIColor.black
        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.headerDateFormat = "MMMM"
        calendarView.appearance.selectionColor = UIColor(red: 41/255, green: 158/255, blue: 245/255, alpha: 1)
        calendarView.firstWeekday = 1
        calendarView.appearance.todayColor = UIColor(red: 41/255, green: 158/255, blue: 245/255, alpha: 1)
        calendarView.appearance.titleDefaultColor = .black
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.headerHeight = 50
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hex:"#EBEBEB")
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        calendarView.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: calendarView.calendarWeekdayView.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            bottomLine.heightAnchor.constraint(lessThanOrEqualToConstant: 1)
        ])
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        if let selectedDate = selectedDate {
            calendarView.select(selectedDate)
            calendarView.today = selectedDate
            calendarView.setCurrentPage(selectedDate, animated: false)
            lbl_year.text = formatter.string(from: selectedDate)
        } else {
            /*
             if isComeFromEdit == false {
             let today = calendarView.today ?? Date()
             calendarView.select(today)
             calendarView.setCurrentPage(today, animated: false)
             self.selectedDate = today
             lbl_year.text = formatter.string(from: selectedDate ?? Date())
             }else{
             
             }
             */
            if startDate == nil {
                let today = calendarView.today ?? Date()
                calendarView.select(today)
                calendarView.setCurrentPage(today, animated: false)
                self.selectedDate = today
                lbl_year.text = formatter.string(from: selectedDate ?? Date())
            }else{
                calendarView.today = nil
            }
            
            
        }
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    
    @IBAction func action_Save(_ sender: Any) {
        if let start = startDate, let end = endDate {
            delegate?.calendarDidSelectRange(startDate: start, endDate: end)
            print("📤 Passed range: \(dateToString(start)) to \(dateToString(end))")
        } else if let selected = selectedDate {
            delegate?.calendarDidSelectSingleDate(selected)
            print("📤 Passed single date: \(dateToString(selected))")
        } else {
            print("⚠️ No date selected")
        }
        
        self.dismiss(animated: true)
    }
    
    
}

// MARK: - FSCalendarDelegate & DataSource

extension CommonCalendarPopUpVC: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let cal = Calendar.current
        
        if let start = startDate, let end = endDate {
            let rangeStart = min(start, end)
            let rangeEnd = max(start, end)
            
            if (cal.compare(date, to: rangeStart, toGranularity: .day) != .orderedAscending) &&
                (cal.compare(date, to: rangeEnd, toGranularity: .day) != .orderedDescending) {
                
                return UIColor(red: 41/255, green: 158/255, blue: 245/255, alpha: 1)
            }
        }
        
        if let only = selectedDate, cal.isDate(date, inSameDayAs: only) {
            return UIColor(red: 41/255, green: 158/255, blue: 245/255, alpha: 1)
        }
        
        return nil
    }
    
    //     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    //         let cal = Calendar.current
    //         if let start = startDate, let end = endDate {
    //             let rangeStart = min(start, end)
    //             let rangeEnd = max(start, end)
    //
    //             if (cal.compare(date, to: rangeStart, toGranularity: .day) != .orderedAscending) &&
    //                (cal.compare(date, to: rangeEnd, toGranularity: .day) != .orderedDescending) {
    //                 return .white
    //             }
    //         }
    //         if let only = selectedDate, cal.isDate(date, inSameDayAs: only) {
    //             return .white
    //         }
    //         return nil
    //     }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let cal = Calendar.current
        
        // 🔹 If date is before today → gray
        if date < cal.startOfDay(for: Date()) {
            return UIColor.lightGray
        }
        
        // 🔹 Highlight range selection
        if let start = startDate, let end = endDate {
            let rangeStart = min(start, end)
            let rangeEnd = max(start, end)
            
            if (cal.compare(date, to: rangeStart, toGranularity: .day) != .orderedAscending) &&
                (cal.compare(date, to: rangeEnd, toGranularity: .day) != .orderedDescending) {
                return .white
            }
        }
        
        // 🔹 Single date selected
        if let only = selectedDate, cal.isDate(date, inSameDayAs: only) {
            return .white
        }
        
        // 🔹 Default → black
        return .black
    }
    
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date() // today's date
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(from: DateComponents(year: 2035, month: 12, day: 31))!
    }
    
    // FSCalendarDataSource method
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        cell.isHidden = false
    }
    
    //     func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    //         return date >= Calendar.current.startOfDay(for: Date()) && monthPosition == .current
    //     }
    
    //     func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    //         // prevent auto-selection of today's date
    //         if Calendar.current.isDateInToday(date) {
    //             return false
    //         }
    //         return date >= Calendar.current.startOfDay(for: Date()) && monthPosition == .current
    //     }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // Only block past days
        guard monthPosition == .current else { return false }
        
        // Allow today and future
        return date >= Calendar.current.startOfDay(for: Date()) && monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDate == nil && endDate == nil {
            // First tap: single date mode
            calendar.selectedDates.forEach { calendar.deselect($0) }
            startDate = date
            selectedDate = date
            calendar.select(date)
            calendar.today = nil
            print("-Single date selected: \(dateToString(date))")
            
        } else if let start = startDate, endDate == nil {
            if date == start {
                // Tap same date again = clear
                calendar.deselect(date)
                startDate = nil
                selectedDate = nil
                print("🗑️ Cleared selection")
                
            } else {
                // Second tap: create range
                endDate = date
                selectedDate = nil
                
                // -Clear old selections before applying range
                calendar.selectedDates.forEach { calendar.deselect($0) }
                
                var current = start < date ? start : date
                let rangeEnd = start > date ? start : date
                startDate = current
                endDate = rangeEnd
                
                while current <= rangeEnd {
                    calendar.select(current)
                    current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
                }
                
                print("📆 Range selected: \(dateToString(startDate!)) to \(dateToString(endDate!))")
            }
            
        } else {
            // New selection cycle
            calendar.selectedDates.forEach { calendar.deselect($0) }
            startDate = date
            endDate = nil
            selectedDate = date
            calendar.select(date)
            print("🔄 New single date selected: \(dateToString(date))")
        }
        calendar.reloadData()
        
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        startDate = nil
        endDate = nil
        selectedDate = nil
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.calendarView.reloadData()
    } 
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
}

