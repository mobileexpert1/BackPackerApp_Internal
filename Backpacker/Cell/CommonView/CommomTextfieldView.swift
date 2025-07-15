//
//  CommomTextfieldView.swift
//  Backpacker
//
//  Created by Mobile on 09/07/25.
//

import Foundation
import UIKit

class CommonTextfieldView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var containerView: UIView! // for styling border or shadow

    @IBOutlet weak var txtFldVw: UIView!
    var nibName = "CommonTextfieldView"
    var contentView: UIView?
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

        // Optional: Initial state
        errorLabel.isHidden = true
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.titleLabel.font = FontManager.inter(.medium, size: 12.0)
        self.errorLabel.font = FontManager.inter(.regular, size: 10.0)
        self.textField.font = FontManager.inter(.regular, size: 14.0)
        self.txtFldVw.layer.cornerRadius = 5.0
    }
   
    
    // MARK: - Public Methods
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        containerView.layer.borderColor = UIColor.red.cgColor
    }

    func hideError() {
        errorLabel.text = ""
        errorLabel.isHidden = true
    }

    func getText() -> String {
        return textField.text ?? ""
    }

    func setText(_ text: String) {
        textField.text = text
    }
}

