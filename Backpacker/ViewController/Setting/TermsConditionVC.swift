//
//  TermsConditionVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class TermsConditionVC: UIViewController {

    @IBOutlet weak var lbl_Header: UILabel!
    @IBOutlet weak var txt_Vw: UITextView!
    var isComeFromPrivacy = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if isComeFromPrivacy{
            self.lbl_Header.text = "Privacy Policy"
        }else{
            self.lbl_Header.text = "Terms & Conditions"
        }
        self.lbl_Header.font = FontManager.inter(.medium, size: 16.0)
        self.txt_Vw.font = FontManager.inter(.regular, size: 14.0)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
