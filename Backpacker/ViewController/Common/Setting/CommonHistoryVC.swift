//
//  CommonHistoryVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit

class CommonHistoryVC: UIViewController {

    @IBOutlet weak var lbl_ManHeader: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        let nib = UINib(nibName: "CommonEmpListTVC", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "CommonEmpListTVC")
        self.lbl_ManHeader.font = FontManager.inter(.medium, size: 16.0)
    }
    

    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension CommonHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 12
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonEmpListTVC", for: indexPath) as? CommonEmpListTVC else {
               return UITableViewCell()
           }
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           // Perform navigation or action here
       }
    
    
}
