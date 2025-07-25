//
//  CommonTxtFldLblVw.swift
//  Backpacker
//
//  Created by Sahil Sharma on 12/07/25.
//

import Foundation
//
//  CommonRatingDistanceView.swift
//  Backpacker
//
//  Created by Mobile on 10/07/25.
//

import Foundation
import  UIKit
class CommonTxtFldLblVw: UIView , UITextFieldDelegate{

    @IBOutlet weak var txtFld: UITextField!
    @IBOutlet weak var txtFld_BgVw: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var lbl_Error: UILabel!
   
    var nibName = "CommonTxtFldLblVw"
    var contentView: UIView?
    var filterItemSelected: ((String) -> Void)?
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
        setUpfontUI()
        txtFld.delegate = self  // ✅ Set delegate here
            txtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged) // 🔍 Live change detection
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
        _ = validateNotEmpty() // 🟢 Re-validate on each text change
    }

    
    private func setUpfontUI(){
        self.txtFld_BgVw.addShadowAllSides(radius:2)
        lbl_Title.font = FontManager.inter(.medium, size: 14.0)
        self.txtFld.font = FontManager.inter(.regular, size: 12.0)
        lbl_Error.font = FontManager.inter(.regular, size: 8.0)
            lbl_Error.textColor = .red
    }
    func setPlaceholder(_ placeholder: String) {
        txtFld.placeholder = placeholder
    }
    
    func lblErrorVisibility(val:Bool = true){
        self.lbl_Error.isHidden = val
    }
    func setError(_ err: String) {
        self.lbl_Error.text = err
    }
    func getTextFieldValue() -> String {
        return txtFld.text ?? ""
    }
    func setTitleLabel(_ text: String) {
        lbl_Title.text = text
    }

    func validateNotEmpty(errorMessage: String = "This field is required") -> Bool {
        let text = getTextFieldValue().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text.isEmpty {
            setError(errorMessage)
            lblErrorVisibility(val: false)
            return false
        }
        
        lblErrorVisibility(val: true) // hide error if valid
        return true
    }

    
}

