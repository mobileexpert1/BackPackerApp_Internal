//
//  FilterVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var sortTableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ViewHeight.constant = UIScreen.main.bounds.height / 2
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainView.clipsToBounds = true

    }
    

 

}
