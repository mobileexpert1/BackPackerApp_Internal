////  FreeDateCalender.swift
////  TyKit
////  Created by Mobile on 03/10/24.
//
//import UIKit
//import FSCalendar
//
//class FreeDateCalender: UIViewController,TimerDelegate {
//    
//    @IBOutlet weak var selectTimeLabel: UILabel!
//    @IBOutlet weak var thirdView: UIView!
//    @IBOutlet weak var secondView: UIView!
//    @IBOutlet weak var firstView: UIView!
//    @IBOutlet weak var selectTimeStackView: UIStackView!
//    @IBOutlet weak var nextButton: CustomBottomButton!
//    @IBOutlet weak var thirdSelectTimeButton: UIButton!
//    @IBOutlet weak var secondSelectedTimeButton: UIButton!
//    @IBOutlet weak var firstSelectTimeButton: UIButton!
//    @IBOutlet weak var fsCalenderDateSelect: FSCalendar!
//    @IBOutlet weak var selectDateLabel: UILabel!
//    @IBOutlet weak var selectMonthLabel: UILabel!
//    @IBOutlet weak var selectedEventLabel: UILabel!
//    @IBOutlet weak var rightButton: UIButton!
//    @IBOutlet weak var leftButton: UIButton!
//    @IBOutlet weak var monthsCollectionView: UICollectionView!
//    
//    @IBOutlet var checkTicketPopUPView: unforutunaletyTicketView!
//    
//    @IBOutlet var noSeatsPopupView: UnforutunaletyNoTicketVw!
//    
//    @IBOutlet weak var statuslbl: UILabel!
//    @IBOutlet weak var availablelblcolour: UILabel!
//    @IBOutlet weak var soldoutlblcolur: UILabel!
//    @IBOutlet weak var soldOutlbl: UILabel!
//    
//    
//    @IBOutlet weak var availablelbl: UILabel!
//    
//    
//    var navigationTitle = String()
//    var backButton = UIButton()
//    var monthsNames = [String]()
//    var availableTickets = Int()
//    var eventId = Int()
//    var prefredTime = String()
//    var dateArray = [EventDay]()
//    var selectedSlot = String()
//    var selectedDate = String()
//    var monthsArray = [String]()
//    var slotsForSelectedDate = [Slot]()
//    var slotDayId = Int()
//    var selectedEventDate = String()
//    var didSelectDate = String()
//    var monthFullName = [String]()
//    var timerLabel = UILabel()
//    let monthOrder : [String] = []
//    var selectedIndex = 0
//    var filteredDates = [DateElement]()
//    var eventType = Int()
//    var homeEvenID = Int()
//    var homeEventId = Int()
//    var screenName = String()
//    var parkingType = Int()
//    var eventDeatilId = Int()
//    var addressAndTime = String()
//    var eventImage = String()
//    var customHeaderLabel: UILabel!
//    var filteredEventDates: [String] = []
//    var filteredEventDatesmultiple: [String] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("addressAndTime====",addressAndTime)
//        print("dateArray=====---====",dateArray)
//        print("slotsForSelectedDate=====---====---",slotsForSelectedDate)
//        availablelblcolour.layer.cornerRadius = availablelblcolour.frame.size.width / 2
//        availablelblcolour.clipsToBounds = true
//        soldoutlblcolur.layer.cornerRadius = soldoutlblcolur.frame.size.width / 2
//        soldoutlblcolur.clipsToBounds = true
//        checkTicketPopUPView.crossBtn.actionBlock { [self] in
//            removeView(checkTicketPopUPView)
//        }
//        noSeatsPopupView.notavalblecrosbtn.actionBlock { [self] in
//            removeView(noSeatsPopupView)
//        }
//        
//        let sortedDateArray = dateArray.sorted {
//            guard let firstMonthIndex = monthOrder.firstIndex(of: $0.month),
//                  let secondMonthIndex = monthOrder.firstIndex(of: $1.month) else {
//                return false // Handle cases where the month is not found
//            }
//            return firstMonthIndex < secondMonthIndex
//        }
//        for month in sortedDateArray {
//            print("month.month",month.month)
//        }
//        for i in 0..<sortedDateArray.count {
//            monthFullName.append(sortedDateArray[i].month)
//            let monthName = String(sortedDateArray[i].month)
//            monthsNames.append(monthName)
//        }
//        if LocalStore.shared.languageType == 2 {
//            monthsNames = monthsNames.reversed()
//        }
//        print("Final Months Names: \(monthsNames)")
//        print("monthsNames-----",monthsNames)
//        leftButton.isHidden = true
//        if monthsNames.count <= 4 {
//            leftButton.isHidden = true
//            rightButton.isHidden = true
//        } else {
//            leftButton.isHidden = false
//            rightButton.isHidden = false
//        }
//        selectedIndex = getCurrentMonthIndex() ?? 0
//        
//        dateArray.sort {
//            guard let firstIndex = monthOrder.firstIndex(of: $0.month),
//                  let secondIndex = monthOrder.firstIndex(of: $1.month) else {
//                return false
//            }
//            return firstIndex < secondIndex
//        }
//        for eventDays in dateArray {
//            print("Month: \(eventDays.month)")
//            for date in eventDays.dates {
//                print("  Event Date: \(date.eventDate)")
//                for slot in date.slots {
//                    //  print("    Slot: \(slot.time ?? ""), Day ID: \(slot.dayID), Cancelled Status: \(slot.cancelledStatus)")
//                }
//            }
//        }
//        
//        fsCalenderDateSelect.appearance.headerTitleFont = UIFont(name: "Urbanist-SemiBold", size: 22)
//        fsCalenderDateSelect.appearance.weekdayFont = UIFont(name: "Urbanist-SemiBold", size: 12)
//        fsCalenderDateSelect.appearance.titleFont = UIFont(name: "Urbanist-SemiBold", size: 17)
//        fsCalenderDateSelect.scrollEnabled = false
//        print("eventId",eventId)
//        selectDateLabel.isHidden = true
//        fsCalenderDateSelect.isHidden = true
//        selectTimeLabel.isHidden = true
//        selectTimeStackView.isHidden = true
//        nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//        nextButton.bottomButtonTitle.textColor = .black
//        nextButton.bottomButtonTitle.layer.cornerRadius  = 25
//        nextButton.bottomButtonTitle.layer.masksToBounds = true
//        firstSelectTimeButton.layer.cornerRadius = 20
//        secondSelectedTimeButton.layer.cornerRadius = 20
//        thirdSelectTimeButton.layer.cornerRadius = 20
//        nextButton.bottomButtonTitle.text = "next".localizeString()
//        registerCollectionView()
//        self.navigationController?.isNavigationBarHidden = false
//        self.title = navigationTitle
//        fsCalenderDateSelect.delegate = self
//        fsCalenderDateSelect.dataSource = self
//        fsCalenderDateSelect.allowsSelection = true
//        if LocalStore.shared.languageType == 1 {
//            fsCalenderDateSelect.locale = Locale(identifier: "en")
//            fsCalenderDateSelect.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
//            fsCalenderDateSelect.appearance.weekdayTextColor = UIColor.white
//            fsCalenderDateSelect.appearance.headerTitleColor = UIColor.white
//            fsCalenderDateSelect.appearance.eventSelectionColor = UIColor.yellowColour
//            self.fsCalenderDateSelect.appearance.headerMinimumDissolvedAlpha = 0.0
//            fsCalenderDateSelect.appearance.headerDateFormat = "MMMM"
//            fsCalenderDateSelect.appearance.selectionColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            fsCalenderDateSelect.firstWeekday = 1
//            fsCalenderDateSelect.appearance.todayColor = UIColor.clear
//            fsCalenderDateSelect.appearance.titleDefaultColor = .white
//            
//        } else {
//            
//            fsCalenderDateSelect.locale = Locale(identifier: "ar")
//            fsCalenderDateSelect.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
//            fsCalenderDateSelect.appearance.headerDateFormat = "MMMM"
//            fsCalenderDateSelect.appearance.headerTitleAlignment = .center
//            fsCalenderDateSelect.appearance.weekdayTextColor = UIColor.white
//            fsCalenderDateSelect.appearance.headerTitleColor = UIColor.white
//            fsCalenderDateSelect.appearance.eventSelectionColor = UIColor.yellowColour
//            self.fsCalenderDateSelect.appearance.headerMinimumDissolvedAlpha = 0.0
//            fsCalenderDateSelect.appearance.titleDefaultColor = .white
//            fsCalenderDateSelect.appearance.selectionColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            fsCalenderDateSelect.firstWeekday = 1
//            fsCalenderDateSelect.appearance.todayColor = UIColor.clear
//            
//        }
//        // Custom Header
//        fsCalenderDateSelect.appearance.headerMinimumDissolvedAlpha = 0.0
//        fsCalenderDateSelect.headerHeight = 50
//        fsCalenderDateSelect.calendarHeaderView.isHidden = true
//        customHeaderLabel = UILabel()
//        customHeaderLabel.textAlignment = .center
//        customHeaderLabel.font = UIFont.systemFont(ofSize: 18)
//        customHeaderLabel.frame = CGRect(x: 0, y: 0, width: fsCalenderDateSelect.frame.width, height: 50)
//        fsCalenderDateSelect.addSubview(customHeaderLabel)
//        updateCustomMonthHeader()
//        fsCalenderDateSelect.delegate = self
//        fsCalenderDateSelect.appearance.headerMinimumDissolvedAlpha = 0.0
//        fsCalenderDateSelect.headerHeight = 50 // Adjust as needed
//        fsCalenderDateSelect.calendarHeaderView.isHidden = true
//        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        backButton.setImage(UIImage(named: "backBtn"), for: .normal)
//        backButton.tintColor = .white
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        timerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 25))
//        timerLabel.textColor = UIColor(named: "YellowColour")
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: timerLabel)
//        updateTimerLabel()
//        nextButton.actionBlock { [self] in
//            if nextButton.bottomButtonTitle.backgroundColor ==  UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1) {
//                if  TimerManager.shared.countdownTimer == "00:00"{
//                    AlertFactory.showAlert(title: "Session Expired", message: "try_again".localizeString(), cancelTitle: "", okTitle: "ok".localizeString()) { [self] okTitle  in
//                        if okTitle{
//                            if let vc = UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as? DetailScreenViewController {
//                                vc.IsFrom  = "Parking"
//                                vc.featuredId = homeEvenID
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                        }
//                    }
//                }
//                else{
//                    if screenName == "DateScreenWithStructure" {
//                        self.navigationController?.navigationBar.alpha = 1
//                        LocalStore.shared.selectionValueonGuestAndLogin = "Login/Signup"
//                        let vc = UIStoryboard.init(name: "HomeScreen", bundle: Bundle.main).instantiateViewController(identifier: "StadiumViewController") as!   StadiumViewController
//                        vc.addressAndTime = self.addressAndTime
//                        vc.eventImage = self.eventImage
//                        vc.eventType = eventType
//                        vc.selectedDay = selectedEventDate
//                        vc.prefreedtime = selectedSlot
//                        vc.dayId = slotDayId
//                        vc.homeEvenID = homeEvenID
//                        vc.eventId = eventId
//                        vc.navigationTitle = navigationTitle
//                        navigationController?.pushViewController(vc, animated: true)
//                    } else if screenName == "SelectTicketViewController" {
//                        let vc = UIStoryboard.init(name: "HomeScreen", bundle: Bundle.main).instantiateViewController(identifier: "SelectTicketViewController") as! SelectTicketViewController
//                        vc.addressAndTime = self.addressAndTime
//                        vc.eventImage = self.eventImage
//                        vc.selectedDate = selectedEventDate
//                        vc.dayId = slotDayId
//                        vc.homeEventId = homeEventId
//                        vc.eventId = eventId
//                        vc.prefredTime = selectedSlot
//                        vc.parkingType = parkingType
//                        vc.eventDeatilId = eventDeatilId
//                        vc.navigationTitle = navigationTitle
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    } else {
//                        let vc = UIStoryboard.init(name: "HomeScreen", bundle: Bundle.main).instantiateViewController(identifier: "FreeEntryViewController") as! FreeEntryViewController
//                        vc.addressAndTime = self.addressAndTime
//                        vc.eventImage = self.eventImage
//                        vc.eventId = self.eventId
//                        vc.prefredTime = prefredTime
//                        vc.navigationTitle = navigationTitle
//                        vc.availableTickets = availableTickets
//                        vc.slotDayId = slotDayId
//                        vc.selectedSlot = selectedSlot
//                        vc.selectedEventDate = selectedEventDate
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    func updateCustomMonthHeader() {
//        customHeaderLabel.text = getMonthString(from: fsCalenderDateSelect.currentPage)
//        customHeaderLabel.textColor = .white
//        
//    }
//    
//    
//    func getMonthString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: fsCalenderDateSelect.locale.identifier)
//        formatter.dateFormat = "MMMM"
//        return formatter.string(from: date)
//    }
//    
//    
//    func localization() {
//        selectedEventLabel.text = "select_Event_Schedule".localizeString()
//        selectMonthLabel.text = "select_Month".localizeString()
//        selectDateLabel.text = "select_day".localizeString()
//        selectTimeLabel.text = "select_Time".localizeString()
//        statuslbl.text = "status".localizeString()
//        soldOutlbl.text = "sold_out".localizeString()
//        availablelbl.text = "available".localizeString()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        localization()
//        TimerManager.shared.delegate = self
//        if LocalStore.shared.languageType == 1 {
//        } else {
//            self.backButton.transform = self.backButton.transform.rotated(by: CGFloat(.pi * 0.999))
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        if LocalStore.shared.languageType == 1 {
//        } else {
//            self.backButton.transform = self.backButton.transform.rotated(by: CGFloat(.pi * 0.999))
//        }
//    }
//    
//    func registerCollectionView() {
//        monthsCollectionView.register(UINib(nibName: "MonthsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MonthsCollectionViewCell")
//        monthsCollectionView.delegate = self
//        monthsCollectionView.dataSource = self
//    }
//    
//    @objc func backButtonTapped () {
//        navigationController?.popViewController(animated: true)
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    
//    func printCurrentMonth()-> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM"
//        var currentMonth = ""
//        if LocalStore.shared.languageType == 1{
//            dateFormatter.locale = Locale(identifier: "en")
//            currentMonth = dateFormatter.string(from: Date())
//        }
//        else{
//            dateFormatter.locale = Locale(identifier: "ar")
//            currentMonth = dateFormatter.string(from: Date())
//        }
//        
//        return currentMonth
//    }
//    
//    func timerDidUpdate(with timeString: String) {
//        updateTimerLabel()
//    }
//    
//    private func updateTimerLabel() {
//        let timeLeftString = "time_left".localizeString() + " \(TimerManager.shared.countdownTimer)"
//        timerLabel.text = timeLeftString
//        
//    }
//    
//    func getCurrentMonthIndex() -> Int? {
//        let currentMonth = printCurrentMonth() // Get the current month name
//        if let index = monthFullName.firstIndex(of: currentMonth) {
//            print("index---------", index)
//            let isArabic = LocalStore.shared.languageType == 2
//            
//            if isArabic {
//                return monthFullName.count - 1 - index
//            }
//            return index
//        }
//        return nil
//    }
//    
//    
//    
//    
//    @IBAction func thirdSelectTimeButtonAction(_ sender: UIButton) {
//        
//        
//        if firstSelectTimeButton.backgroundColor == .red {
//            firstSelectTimeButton.backgroundColor = .red
//            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//            
//        } else {
//            firstSelectTimeButton.backgroundColor = .black
//            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//        }
//        if secondSelectedTimeButton.backgroundColor == .red {
//            secondSelectedTimeButton.backgroundColor = .red
//            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//        } else {
//            secondSelectedTimeButton.backgroundColor = .black
//            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//        }
//        if thirdSelectTimeButton.backgroundColor == .red {
//            thirdSelectTimeButton.backgroundColor = .red
//            thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//            
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//            if slotsForSelectedDate[2].slotFull == 1 {
//                // slott not avalble
//                addSubView(noSeatsPopupView)
//            }
//            else if slotsForSelectedDate[2].slotFull == 2 {
//                // show popup
//               // addSubView(checkTicketPopUPView)
//            }
//        } else {
//            thirdSelectTimeButton.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            thirdSelectTimeButton.setTitleColor(.black, for: .normal)
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//        }
//        
//        if slotsForSelectedDate.count == 1 {
//            firstView.borderColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
//            
//        } else if slotsForSelectedDate.count == 2 {
//            firstView.borderColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
//            secondView.borderColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
//        } else {
//            firstView.borderColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
//            secondView.borderColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
//            thirdView.borderColor = .clear
//        }
//        
//        selectedSlot = slotsForSelectedDate[2].time ?? ""
//        slotDayId = slotsForSelectedDate[2].dayID
//    }
//    
//    @IBAction func secondSelectedTimeButtonAction(_ sender: UIButton) {
//        
//        if firstSelectTimeButton.backgroundColor == .red {
//            firstSelectTimeButton.backgroundColor = .red
//            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//            
//        } else {
//            firstSelectTimeButton.backgroundColor = .black
//            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//        }
//        if secondSelectedTimeButton.backgroundColor == .red {
//            secondSelectedTimeButton.backgroundColor = .red
//            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//            
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//            if slotsForSelectedDate[1].slotFull == 1 {
//                // slott not avalble
//                addSubView(noSeatsPopupView)
//            }
//            else if slotsForSelectedDate[1].slotFull == 2 {
//                // show popup
//              //  addSubView(checkTicketPopUPView)
//            }
//        } else{
//            secondSelectedTimeButton.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            secondSelectedTimeButton.setTitleColor(.black, for: .normal)
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//        }
//        if thirdSelectTimeButton.backgroundColor == .red {
//            thirdSelectTimeButton.backgroundColor = .red
//            thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//        } else {
//            thirdSelectTimeButton.backgroundColor = .black
//            thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//        }
//        
//        if slotsForSelectedDate.count == 1 {
//            firstView.borderColor = .white
//            
//        } else if slotsForSelectedDate.count == 2{
//            firstView.borderColor = .white
//            secondView.borderColor = .clear
//        } else {
//            firstView.borderColor = .white
//            secondView.borderColor = .clear
//            thirdView.borderColor = .white
//        }
//        
//        selectedSlot = slotsForSelectedDate[1].time ?? ""
//        slotDayId = slotsForSelectedDate[1].dayID
//        
//    }
//    
//    @IBAction func firstSelectTimeButtonAction(_ sender: UIButton) {
//        
//        if firstSelectTimeButton.backgroundColor == .red {
//            firstSelectTimeButton.setTitleColor(.white, for: .normal)
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//            if slotsForSelectedDate[0].slotFull == 1 {
//                // slot not avalble
//                addSubView(noSeatsPopupView)
//            }
//            else if slotsForSelectedDate[0].slotFull == 2 {
//                // show popup
//               // addSubView(checkTicketPopUPView)
//            }
//        } else {
//            firstSelectTimeButton.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            firstSelectTimeButton.setTitleColor(.black, for: .normal)
//            nextButton.bottomButtonTitle.backgroundColor = UIColor(red: 250/255, green: 187/255, blue: 60/255, alpha: 1)
//            nextButton.bottomButtonTitle.textColor = .black
//        }
//        if secondSelectedTimeButton.backgroundColor == .red {
//            secondSelectedTimeButton.backgroundColor = .red
//            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//        } else {
//            secondSelectedTimeButton.backgroundColor = .black
//            secondSelectedTimeButton.setTitleColor(.white, for: .normal)
//        }
//        
//        if thirdSelectTimeButton.backgroundColor == .red {
//            thirdSelectTimeButton.backgroundColor = .red
//            thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//        } else {
//            thirdSelectTimeButton.backgroundColor = .black
//            thirdSelectTimeButton.setTitleColor(.white, for: .normal)
//        }
//        
//        if slotsForSelectedDate.count == 1 {
//            firstView.borderColor = .clear
//            
//        } else if slotsForSelectedDate.count == 2 {
//            firstView.borderColor = .clear
//            secondView.borderColor = .white
//        } else {
//            firstView.borderColor = .clear
//            secondView.borderColor = .white
//            thirdView.borderColor = .white
//        }
//        selectedSlot = slotsForSelectedDate[0].time ?? ""
//        slotDayId = slotsForSelectedDate[0].dayID
//        
//    }
//    
//    @IBAction func rightButtonAction(_ sender: UIButton) {
//        // Get the currently visible index paths
//        let visibleItems: NSArray = self.monthsCollectionView.indexPathsForVisibleItems as NSArray
//        
//        guard let currentItem = visibleItems.firstObject as? IndexPath else { return }
//        let nextItemIndex = currentItem.item + 1
//        if nextItemIndex < monthsNames.count {
//            self.monthsCollectionView.scrollToItem(at: IndexPath(item: nextItemIndex, section: 0), at: .left, animated: true)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
//                let visibleCount = monthsNames.count
//                let endIndex = min(nextItemIndex + visibleCount - 1, self.monthsNames.count - 1)
//                self.monthsCollectionView.scrollToItem(at: IndexPath(item: endIndex, section: 0), at: .left, animated: true)
//            }
//        }
//    }
//    
//    @IBAction func leftButtonAction(_ sender: UIButton) {
//        // Get the currently visible index paths
//        let visibleItems: NSArray = self.monthsCollectionView.indexPathsForVisibleItems as NSArray
//        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
//        if nextItem.row < monthsNames.count {
//            self.monthsCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
//        }
//    }
//}
//extension FreeDateCalender : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
//extension FreeDateCalender: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
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
