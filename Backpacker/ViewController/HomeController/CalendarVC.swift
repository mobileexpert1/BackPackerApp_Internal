//
//  CalendarVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
//extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
//    func calendar(_ calendar: FSCalendar, willDisplayHeader header: UIView, for date: Date) {
//        // Add a line under the header
//        let line = UIView(frame: CGRect(x: 0, y: header.bounds.height - 1, width: header.bounds.width, height: 1))
//        line.backgroundColor = .gray // Change color as needed
//        header.addSubview(line)
//    }
//    
//    
//    
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
//    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let dateString = dateToString(date) // Convert selected date to string
//        didSelectDate = dateString
//        nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//        nextButton.bottomButtonTitle.textColor = .black
//        // Check if the selected date is in `monthsArray`
//        if monthsArray.contains(dateString) {
//            
//            if filteredEventDates.contains(dateString){
//                selectTimeStackView.isHidden = true
//                selectTimeLabel.isHidden = true
//                nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//                nextButton.bottomButtonTitle.textColor = .black
//                // all not avalible
//            }
//            else{
//                
//                // Find the matching DateElement within dateArray
//                if let matchingEvent = dateArray.first(where: { eventDay in
//                    eventDay.dates.contains(where: { $0.eventDate == dateString })
//                }),
//                   let matchingDate = matchingEvent.dates.first(where: { $0.eventDate == dateString }) {
//                    selectedEventDate = matchingDate.eventDate
//                    // Show selectTimeStackView and selectTimeLabel since the date was found
//                    selectTimeStackView.isHidden = false
//                    selectTimeLabel.isHidden = false
//                    firstSelectTimeButton.backgroundColor = .black
//                    firstSelectTimeButton.setTitleColor(.white, for: .normal)
//                    secondSelectedTimeButton.backgroundColor = .black
//                    secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//                    thirdSelectTimeButton.backgroundColor = .black
//                    thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//                    firstView.borderWidth = 1
//                    secondView.borderWidth = 1
//                    
//                    thirdView.borderWidth = 1
//                    firstView.borderColor = .white
//                    secondView.borderColor = .white
//                    thirdView.borderColor = .white
//                    // Retrieve slots for the selected date
//                    slotsForSelectedDate = matchingDate.slots
//                    print("Slots for selected date: \(slotsForSelectedDate)")
//                    print("Slots matchingDate.slots: \(String(describing: matchingDate.slots.first?.slotFull))")
//                    // Update the UI based on the number of slots
//                    if slotsForSelectedDate.count == 1 {
//                        firstSelectTimeButton.isHidden = false
//                        secondSelectedTimeButton.isHidden = true
//                        thirdSelectTimeButton.isHidden = true
//                        firstView.borderWidth = 1
//                        secondView.borderWidth = 0
//                        thirdView.borderWidth = 0
//                        firstSelectTimeButton.setTitle(slotsForSelectedDate[0].time, for: .normal)
//                    } else if slotsForSelectedDate.count == 2 {
//                        firstSelectTimeButton.isHidden = false
//                        secondSelectedTimeButton.isHidden = false
//                        thirdSelectTimeButton.isHidden = true
//                        firstView.borderWidth = 1
//                        secondView.borderWidth = 1
//                        thirdView.borderWidth = 0
//                        
//                        if slotsForSelectedDate[0].slotFull == 1 {
//                            firstSelectTimeButton.backgroundColor = .red
//                            firstView.borderWidth = 0
//                            firstView.borderColor = .clear
//                            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//                            
//                        }
//                        if  slotsForSelectedDate[1].slotFull == 1 {
//                            secondSelectedTimeButton.backgroundColor = .red
//                            secondView.borderWidth = 0
//                            secondView.borderColor = .clear
//                            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//                            
//                        }
//                        
//                        firstSelectTimeButton.setTitle(slotsForSelectedDate[0].time, for: .normal)
//                        secondSelectedTimeButton.setTitle(slotsForSelectedDate[1].time, for: .normal)
//                    } else if slotsForSelectedDate.count == 3 {
//                        firstSelectTimeButton.isHidden = false
//                        secondSelectedTimeButton.isHidden = false
//                        thirdSelectTimeButton.isHidden = false
//                        firstView.borderWidth = 1
//                        secondView.borderWidth = 1
//                        thirdView.borderWidth = 1
//                        if slotsForSelectedDate[0].slotFull == 1 {
//                            firstSelectTimeButton.backgroundColor = .red
//                            firstView.borderWidth = 0
//                            firstView.borderColor = .clear
//                            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//                            
//                        }
//                        if  slotsForSelectedDate[1].slotFull == 1 {
//                            secondSelectedTimeButton.backgroundColor = .red
//                            secondView.borderWidth = 0
//                            secondView.borderColor = .clear
//                            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//                        }
//                        if  slotsForSelectedDate[2].slotFull == 1 {
//                            thirdSelectTimeButton.backgroundColor = .red
//                            thirdView.borderWidth = 0
//                            thirdView.borderColor = .clear
//                            thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//                        }
//                        firstSelectTimeButton.setTitle(slotsForSelectedDate[0].time, for: .normal)
//                        secondSelectedTimeButton.setTitle(slotsForSelectedDate[1].time, for: .normal)
//                        thirdSelectTimeButton.setTitle(slotsForSelectedDate[2].time, for: .normal)
//                    } else {
//                        selectTimeStackView.isHidden = true
//                        selectTimeLabel.isHidden = true
//                        nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//                        nextButton.bottomButtonTitle.textColor = .black
//                    }
//                } else {
//                    // Hide selectTimeStackView and selectTimeLabel if the date is not found in dateArray
//                    selectTimeStackView.isHidden = true
//                    selectTimeLabel.isHidden = true
//                    nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//                    nextButton.bottomButtonTitle.textColor = .black
//                }
//            }
//        } else {
//            // If the selected date is not in `monthsArray`, hide the stack view and reset UI
//            selectTimeStackView.isHidden = true
//            selectTimeLabel.isHidden = true
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//        }
//    }
//    // FSCalendarDataSource method
//    
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
//        if position != .current {
//            // Hide dates that are not in the current month
//            cell.isHidden = true
//            // Optional: hide the text color as well
//        } else {
//            cell.isHidden = false
//            // Optional: show the text color
//        }
//    }
//    
//    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        // Convert the selected date to a string in "yyyy-MM-dd" format
//        let dateString = dateToString(date) // Ensure this outputs correctly as "yyyy-MM-dd"
//        
//        // Debug print statements
//        print("Date String for Calendar: \(dateString)")
//        print("Months Array: \(monthsArray)")
//        
//        // Check if today’s date is in `monthsArray` and is today's date
//        if monthsArray.contains(dateString) && Calendar.current.isDateInToday(date) {
//            print("Today's date matches in monthsArray: \(dateString)")
//            return UIColor(red: 252/255, green: 196/255, blue: 52/255, alpha: 1.0) // Yellow color for today's date if it exists in `monthsArray`
//        }
//        if filteredEventDates.contains(dateString) {
//            
//            return .red
//        }
//        else{
//            // Check if `dateString` exists in the `monthsArray`
//            if monthsArray.contains(dateString) {
//                print("Date exists in monthsArray: \(dateString)")
//                return UIColor(red: 252/255, green: 196/255, blue: 52/255, alpha: 1.0) // Yellow color for other dates in `monthsArray`
//            } else {
//                
//                print("Date does not exist in monthsArray: \(dateString)")
//                return .white // Default color for dates not in `monthsArray`
//            }
//        }
//    }
//    
//    func dateToString(_ date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.string(from: date)
//    }
//    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at position: FSCalendarMonthPosition) -> Bool {
//        // Convert the selected date to a string in "yyyy-MM-dd" format
//        let dateString = dateToString(date) // Ensure this outputs correctly as "yyyy-MM-dd"
//        
//        // Check if `dateString` exists in the `monthsArray`
//        if monthsArray.contains(dateString) {
//            if filteredEventDates.contains(dateString) {
//                addSubView(noSeatsPopupView)
//                return false
//            } else {
//                
//                return true
//            }
//            // Allow user interaction for dates in `monthsArray`
//        } else {
//            return false // Disable user interaction for dates not in `monthsArray`
//        }
//    }
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        print("Current month changed to: \(calendar.currentPage)")
//        // You can perform any updates needed for the new month here.
//        //rohit
//        updateCustomMonthHeader()
//        
//    }
//    
//    
//}
//
