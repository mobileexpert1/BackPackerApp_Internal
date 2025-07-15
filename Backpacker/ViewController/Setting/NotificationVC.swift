//
//  NotificationVC.swift
//  Backpacker
//
//  Created by Sahil Sharma on 12/07/25.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblMainHeader: UILabel!
    let notifications: [NotificationItem] = [
        NotificationItem(header: "Trip Reminder", subheader: "Your trip to Bali starts tomorrow. Don’t forget to pack!"),
        NotificationItem(header: "New Message", subheader: "Alex sent you a message about your upcoming trip."),
        NotificationItem(header: "Booking Confirmed", subheader: "Your stay at Mountain View Hostel has been confirmed."),
        NotificationItem(header: "Price Drop Alert", subheader: "Flights to Tokyo are 15% cheaper this week."),
        NotificationItem(header: "Trip Completed", subheader: "You’ve completed your trip to Paris. How was it? Leave a review!"),
        NotificationItem(header: "Itinerary Updated", subheader: "Your itinerary for Thailand has been updated. Check the details."),
        NotificationItem(header: "Travel Tip", subheader: "Don’t forget to carry a power adapter when visiting the UK."),
        NotificationItem(header: "Check-in Reminder", subheader: "Online check-in for your flight to Lisbon is now open."),
        NotificationItem(header: "Weather Alert", subheader: "Heavy rain forecasted in Chiang Mai tomorrow. Plan accordingly."),
        NotificationItem(header: "Travel Badge Unlocked", subheader: "You earned the “Explorer” badge for visiting 5 new countries.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblMainHeader.font = FontManager.inter(.medium, size: 16.0)
        let nib = UINib(nibName: "NotificationTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "NotificationTVC")
        
        tblVw.delegate = self
        tblVw.dataSource = self
    }


    @IBAction func action_Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
   
}
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    // Number of sections in table (usually 1 unless grouping)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as? NotificationTVC else {
            return UITableViewCell()
        }

        let item = notifications[indexPath.row]
        cell.lbl_title.text = item.header
        cell.lblSubTitle.text = item.subheader
        return cell
    }


    // Row selection (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped row \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        7
        
        
    }
}
struct NotificationItem {
    let header: String
    let subheader: String
}
