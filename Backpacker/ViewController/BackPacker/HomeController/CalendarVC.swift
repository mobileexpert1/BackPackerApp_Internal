//
//  CalendarVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    @IBOutlet weak var monthCollectionVw: UICollectionView!
    @IBOutlet weak var calendarVw: FSCalendar!
    
    @IBOutlet weak var bgVwAvailibility: UIView!
    @IBOutlet weak var bgVwMonth: UIView!
    @IBOutlet weak var lbl_Value_Time: UILabel!
    @IBOutlet weak var lbl_Value_Hour: UILabel!
    @IBOutlet weak var lbl_Value_Date: UILabel!
    @IBOutlet weak var lbl_headerWorkinHour: UILabel!
    @IBOutlet weak var lbl_HeaderAvailable: UILabel!
    @IBOutlet weak var lbl_headrDate: UILabel!
    
    
   
    @IBOutlet weak var lbl_Header_SelectDate: UILabel!
    @IBOutlet weak var lbl_SetAvailibily: UILabel!
    
    @IBOutlet weak var lbl_HeaderSelectMonth: UILabel!
    
    var selectedDate: Date?
    var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    
    var monthsArray: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedDate == nil {
            selectedDate = Date()
            calendarVw.select(selectedDate)
        }
        bgVwMonth.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        bgVwAvailibility.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        self.registerCell()
        self.setUpCalendar()
        self.setUpFonts()
        
    }
    private func registerCell(){
        calendarVw.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        let nib = UINib(nibName: "CalendarMonthCell", bundle: nil)
        monthCollectionVw.register(nib, forCellWithReuseIdentifier: "CalendarMonthCell")
        
    }
    private func setUpCalendar(){
        //        let selectedYear = Calendar.current.component(.year, from: Date()) // or any selected year
        //        monthsArray = getAllMonths(for: selectedYear) // replace with your year
        monthsArray = getAllMonths(from: 2015, to: 2035)
        
        monthCollectionVw.delegate = self
        monthCollectionVw.dataSource = self
        monthCollectionVw.reloadData()
        let currentMonthIndex = monthsArray.firstIndex(where: {
            Calendar.current.isDate($0, equalTo: Date(), toGranularity: .month)
        }) ?? 0
        
        selectedMonthIndex = currentMonthIndex
        
        DispatchQueue.main.async {
            self.monthCollectionVw.scrollToItem(at: IndexPath(item: currentMonthIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        calendarVw.appearance.headerTitleFont = FontManager.inter(.semiBold, size: 22.0)
        calendarVw.appearance.weekdayFont = FontManager.inter(.semiBold, size: 12.0)
        calendarVw.appearance.titleFont = FontManager.inter(.semiBold, size: 17.0)
        calendarVw.scrollEnabled = true
        calendarVw.allowsSelection = true
        calendarVw.allowsSelection = true
        calendarVw.locale = Locale(identifier: "en")
        calendarVw.appearance.weekdayTextColor = UIColor.black
        calendarVw.appearance.headerTitleColor = UIColor.black
        calendarVw.appearance.eventSelectionColor = UIColor.black
        self.calendarVw.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarVw.appearance.headerDateFormat = "MMMM"
        calendarVw.appearance.selectionColor = UIColor(red: 41/255, green: 158/255, blue: 245/255, alpha: 1)
        calendarVw.firstWeekday = 1
        calendarVw.appearance.todayColor = UIColor(red: 41/255, green: 158/255, blue: 245/255, alpha: 1)
        calendarVw.appearance.titleDefaultColor = .black
        calendarVw.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarVw.headerHeight = 50
        calendarVw.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarVw.delegate = self
        calendarVw.dataSource = self
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hex:"#EBEBEB")
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        calendarVw.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.topAnchor.constraint(equalTo: calendarVw.calendarWeekdayView.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: calendarVw.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: calendarVw.trailingAnchor),
            bottomLine.heightAnchor.constraint(lessThanOrEqualToConstant: 1)
        ])
    }

    private func setUpFonts(){
//        self.settingBgVw.addShadowAllSides(radius:2)
//        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_SetAvailibily.font = FontManager.inter(.medium, size: 14.0)
        lbl_HeaderSelectMonth.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Header_SelectDate.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_headrDate.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_HeaderAvailable.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_headerWorkinHour.font = FontManager.inter(.medium, size: 14.0)
        
        self.lbl_Value_Date.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_Value_Hour.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_Value_Time.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_Value_Date.text = dateToString(selectedDate ?? Date())
    }

    @IBAction func btn_previous(_ sender: Any) {
        if selectedMonthIndex > 0 {
                selectedMonthIndex -= 1
                scrollToSelectedMonth()
            }
    }
    @IBAction func btn_Next(_ sender: Any) {
        if selectedMonthIndex < monthsArray.count - 1 {
               selectedMonthIndex += 1
               scrollToSelectedMonth()
           }
    }
    
    func scrollToSelectedMonth() {
        let indexPath = IndexPath(item: selectedMonthIndex, section: 0)
        monthCollectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        let selectedMonthDate = monthsArray[selectedMonthIndex]
        calendarVw.setCurrentPage(selectedMonthDate, animated: true)

        monthCollectionVw.reloadData()
    }
    @IBAction func action_Setting(_ sender: Any) {
    }
