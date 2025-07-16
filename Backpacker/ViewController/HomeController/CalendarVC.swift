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
    var monthsArray: [Date] = []
    var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1

    override func viewDidLoad() {
        super.viewDidLoad()
        bgVwMonth.addShadowAllSides(radius:2)
        bgVwAvailibility.addShadowAllSides(radius:2)
        let nib = UINib(nibName: "CalendarMonthCell", bundle: nil)
        monthCollectionVw.register(nib, forCellWithReuseIdentifier: "CalendarMonthCell")
        let selectedYear = Calendar.current.component(.year, from: Date()) // or any selected year
        monthsArray = getAllMonths(for: selectedYear) // replace with your year
        monthCollectionVw.delegate = self
        monthCollectionVw.dataSource = self
        monthCollectionVw.reloadData()

        calendarVw.addShadowAllSides(radius:2)
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
        
        self.lbl_headrDate.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_HeaderAvailable.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_headerWorkinHour.font = FontManager.inter(.medium, size: 14.0)
        
        self.lbl_Value_Date.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_Value_Hour.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_Value_Time.font = FontManager.inter(.regular, size: 14.0)
    }
    

    func getAllMonths(for year: Int) -> [Date] {
        var months: [Date] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"

        for month in 1...12 {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1

            if let date = calendar.date(from: components) {
                months.append(date)
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
            cell.lbl_Month.text = formatter.string(from: monthDate)

            // Highlight selected
            let isSelected = indexPath.row == selectedMonthIndex
            cell.bgVw.backgroundColor = isSelected ? UIColor.systemBlue : UIColor.systemGray6
            cell.lbl_Month.textColor = isSelected ? .white : .black
            cell.lbl_Month.font = isSelected ? .boldSystemFont(ofSize: 17) : .systemFont(ofSize: 17)

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
        return CGSize(width: width / 4, height: height)
    }


}
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, willDisplayHeader header: UIView, for date: Date) {
        // Add a line under the header
        let line = UIView(frame: CGRect(x: 0, y: header.bounds.height - 1, width: header.bounds.width, height: 1))
        line.backgroundColor = .gray // Change color as needed
        header.addSubview(line)
    }
    
    
    
//    private func calendar(_ calendar: FSCalendar, headerFor date: Date) -> UIView {
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        
//        let label = UILabel()
//        label.text = "Week" // Add your week title here
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        
//        let line = UIView()
//        line.backgroundColor = .gray // Change color as needed
//        line.translatesAutoresizingMaskIntoConstraints = false
//        
//        headerView.addSubview(label)
//        headerView.addSubview(line)
//        
//        // Set up constraints
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: headerView.topAnchor),
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
//            
//            line.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
//            line.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//            line.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
//            line.heightAnchor.constraint(equalToConstant: 1),
//            line.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
//        ])
//        
//        return headerView
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = dateToString(date)
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

    
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at position: FSCalendarMonthPosition) -> Bool {
        // Only allow selection for dates in the current month
        return position == .current
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

