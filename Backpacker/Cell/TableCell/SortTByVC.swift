//
//  SortTByVC.swift
//  Backpacker
//
//  Created by Mobile on 25/07/25.
//

import UIKit

class SortTByVC: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwSort: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.font = FontManager.inter(.regular, size: 13.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