//    func getAllMonths(for year: Int) -> [Date] {
//        var months: [Date] = []
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM"
//
//        for month in 1...12 {
//            var components = DateComponents()
//            components.year = year
//            components.month = month
//            components.day = 1
//
//            if let date = calendar.date(from: components) {
//                months.append(date)
//            }
//        }
//        return months
//    }

    func getAllMonths(from startYear: Int, to endYear: Int) -> [Date] {
        var months: [Date] = []
        let calendar = Calendar.current

        for year in startYear...endYear {
            for month in 1...12 {
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = 1

                if let date = calendar.date(from: components) {
                    months.append(date)
                }
            }
        }

        return months
    }

}
extension CalendarVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarMonthCell", for: indexPath) as? CalendarMonthCell else {
                return UICollectionViewCell()
            }

            let monthDate = monthsArray[indexPath.row]
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM" // Short name like Jan, Feb
          let month = formatter.string(from: monthDate)
            // Highlight selected
            let isSelected = indexPath.row == selectedMonthIndex
        cell.configure(month: month, isSelected: isSelected)
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMonthIndex = indexPath.row
        collectionView.reloadData()

        let selectedDate = monthsArray[indexPath.row]
        calendarVw.setCurrentPage(selectedDate, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        return CGSize(width: width / 3.75, height: height)
    }


}
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    func minimumDate(for calendar: FSCalendar) -> Date {
            return Calendar.current.date(from: DateComponents(year: 2015, month: 1, day: 1))!
        }

        func maximumDate(for calendar: FSCalendar) -> Date {
            return Calendar.current.date(from: DateComponents(year: 2035, month: 12, day: 31))!
        }
   
    // FSCalendarDataSource method
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
            cell.isHidden = false
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let currentMonth = calendar.currentPage
        let calendarUnit = Calendar.current
        
        // Extract month and year from both the current month and the date being displayed
        let currentMonthComponent = calendarUnit.dateComponents([.year, .month], from: currentMonth)
        let dateComponent = calendarUnit.dateComponents([.year, .month], from: date)
        
        // Compare to check if it's in the current month
        if currentMonthComponent.year == dateComponent.year && currentMonthComponent.month == dateComponent.month {
            return .black // Current month
        } else {
            return UIColor(hex: "#C9C9C9") // Other months
        }
    }
   
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at position: FSCalendarMonthPosition) -> Bool {
        // Prevent user from selecting today
//        if Calendar.current.isDateInToday(date) {
//            return false
//        }

        // Only allow current month's dates
        return position == .current
        
        
        /*
         
         
         
         
         
         
         
         
         */
    }


    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Deselect previously selected date (if any)
        if let previous = selectedDate {
            calendar.deselect(previous)
        }

        // Update to new selected date
        selectedDate = date
        calendar.today = nil

        print("User selected: \(dateToString(date))")
        self.lbl_Value_Date.text = dateToString(date)

        // Combine date and time (10:15 AM as example)
        let selectedDateWithTime = CalendarEventManager.combine(date: date, hour: 9, minute: 0)!
            self.showEventEditUI(with: selectedDateWithTime)
        /*
         guard let fullDate = CalendarEventManager.combine(date: selectedDate ?? Date(), hour: 10, minute: 15) else {
               print("❌ Failed to combine date and time.")
               return
           }

           // Request calendar access before saving
           CalendarEventManager.shared.requestAccess { granted in
               DispatchQueue.main.async {
                   if granted {
                       // Save to calendar
                       CalendarEventManager.shared.addEvent(
                           title: "My Task",
                           startDate: fullDate,
                           durationMinutes: 90,
                           notes: "Task created from FSCalendar"
                       )
                   } else {
                       // Show default iOS calendar permission prompt
                       self.promptCalendarAccess()
                   }
               }
           }
         */
    }
    func promptCalendarAccess() {
        let alert = UIAlertController(
            title: "Calendar Access Required",
            message: "Please allow calendar access to save tasks.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }


    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let visibleMonth = calendar.currentPage
           let components = Calendar.current.dateComponents([.year, .month], from: visibleMonth)

           if let index = monthsArray.firstIndex(where: {
               let comp = Calendar.current.dateComponents([.year, .month], from: $0)
               return comp.year == components.year && comp.month == components.month
           }) {
               selectedMonthIndex = index

               // Scroll to selected item in collection view
               monthCollectionVw.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
               monthCollectionVw.reloadData()
           }

           calendarVw.reloadData()
    }
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
   
}

