//
//  EmployerCalendarVC.swift
//  Backpacker
//
//  Created by Mobile on 30/07/25.
//

import UIKit
import FSCalendar

class EmployerCalendarVC: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var Vw_Month: UIView!
    
    @IBOutlet weak var haderSelectDate: UILabel!
    @IBOutlet weak var lbl_SelectedYear: UILabel!
    @IBOutlet weak var header_selctMonth: UILabel!
    
    
    @IBOutlet weak var header_backpackers: UILabel!
    
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var calendarVw: FSCalendar!
    
    var selectedDate: Date?
    var selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    
    @IBOutlet weak var scroll_Height: NSLayoutConstraint!
    var monthsArray: [Date] = []
    @IBOutlet weak var tbl_Heught: NSLayoutConstraint!
    private var yearPicker: UIPickerView!
        private var years: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedDate == nil {
            selectedDate = Date()
            calendarVw.select(selectedDate)
        }
        Vw_Month.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        // Do any additional setup after loading the view.
        self.registerCell()
        self.setUpFonts()
        self.setUpCalendar()
        let currentYear = Calendar.current.component(.year, from: Date())
                years = Array(currentYear...2035)
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        tblVw.isScrollEnabled = false
        tblVw.reloadData()

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.tbl_Heught.constant = 1 * 92 //10 is number of item of backpacker list and 92 is row height
            self.scroll_Height.constant = (self.scroll_Height.constant ) + self.tbl_Heught.constant
            self.view.layoutIfNeeded()
        }
        self.lbl_SelectedYear.isHidden = true
      
    }
    
    private func setUpFonts(){
        self.header_backpackers.font = FontManager.inter(.medium, size: 14.0)
        self.header_selctMonth.font = FontManager.inter(.medium, size: 14.0)
        self.haderSelectDate.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_SelectedYear.font = FontManager.inter(.regular, size: 14.0)
    }
    
    private func registerCell(){
        calendarVw.addShadowAllSides(color: UIColor(hex: "#BDBDBD40"),opacity: 0.25,radius:2)
        let nib = UINib(nibName: "CalendarMonthCell", bundle: nil)
        collVw.register(nib, forCellWithReuseIdentifier: "CalendarMonthCell")
        
        tblVw.register(UINib(nibName: "CommonEmpListTVC", bundle: nil), forCellReuseIdentifier: "CommonEmpListTVC")
    }
    private func setUpCalendar(){
        //        let selectedYear = Calendar.current.component(.year, from: Date()) // or any selected year
        //        monthsArray = getAllMonths(for: selectedYear) // replace with your year
        monthsArray = getAllMonths(from: 2015, to: 2035)
        
        collVw.delegate = self
        collVw.dataSource = self
        collVw.reloadData()
        let currentMonthIndex = monthsArray.firstIndex(where: {
            Calendar.current.isDate($0, equalTo: Date(), toGranularity: .month)
        }) ?? 0
        
        selectedMonthIndex = currentMonthIndex
        
        DispatchQueue.main.async {
            self.collVw.scrollToItem(at: IndexPath(item: currentMonthIndex, section: 0), at: .centeredHorizontally, animated: false)
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
    
    @IBAction func action_previous(_ sender: Any) {
        
        if selectedMonthIndex > 0 {
                selectedMonthIndex -= 1
                scrollToSelectedMonth()
            }
    }
    
    @IBAction func action_next(_ sender: Any) {
        if selectedMonthIndex < monthsArray.count - 1 {
               selectedMonthIndex += 1
               scrollToSelectedMonth()
           }
        
        
    }
    
    
    func scrollToSelectedMonth() {
        let indexPath = IndexPath(item: selectedMonthIndex, section: 0)
        collVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        let selectedMonthDate = monthsArray[selectedMonthIndex]
        calendarVw.setCurrentPage(selectedMonthDate, animated: true)

        collVw.reloadData()
    }
    @IBAction func action_SelectYear(_ sender: Any) {
        
      //  self.ShowYearPicker()
    }
}



extension EmployerCalendarVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
extension EmployerCalendarVC: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
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
        return position == .current
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
    //    self.lbl_Value_Date.text = dateToString(date)

        // Combine date and time (10:15 AM as example)
        let selectedDateWithTime = CalendarEventManager.combine(date: date, hour: 9, minute: 0)!
            self.showEventEditUI(with: selectedDateWithTime)
        /*
         guard let fullDate = CalendarEventManager.combine(date: selectedDate ?? Date(), hour: 10, minute: 15) else {
               print("- Failed to combine date and time.")
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
               collVw.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
               collVw.reloadData()
           }

           calendarVw.reloadData()
    }
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
   
}


import UIKit
import EventKit
import EventKitUI

extension EmployerCalendarVC: EKEventEditViewDelegate {
    
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


extension EmployerCalendarVC :  UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - PickerView Delegate & DataSource

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return years.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return "\(years[row])"
       }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30 // each row 50 points tall
    }

    @objc func didSelectYear() {
          let selectedRow = yearPicker.selectedRow(inComponent: 0)
          let selectedYear = years[selectedRow]
      //  self.lbl_Year.text = "\(selectedYear)"
          dismiss(animated: true)
      }
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
    func ShowYearPicker() {
           // 1. Picker and Toolbar
           yearPicker = UIPickerView()
           yearPicker.delegate = self
           yearPicker.dataSource = self
           yearPicker.backgroundColor = .systemBackground
           yearPicker.translatesAutoresizingMaskIntoConstraints = false

           let toolbar = UIToolbar()
           toolbar.translatesAutoresizingMaskIntoConstraints = false
           toolbar.setItems([
               UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
               UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didSelectYear))
           ], animated: false)
           toolbar.backgroundColor = .systemBackground

           // 2. Picker container view
           let pickerContainer = UIView()
           pickerContainer.backgroundColor = .systemBackground
           pickerContainer.translatesAutoresizingMaskIntoConstraints = false

           pickerContainer.addSubview(toolbar)
           pickerContainer.addSubview(yearPicker)

           NSLayoutConstraint.activate([
               toolbar.topAnchor.constraint(equalTo: pickerContainer.topAnchor),
               toolbar.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor),
               toolbar.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor),
               toolbar.heightAnchor.constraint(equalToConstant: 50),

               yearPicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
               yearPicker.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor),
               yearPicker.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor),
               yearPicker.bottomAnchor.constraint(equalTo: pickerContainer.bottomAnchor),
               yearPicker.heightAnchor.constraint(equalToConstant: 200)
           ])

           // 3. Dimmed background VC
           let dimmedVC = UIViewController()
           dimmedVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
           dimmedVC.modalPresentationStyle = .overFullScreen

           // 4. Add picker container to dimmedVC
           dimmedVC.view.addSubview(pickerContainer)
           NSLayoutConstraint.activate([
               pickerContainer.leadingAnchor.constraint(equalTo: dimmedVC.view.leadingAnchor),
               pickerContainer.trailingAnchor.constraint(equalTo: dimmedVC.view.trailingAnchor),
               pickerContainer.bottomAnchor.constraint(equalTo: dimmedVC.view.bottomAnchor)
           ])

           // 5. Present
           self.present(dimmedVC, animated: true)
       }

}



extension EmployerCalendarVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // or your dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonEmpListTVC", for: indexPath) as? CommonEmpListTVC else {
            return UITableViewCell()
        }
        cell.setupConstraint(iscomeFormEmloyeeee: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
