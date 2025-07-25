//
//  EmployerController.swift
//  Backpacker
//
//  Created by Mobile on 07/07/25.
//

import UIKit
import MapKit

class EmployerController: UIViewController {
    @IBOutlet weak var mapViw: MKMapView!
    //OutLet Lables
    @IBOutlet weak var lbl_Emplyeer_Detail: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_CompletedJobs: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    //Outlet lable Values
    @IBOutlet weak var lbl_Name_Value: UILabel!
    @IBOutlet weak var lbl_CompletedJobsValue: UILabel!
    @IBOutlet weak var lbl_Address_Value: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ///  setUpAttributedText()
        setUpFonts()
        self.lbl_Emplyeer_Detail.isHidden = true
    }
    
    private func setUpFonts(){
        lbl_Emplyeer_Detail.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Location.font = FontManager.inter(.semiBold, size: 14.0)
        lbl_Name_Value.font = FontManager.inter(.semiBold, size: 13.0)
        lbl_CompletedJobsValue.font = FontManager.inter(.semiBold, size: 13.0)
        lbl_Address_Value.font = FontManager.inter(.semiBold, size: 13.0)
        lblName.font = FontManager.inter(.regular, size: 13.0)
        lbl_CompletedJobs.font = FontManager.inter(.regular, size: 13.0)
        lbl_Address.font = FontManager.inter(.regular, size: 13.0)
        
    }
    
    private func setUpAttributedText() {
        setAttributed(label: lblName, title: "Name :", value: "ABC")
        setAttributed(label: lbl_Address, title: "Address :", value: "123 Main Street")
        setAttributed(label: lbl_CompletedJobs, title: "Completed Jobs :", value: "12")
    }
    
    private func setAttributed(label: UILabel, title: String, value: String) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: label.font.pointSize),
            .foregroundColor: UIColor.label
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: label.font.pointSize),
            .foregroundColor: UIColor.label
        ]
        
        let attributedText = NSMutableAttributedString(string: "\(title) ", attributes: titleAttributes)
        attributedText.append(NSAttributedString(string: value, attributes: valueAttributes))
        label.attributedText = attributedText
    }
}
