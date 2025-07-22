//
//  BackPackerListVC.swift
//  Backpacker
//
//  Created by Mobile on 08/07/25.
//

import UIKit

class BackPackerListVC: UIViewController {

    @IBOutlet weak var table_Vw: UITableView!
    var filterebackpackers: [BackPackers] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "BackPackerListTVC", bundle: nil)
        table_Vw.register(nib, forCellReuseIdentifier: "BackPackerListTVC")
        self.table_Vw.delegate = self
        self.table_Vw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func updateDesignations(_ newList: [BackPackers]) {
        self.filterebackpackers = newList
        self.table_Vw.reloadData()
    }
}
extension BackPackerListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return filterebackpackers.count
      }

      func tableView(_ tableView: UITableView,
                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "BackPackerListTVC", for: indexPath) as? BackPackerListTVC else {
              return UITableViewCell()
          }
          let backpacker = filterebackpackers[indexPath.row]
          cell.lbl_Name.text = backpacker.name // Replace with your actual IBOutlet
          cell.lbl_CompletedJob.text = "Completed Jobs - \(backpacker.completedJobs)"
          return cell
      }

      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension // or UITableView.automaticDimension for dynamic height
      }
}
struct BackPackers {
    let name: String
    let country: String
    let completedJobs: Int
}
struct JobsDesignation {
    let Name: String
    let star: String
    let distance : String
}
