//
//  SubscriptionTVC.swift
//  Backpacker
//
//  Created by Mobile on 06/10/25.
//

import UIKit

class SubscriptionTVC: UITableViewCell {

    @IBOutlet weak var lbl_billed_Monthly: UILabel!
    @IBOutlet weak var bgVw: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_header: UILabel!
    var onCellTapped: ((_ indexPath: IndexPath) -> Void)?
       var indexPath: IndexPath?
    var feature1 : String?
    @IBOutlet weak var lbl_feature2: UILabel!
    var feature2: String?
    var feature3: String?
    //@IBOutlet weak var lbl_feature4: UILabel!
    var feature4: String?
    @IBOutlet weak var lbl_feature3: UILabel!
    @IBOutlet weak var lbl_feature1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUi(){
        self.bgVw.addShadowAllSides(radius: 2.0)
        self.lbl_header.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_price.font = FontManager.inter(.semiBold, size: 18.0)
        self.lbl_billed_Monthly.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_description.font = FontManager.inter(.regular, size: 14.0)
        self.lbl_feature1.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_feature2.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_feature3.font = FontManager.inter(.regular, size: 12.0)
 //     self.lbl_feature4.font = FontManager.inter(.regular, size: 12.0)
    }
    @IBAction func action_cellTapped(_ sender: Any) {
        
        if let indexPath = indexPath {
                    onCellTapped?(indexPath)
                }
    }
    func updateImage(isSelected: Bool) {
            // Change image based on selection
        self.imgVw.image = isSelected ? UIImage(named: "role_HangoutTick") : UIImage(named: "")
        if isSelected {
            bgVw.layer.borderColor = UIColor(named: "themeColor")?.cgColor
            bgVw.layer.borderWidth = 1.0
        } else {
            bgVw.layer.borderColor = UIColor.clear.cgColor
            bgVw.layer.borderWidth = 0.0
        }
        }
    
    func handlefeatureVwAppearance(){
        
    }
}
