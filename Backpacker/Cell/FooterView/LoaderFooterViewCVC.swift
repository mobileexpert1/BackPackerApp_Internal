//
//  LoaderFooterViewCVC.swift
//  Backpacker
//
//  Created by Mobile on 07/08/25.
//

import UIKit

class LoaderFooterViewCVC: UICollectionReusableView {

    @IBOutlet weak var lbl_fetching: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbl_fetching.font = FontManager.inter(.medium, size: 12.0)
    }
    
}
