//
//  CommonSearchVC.swift
//  Backpacker
//
//  Created by Mobile on 01/08/25.
//

import UIKit
protocol CommonSearchDelegate: AnyObject {
    func didSelectBackpacker(_ backpacker: [Backpacker])
}

class CommonSearchVC: UIViewController {

    @IBOutlet weak var Btn_Save: UIButton!
    @IBOutlet weak var txtFld_Search: UITextField!
    @IBOutlet weak var searchVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var lbl_No_backpacker: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    var searchData: [Backpacker] = []
    var fullData: [Backpacker] = []
    var  selectedData : [Backpacker] = []
    let viewModel = JobVM()
    private let refreshControl = UIRefreshControl()
    weak var delegate: CommonSearchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setUpUI()
        self.setUpRefreshControl()
        self.backpackerListApiCall()
        // Do any additional setup after loading the view.
    }
    
    func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tblVw.refreshControl = refreshControl
    }
    @objc func handleRefresh() {
        backpackerListApiCall()
    }

    func setUpUI(){
        applyGradientButtonStyle(to: self.Btn_Save)
        self.Btn_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        self.lbl_No_backpacker.font = FontManager.inter(.medium, size: 14.0)
        self.lbl_No_backpacker.isHidden = true
        let nib = UINib(nibName: "FacilityTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "FacilityTVC")
        self.lbl_MainHeader.font = FontManager.inter(.semiBold, size: 16)
        self.searchVw.layer.cornerRadius = 22.5
        self.searchVw.layer.borderWidth = 1.0
        self.searchVw.layer.borderColor = UIColor.black.cgColor
        self.txtFld_Search.delegate = self
               
    }

    func backpackerListApiCall() {
        LoaderManager.shared.show()
        viewModel.getBackpackersList(page: 1, perPage: 10) { [weak self] (success: Bool, result: BackpackerListResponse?, statusCode: Int?) in
            LoaderManager.shared.hide()
            self?.refreshControl.endRefreshing()
            if success, let list = result?.data?.backpackersList {
                self?.tblVw.delegate = self
                self?.tblVw.dataSource = self
                if list.count == 0 {
                    self?.tblVw.isHidden = true
                    self?.lbl_No_backpacker.isHidden = false
                }else{
                    self?.tblVw.isHidden = false
                    self?.lbl_No_backpacker.isHidden = true
                    self?.fullData = list
                        self?.searchData = list
                    self?.tblVw.reloadData()
                }

            } else {
                print("Failed to fetch backpackers. Message: \(result?.message ?? "Unknown Error")")
            }
        }
    }

    @IBAction func action_Save(_ sender: Any) {
           delegate?.didSelectBackpacker(self.selectedData)
           self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension CommonSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityTVC", for: indexPath) as? FacilityTVC else {
            return UITableViewCell()
        }

        let data = searchData[indexPath.row]
           cell.lblTitle.text = data.mobileNumber
        cell.lblTitle.textColor = .black
           // ✅ Check if the item is selected
           let isSelected = selectedData.contains { $0.mobileNumber == data.mobileNumber }
           cell.imgCheckBox.image = isSelected ? UIImage(named: "Checkbox2") : UIImage(named: "Checkbox")

           return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchData[indexPath.row]

            if let index = selectedData.firstIndex(where: { $0.mobileNumber == selectedItem.mobileNumber }) {
                // Already selected → remove
                selectedData.remove(at: index)
            } else {
                // Not selected → add
                selectedData.append(selectedItem)
            }

            // Reload just the tapped row
            tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension CommonSearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        
        filterSearchResults(with: updatedText)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

   
        private func filterSearchResults(with text: String) {
            if text.isEmpty {
                self.searchData = self.fullData
            } else {
                self.searchData = self.fullData.filter {
                    $0.mobileNumber.lowercased().contains(text.lowercased())
                }
            }
            self.tblVw.reloadData()
            if searchData.count == 0 {
                self.tblVw.isHidden = true
                self.lbl_No_backpacker.isHidden = false
            }else{
                self.tblVw.isHidden = false
                self.lbl_No_backpacker.isHidden = true
            }
        }

    
}
