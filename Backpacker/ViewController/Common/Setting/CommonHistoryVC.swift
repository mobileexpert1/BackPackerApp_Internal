//
//  CommonHistoryVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit

class CommonHistoryVC: UIViewController {

//    @IBOutlet weak var lbl_ManHeader: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    var selectedIndex : Int = 0
    var sectionTitles = ["Accepted", "Rejected"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.showsVerticalScrollIndicator = false
        tblVw.showsHorizontalScrollIndicator = false
        tblVw.contentInset = .zero
        tblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        let nib = UINib(nibName: "CommonEmpListTVC", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "CommonEmpListTVC")
        
        let nib2 = UINib(nibName: "CommonHistoryTVC", bundle: nil)
        tblVw.register(nib2, forCellReuseIdentifier: "CommonHistoryTVC")
        tblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
    }
    

    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension CommonHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedIndex == 1{
            return sectionTitles.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return 12
        }else{
            return 1
        }
          
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if selectedIndex == 0{
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonEmpListTVC", for: indexPath) as? CommonEmpListTVC else {
                   return UITableViewCell()
               }
               return cell
           }else{
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonHistoryTVC", for: indexPath) as? CommonHistoryTVC else {
                   return UITableViewCell()
               }
               return cell
           }
          
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           // Perform navigation or action here
       }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.titleLaBLE.text = sectionTitles[section]
        header.section = section
        header.headerButton.isHidden = true
        header.contentView.backgroundColor = .white // prevent background flicker
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedIndex == 0 {
            return 0.0
        }
        return 40
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == 1  {
            return 205
        }else{
            return UITableView.automaticDimension
        }
      
    }
}
