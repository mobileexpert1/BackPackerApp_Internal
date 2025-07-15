//
//  ReportIssueTVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class ReportIssueTVC: UITableViewCell {

    @IBOutlet weak var lbl_Issue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbl_Issue.font = FontManager.inter(.regular, size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
