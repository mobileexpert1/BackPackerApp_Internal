//
//  CommonImagCVC.swift
//  Backpacker
//
//  Created by Mobile on 04/08/25.
//

import UIKit
protocol CommonImagCVCDelegate: AnyObject {
    func didTapRemove(at indexPath: IndexPath)
}

class CommonImagCVC: UICollectionViewCell {

    @IBOutlet weak var btn_Cross: UIButton!
    @IBOutlet weak var img_Vw: UIImageView!
    weak var delegate: CommonImagCVCDelegate?
       var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func crossTapped(_ sender: UIButton) {
            guard let indexPath = indexPath else { return }
            delegate?.didTapRemove(at: indexPath)
        }
}
