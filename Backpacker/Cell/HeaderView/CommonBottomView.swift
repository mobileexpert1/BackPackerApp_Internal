//
//  CommonBottomView.swift
//  Backpacker
//
//  Created by Mobile on 05/09/25.
//

import UIKit

class CommonBottomView: UIView {

    @IBOutlet weak var lbl_value: UILabel!
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        // Init when using storyboard/xib
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "CommonBottomView", bundle: bundle)
            if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
                view.frame = self.bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.lbl_value.font = FontManager.inter(.medium, size: 14.0)
                addSubview(view)
            }
        }
}
