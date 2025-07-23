//
//  CommonEmpListTVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit
import Cosmos
class CommonEmpListTVC: UITableViewCell {

    @IBOutlet weak var cosmosVw: CosmosView!
    var iscomeFormEmloyee : Bool = true
    
    @IBOutlet weak var mainBgVw: UIView!
    @IBOutlet weak var lblname_topContraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_CompletedJobs: UILabel!
    @IBOutlet weak var bgV: UIView!
    
    @IBOutlet weak var lbl_FrstLetter: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainBgVw.addShadowAllSides(radius: 2.0)
        self.setUpUI()
        self.setupConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpUI(){
        self.lbl_Name.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_CompletedJobs.font = FontManager.inter(.regular, size: 12.0)
        self.lbl_FrstLetter.font = FontManager.inter(.medium, size: 22.0)
    }
    func setupConstraint(iscomeFormEmloyeeee:Bool = false){
        if iscomeFormEmloyeeee == true{
            self.lblname_topContraint.constant = 13
            self.lbl_CompletedJobs.isHidden = true
        }else{
            self.lblname_topContraint.constant = 7
            self.lbl_CompletedJobs.isHidden = false
        }
    }
}
