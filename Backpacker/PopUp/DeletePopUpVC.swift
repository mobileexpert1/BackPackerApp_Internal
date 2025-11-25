//
//  DeletePopUpVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class DeletePopUpVC: UIViewController {

    @IBOutlet weak var lbl_titlle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // Do any additional setup after loading the view.
        self.lbl_titlle.font = FontManager.inter(.regular, size: 18.0)
    }
    

    @IBAction func actio_Close(_ sender: Any) {
        self.dismiss(animated: true)
    }
  

}
