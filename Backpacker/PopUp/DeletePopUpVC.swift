//
//  DeletePopUpVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class DeletePopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actio_Close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
