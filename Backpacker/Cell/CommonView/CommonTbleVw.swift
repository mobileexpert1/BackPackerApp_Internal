//
//  CommonTbleVw.swift
//  Backpacker
//
//  Created by Mobile on 10/07/25.
//

import Foundation
import UIKit

class CommonTbleVw: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tblVw: UITableView!
    var nibName = "CommonTbleVw"
    var contentView: UIView?
    var isComeFromRating : Bool = false
    var dataArray: [String] = [] // Replace with your actual model
    var tableHeight = CGFloat()
    var onItemSelected: ((String) -> Void)?
    // MARK: - IBOutlets connection
    @IBAction override func awakeFromNib() {
        super.awakeFromNib()
        contentView = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        contentView = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let contentView = contentView {
            addSubview(contentView)
        }
        // Register cell (adjust cell nib name and identifier accordingly)
        let nib = UINib(nibName: "CommonRatingCell", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "CommonRatingCell")
        tblVw.delegate = self
        tblVw.dataSource = self
        self.tblVw.reloadData()
        
       
    }
    
    // MARK: - Public Method to set data
    func setData(_ data: [String]) {
        self.dataArray = data
        tblVw.reloadData()
        tblVw.layoutIfNeeded() // Ensure layout updates
        self.tableHeight = 160//tblVw.contentSize.height
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblVw.dequeueReusableCell(withIdentifier: "CommonRatingCell", for: indexPath) as! CommonRatingCell
        cell.lbl_Title.text = dataArray[indexPath.row]
        cell.setUpData(title: dataArray[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("✅ Selected row at index: \(indexPath.row), Value: \(dataArray[indexPath.row])")
        let selectedValue = dataArray[indexPath.row]
        print("✅ Selected row at index: \(indexPath.row), Value: \(selectedValue)")
        onItemSelected?(selectedValue)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
