//
//  SpeechToTextVC.swift
//  Backpacker
//
//  Created by Mobile on 08/08/25.
//

import UIKit

class SpeechToTextVC: UIViewController {
    
    @IBOutlet weak var bt_Save: UIButton!
    @IBOutlet weak var imagVw: UIImageView!
    @IBOutlet weak var main_Vw: UIView!
    
    
    let speechManager = SpeechToTextManager()
    var currentActiveTextField: UITextField?
    var currentActiveTextVw: UITextView?
    var currentlyRecordingButton: UIButton?
    
    var onSaveText: ((String) -> Void)?
    private var recognizedText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSpeechCallbacks()
        startRecording(textField: currentActiveTextField, textView: currentActiveTextVw)
        setUpUI()
        
    }
    func setUpUI(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.imagVw.layer.cornerRadius = 10.0
        self.main_Vw.addShadowAllSides(radius: 2.0)
        self.bt_Save.titleLabel?.font = FontManager.inter(.semiBold, size: 16.0)
        applyGradientButtonStyle(to: self.bt_Save)
    }
    
    @IBAction func ActionSave(_ sender: Any) {
        
        speechManager.stopRecording()
        onSaveText?(recognizedText)
        dismiss(animated: true)
    }
    
    @IBAction func action_Cancle(_ sender: Any) {
        speechManager.stopRecording()
        dismiss(animated: true)
        
    }
    // Add delay before starting new mic
    
    private func startRecording(textField: UITextField?, textView: UITextView?) {
        currentActiveTextField = textField
        currentActiveTextVw = textView
        speechManager.startRecording()
    }
    
    private func setupSpeechCallbacks() {
        speechManager.onResult = { [weak self] text in
            guard let self = self else { return }
            self.recognizedText = text
            print("Recognized Text: \(text)")
        }
        
        speechManager.onError = { error in
            print("Speech error:", error.localizedDescription)
        }
    }
}



