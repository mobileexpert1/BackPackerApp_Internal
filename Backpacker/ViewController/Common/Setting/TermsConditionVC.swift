//
//  TermsConditionVC.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class TermsConditionVC: UIViewController {

    @IBOutlet weak var lbl_nodatFound: UILabel!
    @IBOutlet weak var lbl_Header: UILabel!
    @IBOutlet weak var txt_Vw: UITextView!
    var isComeFromPrivacy = false
    let viewModel = ProfileVM()
    let viewModelAuth = LogInVM()
    var key = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_nodatFound.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_nodatFound.isHidden = true
        self.lbl_nodatFound.text = "No Data Found"
        if isComeFromPrivacy{
            self.lbl_Header.text = "Privacy Policy"
            self.key = "privacyPolicy"
        }else{
            self.lbl_Header.text = "Terms & Conditions"
            self.key = "termsAndConditions"
        }
        self.lbl_Header.font = FontManager.inter(.medium, size: 16.0)
        self.txt_Vw.font = FontManager.inter(.regular, size: 14.0)
        self.getContentApiCall(key: key)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension TermsConditionVC {
    
    func getContentApiCall(key:String){
        LoaderManager.shared.show()
        
        viewModel.getContent(key: key) { [weak self] (success: Bool, result: ContentResponse?, statusCode: Int?) in
            guard let self = self else { return }
            
            guard let statusCode = statusCode else {
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                return
            }
            
            let httpStatus = HTTPStatusCode(rawValue: statusCode)
            
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                
                switch httpStatus {
                case .ok, .created:
                    if success, let profileData = result?.data {
                        print("User Profile data fetched result:", profileData)
                        self.txt_Vw.text = result?.data?.aboutUs?.content
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                    }
                    if result?.data?.aboutUs?.content == nil{
                        self.lbl_nodatFound.isHidden = false
                    }else{
                        self.lbl_nodatFound.isHidden = true
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewModelAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.getContentApiCall(key: key) // Retry on token refresh success
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Session expired. Please log in again.")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                }
            }
        }
    }
}
