//
//  SettingVCViewController.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var Btn_DrpDown: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    let role = UserDefaults.standard.string(forKey: "UserRoleType")
    let dataSource = ["Employer", "Accommodation", "Hangout"]
    private var dropdownHelper: DropdownHelper?
    @IBOutlet weak var lbl_selectedRole: UILabel!
#if BackpackerHire
    var menuItems: [MenuItem] = [
        MenuItem(iconName: "Profile1", title: "Profile"),
        MenuItem(iconName: "user-setting 1", title: "Subscription Plan"),
        MenuItem(iconName: "Terms and Conditions", title: "History"),
        MenuItem(iconName: "Terms and Conditions", title: "Terms & Conditions"),
        MenuItem(iconName: "Heart", title: "Favorite Jobs"),
        MenuItem(iconName: "Error", title: "Report Issue"),
        MenuItem(iconName: "User Shield", title: "Privacy Policy"),
        MenuItem(iconName: "Delete", title: "Delete Account"),
        MenuItem(iconName: "Logout", title: "Log Out")
    ]
    #else
      
    var menuItems: [MenuItem] = [
        MenuItem(iconName: "Profile1", title: "Profile"),
        MenuItem(iconName: "Calendar1", title: "Availability"),
        MenuItem(iconName: "Terms and Conditions", title: "Terms & Conditions"),
        MenuItem(iconName: "Heart", title: "Favorite Jobs"),
        MenuItem(iconName: "Error", title: "Report Issue"),
        MenuItem(iconName: "User Shield", title: "Privacy Policy"),
        MenuItem(iconName: "Delete", title: "Delete Account"),
        MenuItem(iconName: "Logout", title: "Log Out")
    ]
    
#endif
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_selectedRole.font = FontManager.inter(.medium, size: 16.0)
        self.setRole()
        dropdownHelper = DropdownHelper(
                   parentView: self.view,
                   anchorButton: Btn_DrpDown,
                   options: ["Employer", "Accommodation", "Hangout"],
                   optionImages: ["role_EmpTick", "roleAccTick", "role_HangoutTick"]
               )
               dropdownHelper?.onOptionSelected = { [weak self] selected in
                   self?.setRole()
                   print("✅ Selected item:", selected)
                   self?.UpdaqteNavigation()

               }
        let nib = UINib(nibName: "SettingTVC", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "SettingTVC")
        
        if role == "4"{
            menuItems = [
                MenuItem(iconName: "Profile1", title: "Profile"),
                MenuItem(iconName: "Terms and Conditions", title: "Terms & Conditions"),
                MenuItem(iconName: "Heart", title: "Favorite Hangout"),
                MenuItem(iconName: "Error", title: "Report Issue"),
                MenuItem(iconName: "User Shield", title: "Privacy Policy"),
                MenuItem(iconName: "Delete", title: "Delete Account"),
                MenuItem(iconName: "Logout", title: "Log Out")
            ]
        }else if role == "3"{
            menuItems = [
                MenuItem(iconName: "Profile1", title: "Profile"),
                MenuItem(iconName: "Terms and Conditions", title: "Terms & Conditions"),
                MenuItem(iconName: "Heart", title: "Favorite Accomodations"),
                MenuItem(iconName: "Error", title: "Report Issue"),
                MenuItem(iconName: "User Shield", title: "Privacy Policy"),
                MenuItem(iconName: "Delete", title: "Delete Account"),
                MenuItem(iconName: "Logout", title: "Log Out")
            ]
        }
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        // Do any additional setup after loading the view.
        self.lbl_Title.font = FontManager.inter(.semiBold, size: 16.0)
    }
  
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func action_ChangeRole(_ sender: Any) {
        dropdownHelper?.toggleDropdown()
        
    }
    
    func setRole(){
        let role =  UserDefaults.standard.string(forKey: "UserRoleType")
        
        if role == "2"{
            self.lbl_selectedRole.text = "Employer"
        }else if role == "3"{
            self.lbl_selectedRole.text = "Accomodation"
        }else{
            self.lbl_selectedRole.text = "Hangout"
        }
    }
    func UpdaqteNavigation() {
#if BackpackerHire
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        // Example: Navigate to MainTabBarController
        let storyboard = UIStoryboard(name: "MainTabBarEmpStoryboard", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarEmpController")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        // Optional: Add transition animation
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3
        window.layer.add(transition, forKey: kCATransition)
#endif
       
    }

}