//extension CalendarVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return monthsNames.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthsCollectionViewCell", for: indexPath) as! MonthsCollectionViewCell
//        cell.monthLabel.setTitle(monthsNames[indexPath.item].capitalized, for: .normal)
//
//        print("selectedIndex========",selectedIndex)
//
//
//        if indexPath.item == selectedIndex {
//            if dateArray[indexPath.item].monthSlotFull == 1 {
//                cell.monthLabel.setTitleColor(.white, for: .normal)
//                cell.monthView.backgroundColor = .red
//                fsCalenderDateSelect.isHidden = false
//                addSubView(noSeatsPopupView)
//                let isArabic = LocalStore.shared.languageType == 2
//                let adjustedIndex = isArabic ? (dateArray.count - 1 - indexPath.item) : indexPath.item
//
//                let selectedMonth = dateArray[adjustedIndex] // Get the correct selected month data
//                monthsArray.removeAll()
//
//                filteredEventDates.removeAll()
//                filteredEventDatesmultiple.removeAll()
//                for dateElement in selectedMonth.dates {
//                    print(dateElement.slots.first?.slotFull)
//                    monthsArray.append(dateElement.eventDate) // Append each eventDate to monthArray
//                }
//
//                for i in 0...(selectedMonth.dates.first?.slots.count ?? 0) - 1 {
//                    print(selectedMonth.dates.first?.slots[i].slotFull)
//
//                }
//                for dateElement in selectedMonth.dates {
//                    let allSlotsFull = dateElement.slots.allSatisfy { $0.slotFull == 1 }
//                    if allSlotsFull {
//                        filteredEventDates.append(dateElement.eventDate)
//                    }
//                }
//
//                print("filteredEventDatebothslotnotavable=====", filteredEventDates)
//
//                for dateElement in selectedMonth.dates {
//                    // Check if there is at least one slot with slotFull == 1 and one with slotFull == 0
//                    let hasSlotFullOne = dateElement.slots.contains { $0.slotFull == 1 }
//                    let hasSlotFullZero = dateElement.slots.contains { $0.slotFull == 0 }
//
//                    // If both conditions are true, append the eventDate
//                    if hasSlotFullOne && hasSlotFullZero {
//                        filteredEventDatesmultiple.append(dateElement.eventDate)
//                    }
//                }
//
//                print("filteredEventDates with mixed slotFull==1 and slotFull==0=====", filteredEventDatesmultiple)
//
//                // Set the current page of the calendar
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                if let date = dateFormatter.date(from: monthsArray[0]) {
//                    fsCalenderDateSelect.setCurrentPage(date, animated: true)
//                }
//                self.fsCalenderDateSelect.reloadData()
//
//
//
//
//
//            } else {
//                cell.monthLabel.setTitleColor(.black, for: .normal)
//                cell.monthView.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//                selectDateLabel.isHidden = false
//                fsCalenderDateSelect.isHidden = false
//
//                // Handle Arabic locale for the selected month
//                let isArabic = LocalStore.shared.languageType == 2
//                let adjustedIndex = isArabic ? (dateArray.count - 1 - indexPath.item) : indexPath.item
//
//                let selectedMonth = dateArray[adjustedIndex] // Get the correct selected month data
//                monthsArray.removeAll()
//
//                filteredEventDates.removeAll()
//                filteredEventDatesmultiple.removeAll()
//                for dateElement in selectedMonth.dates {
//                    print(dateElement.slots.first?.slotFull)
//                    monthsArray.append(dateElement.eventDate) // Append each eventDate to monthArray
//                }
//
//                for i in 0...(selectedMonth.dates.first?.slots.count ?? 0) - 1 {
//                    print(selectedMonth.dates.first?.slots[i].slotFull)
//
//                }
//                for dateElement in selectedMonth.dates {
//                    let allSlotsFull = dateElement.slots.allSatisfy { $0.slotFull == 1 }
//                    if allSlotsFull {
//                        filteredEventDates.append(dateElement.eventDate)
//                    }
//                }
//
//                print("filteredEventDatebothslotnotavable=====", filteredEventDates)
//
//                for dateElement in selectedMonth.dates {
//                    // Check if there is at least one slot with slotFull == 1 and one with slotFull == 0
//                    let hasSlotFullOne = dateElement.slots.contains { $0.slotFull == 1 }
//                    let hasSlotFullZero = dateElement.slots.contains { $0.slotFull == 0 }
//
//                    // If both conditions are true, append the eventDate
//                    if hasSlotFullOne && hasSlotFullZero {
//                        filteredEventDatesmultiple.append(dateElement.eventDate)
//                    }
//                }
//
//                print("filteredEventDates with mixed slotFull==1 and slotFull==0=====", filteredEventDatesmultiple)
//
//                // Set the current page of the calendar
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                if let date = dateFormatter.date(from: monthsArray[0]) {
//                    fsCalenderDateSelect.setCurrentPage(date, animated: true)
//                }
//                self.fsCalenderDateSelect.reloadData()
//            }
//        } else {
//            cell.monthLabel.setTitleColor(.white, for: .normal)
//            cell.monthView.backgroundColor = .black
//        }
//        if dateArray[indexPath.item].monthSlotFull == 1 {
//            cell.monthLabel.setTitleColor(.white, for: .normal)
//            cell.monthView.backgroundColor = .red
//        }
//
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width/2.5, height: collectionView.frame.size.height/1.5)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthsCollectionViewCell", for: indexPath) as! MonthsCollectionViewCell
//
//
//        cell.monthLabel.setTitleColor(.white, for: .normal)
//        cell.monthView.backgroundColor = .black
//        print("indexPath.item",indexPath.item)
//
//        selectedIndex = indexPath.item
//        selectDateLabel.isHidden = false
//        fsCalenderDateSelect.isHidden = false
//        let selectedMonth = dateArray[indexPath.item] // Get the selected month data
//        monthsArray.removeAll()
//        filteredEventDates.removeAll()
//        filteredEventDatesmultiple.removeAll()
//        for dateElement in selectedMonth.dates {
//            monthsArray.append(dateElement.eventDate) // Append each eventDate to monthArray
//        }
//        for dateElement in selectedMonth.dates {
//            // Check if all slots have slotFull == 1
//            let allSlotsFull = dateElement.slots.allSatisfy { $0.slotFull == 1 }
//
//            // If all slots have slotFull == 1, append the eventDate
//            if allSlotsFull {
//                filteredEventDates.append(dateElement.eventDate)
//            }
//        }
//
//        print("filteredEventDatebothslotnot avable=====", filteredEventDates)
//
//        for dateElement in selectedMonth.dates {
//            // Check if there is at least one slot with slotFull == 1 and one with slotFull == 0
//            let hasSlotFullOne = dateElement.slots.contains { $0.slotFull == 1 }
//            let hasSlotFullZero = dateElement.slots.contains { $0.slotFull == 0 }
//
//            // If both conditions are true, append the eventDate
//            if hasSlotFullOne && hasSlotFullZero {
//                filteredEventDatesmultiple.append(dateElement.eventDate)
//            }
//        }
//
//        print("filteredEventDateswithmixedslotFull==1andslotFull==0=====", filteredEventDatesmultiple)
//
//        print("monthsArray---",monthsArray)
//        if let dateToDeselect = stringToDate(didSelectDate) {
//            print("dateToDeselect",dateToDeselect)
//            fsCalenderDateSelect.deselect(dateToDeselect)
//            selectTimeLabel.isHidden = true
//            selectTimeStackView.isHidden = true
//
//        } else {
//            print("Invalid date format or date conversion failed.")
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        if LocalStore.shared.languageType == 1{
//            if let date = dateFormatter.date(from: monthsArray[0]) {
//                fsCalenderDateSelect.setCurrentPage(date, animated: true)
//            }
//        }
//        else{
//            if let date = dateFormatter.date(from: monthsArray[1]) {
//                fsCalenderDateSelect.setCurrentPage(date, animated: true)
//            }
//        }
//
//        self.fsCalenderDateSelect.reloadData()
//        monthsCollectionView.reloadData()
//
//    }
//    func getDateFromMonthName(monthName: String) -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM" // Format for full month name
//        return dateFormatter.date(from: monthName) // Convert to Date
//    }
//
//    func stringToDate(_ dateString: String) -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust format as needed
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.locale = Locale.current
//        return dateFormatter.date(from: dateString)
//    }
//
//
//
//    func updateVisibleDates(for month: Date) {
//        let calendar = Calendar.current
//        let monthFormatter = DateFormatter()
//        monthFormatter.dateFormat = "MMMM"
//        let currentMonthName = monthFormatter.string(from: month)
//
//        // Filter dates based on the current month
//        if let eventDays = dateArray.first(where: { $0.month == currentMonthName }) {
//            filteredDates = eventDays.dates
//        } else {
//            filteredDates.removeAll() // No dates found for the month
//        }
//        self.fsCalenderDateSelect.reloadData()
//        // Reload calendar to update displayed dates
//    }
//}
//
//

import UIKit
import EventKit
import EventKitUI

extension CalendarVC: EKEventEditViewDelegate {
    
    func showEventEditUI(with date: Date, durationMinutes: Int = 60) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                let event = EKEvent(eventStore: eventStore)
                event.title = "Backpacker"
                event.notes = "Job Added to your calendar"
                event.startDate = date
                event.endDate = Calendar.current.date(byAdding: .minute, value: durationMinutes, to: date)
                event.calendar = eventStore.defaultCalendarForNewEvents

                DispatchQueue.main.async {
                    let eventController = EKEventEditViewController()
                    eventController.eventStore = eventStore
                    eventController.event = event
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.promptCalendarAccess()
                }
            }
        }
    }

    // MARK: - EKEventEditViewDelegate
    public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
        if action == .saved {
            print("Event saved")
        } else if action == .canceled {
            print("event creation cancelled")
        } else if action == .deleted {
            print("Event deleted")
        }
    }
}
