//
//  CommonRatingDistanceView.swift
//  Backpacker
//
//  Created by Mobile on 10/07/25.
//

import Foundation
import  UIKit
class CommonRatingDistanceView: UIView {

    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_Rating: UILabel!
    @IBOutlet weak var distanceTbleHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingTblHeight: NSLayoutConstraint!
    @IBOutlet weak var distanceTblVw: CommonTbleVw!
    @IBOutlet weak var ratingTbleVw: CommonTbleVw!
    var nibName = "CommonRatingDistanceView"
    var contentView: UIView?
    var filterItemSelected: ((String) -> Void)?
    // MARK: - IBOutlets connection
    @IBAction override func awakeFromNib() {
           super.awakeFromNib()
           contentView = self
       }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }


    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        contentView = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let contentView = contentView {
            addSubview(contentView)
        }
        self.ratingTbleVw.setData(["5 Star","4 Star","3 Star","2 Star","1 Star"])
        self.distanceTblVw.setData(["2Km","5Km","10Km","15Km","25Km"])
        self.distanceTbleHeight.constant = 0
        self.ratingTblHeight.constant = self.ratingTbleVw.tableHeight //+ 50.0
        self.lbl_Rating.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_Distance.font = FontManager.inter(.medium, size: 14.0)
        self.ratingTbleVw.onItemSelected = { [weak self] selectedItem in
            print("👉distanceTblVw Got selected value: \(selectedItem)")
            self?.filterItemSelected?(selectedItem)
        }
        self.distanceTblVw.onItemSelected = { [weak self] selectedItem in
            print("👉distanceTblVw Got selected value: \(selectedItem)")
            self?.filterItemSelected?(selectedItem)
        }
    }
   
    
    @IBAction func action_BtnRating(_ sender: Any) {
        self.distanceTbleHeight.constant = 0
        self.ratingTblHeight.constant = self.ratingTbleVw.tableHeight //+ 50.0
        self.ratingTbleVw.tblVw.reloadData()
    }
    
    
    @IBAction func action_Btndistance(_ sender: Any) {
        self.ratingTblHeight.constant = 0
        self.distanceTbleHeight.constant = self.distanceTblVw.tableHeight //+ 50.0
        self.distanceTblVw.tblVw.reloadData()
    }
    
}

