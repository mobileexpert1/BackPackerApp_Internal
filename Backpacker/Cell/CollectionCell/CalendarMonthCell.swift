//
//  CalendarMonthCell.swift
//  Backpacker
//
//  Created by Mobile on 16/07/25.
//

import UIKit

class CalendarMonthCell: UICollectionViewCell {

    @IBOutlet weak var lbl_Month: UILabel!
    @IBOutlet weak var bgVw: UIView!
    override func awakeFromNib() {
           super.awakeFromNib()
        bgVw.layer.cornerRadius = 12
        bgVw.clipsToBounds = true
       }

       func configure(month: String, isSelected: Bool) {
           lbl_Month.text = month
           bgVw.backgroundColor = isSelected ? UIColor(hex: "#7EB268") : UIColor(hex: "#F6FAF5")
           lbl_Month.textColor = isSelected ? .white : .black
           lbl_Month.font = FontManager.inter(.semiBold, size: 25.0) 
       }

}
