//
//  HomeCollectionCellCollectionViewCell.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class HomeJobCVC: UICollectionViewCell {

    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var duration_Vw: UIView!
    @IBOutlet weak var btn_fav: UIButton!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var mainView: UIView!
   
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var tap_Button: UIButton!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    // Closure to handle tap
    @IBOutlet weak var lbl_AmountHeight: NSLayoutConstraint!  // 20 in UI
    
    @IBOutlet weak var statusVw: UIView!
    @IBOutlet weak var lbl_jobStatus: UILabel!
    var onTap: ((Int) -> Void)?
    var isComeFormAccpetedJobs : Bool = false
    var isComeForHiredetailpage : Bool = false
    var indexPath : Int = 0
    override func awakeFromNib() {
           super.awakeFromNib()
           setupUI()
        tap_Button.addTarget(self, action: #selector(tapButtonTapped), for: .touchUpInside)
        

       }
    func setUpUI(iscomeFromAccept : Bool = false,isComeForHiredetailpagee : Bool = false){
#if BackpackerHire
        
        if iscomeFromAccept {
            self.lbl_AmountHeight.constant = 20.0
            self.lbl_jobStatus.isHidden = false
            self.statusVw.isHidden = false
        }else{
            if isComeForHiredetailpagee == true{
                self.lbl_AmountHeight.constant = 20.0
                self.lbl_jobStatus.isHidden = true
                self.statusVw.isHidden = true
            }else{
                self.lbl_AmountHeight.constant = 0.0
                self.lbl_jobStatus.isHidden = true
                self.statusVw.isHidden = true
            }
            
        }
    
        #else
        self.lbl_AmountHeight.constant = 0.0
        self.lbl_jobStatus.isHidden = true
        self.statusVw.isHidden = true
        
#endif
    }
       private func setupUI() {
           self.lbl_jobStatus.font = FontManager.inter(.medium, size: 10.0)
           self.lblAmount.font = FontManager.inter(.medium, size: 12.0)
           lbl_Title.font = FontManager.inter(.medium, size: 14.0)
           lbl_Address.font = FontManager.inter(.regular, size: 12.0)
           lbl_duration.font = FontManager.inter(.regular, size: 10.0)
           mainView.layer.cornerRadius = 10
           mainView.clipsToBounds = false
           mainView.layer.cornerRadius = 10
           mainView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor

           mainView.layer.shadowOpacity = 0.2
           mainView.layer.shadowOffset = CGSize(width: 0, height: 0) // all sides
           mainView.layer.shadowRadius = 2
           mainView.layer.masksToBounds = false
           duration_Vw.layer.cornerRadius = 15
           duration_Vw.clipsToBounds = true
           
       }
    @objc private func tapButtonTapped() {
        onTap?(indexPath)
    }
}
