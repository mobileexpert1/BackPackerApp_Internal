//
//  EmployerBackPackerListVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class EmployerBackPackerListVC: UIViewController {

    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var tbaleView: UITableView!
    var iscomeFromEmployer : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tbaleView.delegate = self
        tbaleView.dataSource = self
        self.searchVw.layer.borderWidth = 1.0
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        tbaleView.register(UINib(nibName: "CommonEmpListTVC", bundle: nil), forCellReuseIdentifier: "CommonEmpListTVC")
        txtFldSearch.delegate = self

        self.updateSearchtext()

    }
    func updateSearchtext(){
        if iscomeFromEmployer {
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Employer",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
        } else {
            txtFldSearch.attributedPlaceholder = NSAttributedString(
                string: "Search Backpacker",
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: FontManager.inter(.regular, size: 14.0)
                ])
        }
    }
}
extension EmployerBackPackerListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // or your dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonEmpListTVC", for: indexPath) as? CommonEmpListTVC else {
            return UITableViewCell()
        }
        print("iscomeForm",iscomeFromEmployer)
        cell.setupConstraint(iscomeFormEmloyeeee: iscomeFromEmployer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
#if BackpackerHire
        
        let storyboard = UIStoryboard(name: "EmployerHome", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "BackPackerDetailVC") as? BackPackerDetailVC {
             //  jobDescriptionVC.isComeFrom = iscomeFromEmployer
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
#else
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
           if let jobDescriptionVC = storyboard.instantiateViewController(withIdentifier: "EmployerDetailVC") as? EmployerDetailVC {
               jobDescriptionVC.isComeFrom = iscomeFromEmployer
               // Optional: pass selected job title
               self.navigationController?.pushViewController(jobDescriptionVC, animated: true)
           }
#endif
       
    }
    
}


extension EmployerBackPackerListVC :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
