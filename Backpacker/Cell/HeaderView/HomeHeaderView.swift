//
//  HomeHeaderView.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class HomeHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerButton: UIButton!
    
    @IBOutlet weak var titleLaBLE: UILabel!
    var section = Int()
    var onButtonTap: ((Int) -> Void)?
    override func awakeFromNib() {
            super.awakeFromNib()
            titleLaBLE.font = FontManager.inter(.semiBold, size: 16.0)
        self.headerButton.titleLabel?.font = FontManager.inter(.medium, size: 12.0)
            // Optional: Add target here if not using delegate or closure
            headerButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }

        @objc func buttonTapped() {
            onButtonTap?(section)
        }

}