extension SettingVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTVC", for: indexPath) as? SettingTVC else {
                  return UITableViewCell()
              }

              let item = menuItems[indexPath.row]
              cell.lblTitle.text = item.title
             cell.imgVw.image = UIImage(named:item.iconName)
              cell.imgVw.tintColor = .black // Customize as needed

              return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
#if BackpackerHire
        
        if role == "4"{
            switch indexPath.row {
            case 0:
                if let vc = storyboard.instantiateViewController(withIdentifier: "AccountDetailVC") as? AccountDetailVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                    vc.isComeFromPrivacy = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 2:
                if let vc = storyboard.instantiateViewController(withIdentifier: "FavourateJobVC") as? FavourateJobVC {
                    vc.isComeFromAcceptDeclineJobs = false
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 3:
                if let vc = storyboard.instantiateViewController(withIdentifier: "ReportIssueVC") as? ReportIssueVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case 4:
                if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                    vc.isComeFromPrivacy = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case 5:
                AlertManager.showConfirmationAlert(on: self,
                                                   title: "Delete Account",
                                                   message: "Are you sure you want to delete the account?",
                                                   confirmAction: {
                    if let popupVC = storyboard.instantiateViewController(withIdentifier: "DeletePopUpVC") as? DeletePopUpVC {
                        popupVC.modalPresentationStyle = .overCurrentContext
                        popupVC.modalTransitionStyle = .crossDissolve
                        self.present(popupVC, animated: true, completion: nil)
                    }
                    
                })
            case 6:
                 
                AlertManager.showConfirmationAlert(on: self,
                                                   title: "Logout",
                                                   message: "Are you sure you want to logout?",
                                                   confirmAction: {
                    
                    UserDefaults.standard.removeObject(forKey: "UserRoleType")
                    UserDefaults.standard.synchronize()
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                    let nav = UINavigationController(rootViewController: loginVC)
                    nav.navigationBar.isHidden = true

                    SceneDelegate.setRootViewController(nav)
                    
                    
                    
                })

                
            default:
                break
            }
        }else if role == "3"{
            switch indexPath.row {
            case 0:
                if let vc = storyboard.instantiateViewController(withIdentifier: "AccountDetailVC") as? AccountDetailVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                    vc.isComeFromPrivacy = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 2:
                if let vc = storyboard.instantiateViewController(withIdentifier: "FavourateJobVC") as? FavourateJobVC {
                    vc.isComeFromAcceptDeclineJobs = false
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 3:
                if let vc = storyboard.instantiateViewController(withIdentifier: "ReportIssueVC") as? ReportIssueVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case 4:
                if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                    vc.isComeFromPrivacy = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case 5:
                AlertManager.showConfirmationAlert(on: self,
                                                   title: "Delete Account",
                                                   message: "Are you sure you want to delete the account?",
                                                   confirmAction: {
                    if let popupVC = storyboard.instantiateViewController(withIdentifier: "DeletePopUpVC") as? DeletePopUpVC {
                        popupVC.modalPresentationStyle = .overCurrentContext
                        popupVC.modalTransitionStyle = .crossDissolve
                        self.present(popupVC, animated: true, completion: nil)
                    }
                    
                })
            case 6:
                 
                AlertManager.showConfirmationAlert(on: self,
                                                   title: "Logout",
                                                   message: "Are you sure you want to logout?",
                                                   confirmAction: {
                    
                    UserDefaults.standard.removeObject(forKey: "UserRoleType")
                    UserDefaults.standard.synchronize()
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                    let nav = UINavigationController(rootViewController: loginVC)
                    nav.navigationBar.isHidden = true

                    SceneDelegate.setRootViewController(nav)
                    
                    
                    
                })

                
            default:
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                if let vc = storyboard.instantiateViewController(withIdentifier: "AccountDetailVC") as? AccountDetailVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                if let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 2:
                if let vc = storyboard.instantiateViewController(withIdentifier: "HistoryContainerVC") as? HistoryContainerVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 3:
                if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                    vc.isComeFromPrivacy = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 4:
                if let vc = storyboard.instantiateViewController(withIdentifier: "FavourateJobVC") as? FavourateJobVC {
                    vc.isComeFromAcceptDeclineJobs = false
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 5:
                if let vc = storyboard.instantiateViewController(withIdentifier: "ReportIssueVC") as? ReportIssueVC {
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case 6:
                if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                    vc.isComeFromPrivacy = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            case 7:
                AlertManager.showConfirmationAlert(on: self,
                                                   title: "Delete Account",
                                                   message: "Are you sure you want to delete the account?",
                                                   confirmAction: {
                    if let popupVC = storyboard.instantiateViewController(withIdentifier: "DeletePopUpVC") as? DeletePopUpVC {
                        popupVC.modalPresentationStyle = .overCurrentContext
                        popupVC.modalTransitionStyle = .crossDissolve
                        self.present(popupVC, animated: true, completion: nil)
                    }
                    
                })
            case 8:
                 
                AlertManager.showConfirmationAlert(on: self,
                                                   title: "Logout",
                                                   message: "Are you sure you want to logout?",
                                                   confirmAction: {
                    
                    UserDefaults.standard.removeObject(forKey: "UserRoleType")
                    UserDefaults.standard.synchronize()
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                    let nav = UINavigationController(rootViewController: loginVC)
                    nav.navigationBar.isHidden = true

                    SceneDelegate.setRootViewController(nav)
                    
                    
                    
                })

                
            default:
                break
            }
        }
       
        
        
        #else
        
        switch indexPath.row {
        case 0:
            if let vc = storyboard.instantiateViewController(withIdentifier: "AccountDetailVC") as? AccountDetailVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
//            if let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC") as? AccountVC {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
        case 1:
            let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
            if let settingVC = storyboard.instantiateViewController(withIdentifier: "SetAvailibilityVC") as? SetAvailibilityVC {
                self.navigationController?.pushViewController(settingVC, animated: true)
            } else {
                print("❌ Could not instantiate SettingVC")
            }
        case 2:
            if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                vc.isComeFromPrivacy = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            if let vc = storyboard.instantiateViewController(withIdentifier: "FavourateJobVC") as? FavourateJobVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 4:
            if let vc = storyboard.instantiateViewController(withIdentifier: "ReportIssueVC") as? ReportIssueVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }

        case 5:
            if let vc = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC {
                vc.isComeFromPrivacy = true
                self.navigationController?.pushViewController(vc, animated: true)
            }

        case 6:
            AlertManager.showConfirmationAlert(on: self,
                                               title: "Delete Account",
                                               message: "Are you sure you want to delete the account?",
                                               confirmAction: {
                if let popupVC = storyboard.instantiateViewController(withIdentifier: "DeletePopUpVC") as? DeletePopUpVC {
                    popupVC.modalPresentationStyle = .overCurrentContext
                    popupVC.modalTransitionStyle = .crossDissolve
                    self.present(popupVC, animated: true, completion: nil)
                }
                
            })
        case 7:
             
            AlertManager.showConfirmationAlert(on: self,
                                               title: "Logout",
                                               message: "Are you sure you want to logout?",
                                               confirmAction: {
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                let nav = UINavigationController(rootViewController: loginVC)
                nav.navigationBar.isHidden = true

                SceneDelegate.setRootViewController(nav)
                
                
                
            })

            
        default:
            break
        }
        
#endif
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}
struct MenuItem {
    let iconName: String
    let title: String
}
