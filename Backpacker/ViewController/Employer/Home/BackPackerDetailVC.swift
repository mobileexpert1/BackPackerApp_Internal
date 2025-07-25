//
//  BackPackerDetailVC.swift
//  BackpackerHire
//
//  Created by Mobile on 25/07/25.
//

import UIKit

class BackPackerDetailVC: UIViewController {
    let sectionTitles = ["Accepted", "Declined"]
    let itemsPerSection = [
        ["Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa","Goa"],
        ["Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh","Leh",
         "Leh"],
        ["Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai","Mumbai"] // 👈 Add a third section here
    ]
    @IBOutlet weak var tblVw: UITableView!
    
    @IBOutlet weak var lbl_Val_JobCount: UILabel!
    @IBOutlet weak var lbl_ValNam: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lbl_AddressVal: UILabel!
    @IBOutlet weak var lbl_TotalJobs: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_mainHeader: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "HomeTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "HomeTVC")
        tblVw.register(UINib(nibName: "HomeHeaderView", bundle: nil),
                            forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        tblVw.showsVerticalScrollIndicator = false
        tblVw.showsHorizontalScrollIndicator = false
        tblVw.contentInset = .zero
        tblVw.sectionHeaderTopPadding = 0 // for iOS 15+
        self.setUpUi()
    }
    private func setUpUi(){
        self.lbl_mainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.lblName.font = FontManager.inter(.regular, size: 13.0)
        self.lbl_TotalJobs.font = FontManager.inter(.regular, size: 13.0)
        self.lbl_Address.font = FontManager.inter(.regular, size: 13.0)
        
        self.lbl_ValNam.font = FontManager.inter(.semiBold, size: 13.0)
        self.lbl_Val_JobCount.font = FontManager.inter(.semiBold, size: 13.0)
        self.lbl_AddressVal.font = FontManager.inter(.semiBold, size: 13.0)
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension BackPackerDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC else {
            return UITableViewCell()
        }
        let sectionItems = itemsPerSection[indexPath.section]
        cell.configure(with: sectionItems,section: indexPath.section)
        cell.isComeFromJob = false
        cell.isComeForHireDetailPage  = true
        cell.onTap = { [weak self] in
            guard let self = self else { return }
            print("Cell tapped at index: \(indexPath.item)")
            // Navigate or perform any action
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView") as? HomeHeaderView else {
            return nil
        }
        
        header.titleLaBLE.text = sectionTitles[section]
        header.section = section
        header.contentView.backgroundColor = .white // prevent background flicker
        header.onButtonTap = { [weak self] tappedSection in
            
            self?.handleHeaderButtonTap(in: tappedSection)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
  
    private func handleHeaderButtonTap(in section: Int) {
        print("Button tapped in section \(section)")
    }
    
}
