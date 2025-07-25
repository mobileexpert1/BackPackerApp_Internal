//
//  FilterVC.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.ViewHeight.constant = UIScreen.main.bounds.height / 2
        mainView.layer.cornerRadius = 20
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainView.clipsToBounds = true
//        // 👇 Set custom thumb image
//            if let thumbImage = UIImage(named: "sliderThumb") {
//                slider.setThumbImage(thumbImage, for: .normal)
//            }
//        slider.minimumValue = 0.0
//        slider.minimumTrackTintColor = UIColor(hex:"#299EF5")     // color from start to thumb
//            slider.maximumTrackTintColor = UIColor(hex:"#E8EDF0")
    }
    
    @IBAction func acion_Cross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
 

}
