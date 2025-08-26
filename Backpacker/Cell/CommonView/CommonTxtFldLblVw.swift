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
   
    @IBOutlet weak var lblErrHeight: NSLayoutConstraint!
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
        txtFld.delegate = self  // -Set delegate here
            txtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged) // 🔍 Live change detection
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
       
        if lbl_Title.text == "Email"{
            _ = validateEmail() // 🟢 Re-validate on each text change
        }else{
            _ = validateNotEmpty() // 🟢 Re-validate on each text change
        }
    }

    
    private func setUpfontUI(){
#if BackpackerHire
        
        self.txtFld_BgVw.layer.cornerRadius = 10.0
        self.txtFld_BgVw.layer.borderColor = UIColor(hex: "#E5E5E5").cgColor
        self.txtFld_BgVw.layer.borderWidth = 1.0
#else
        self.txtFld_BgVw.addShadowAllSides(radius:2)
        
#endif
       
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
        if err.isEmpty == true{
            self.lbl_Error.text = ""
            self.lblErrHeight.constant = 0.0
        }else{
            self.lbl_Error.text = err
            self.lblErrHeight.constant  = 10.0
        }
       
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
    func validateEmail(errorMessage: String = "Enter a valid email") -> Bool {
        let text = getTextFieldValue().trimmingCharacters(in: .whitespacesAndNewlines)

        if text.isEmpty {
            setError("Email is required")
            lblErrorVisibility(val: false)
            return false
        }

        if !isValidEmail(text) {
            setError(errorMessage)
            lblErrorVisibility(val: false)
            return false
        }

        lblErrorVisibility(val: true)
        return true
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

