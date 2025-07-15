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
   
    @IBOutlet weak var lbl_SubTitle: UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           setupUI()
       }

       private func setupUI() {
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
}
