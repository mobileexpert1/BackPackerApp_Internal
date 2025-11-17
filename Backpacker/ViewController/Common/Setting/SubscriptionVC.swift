//
//  SubscriptionVC.swift
//  Backpacker
//
//  Created by Mobile on 24/07/25.
//

import UIKit
import StoreKit
class SubscriptionVC: UIViewController {
    @IBOutlet weak var lbl_MainHeader: UILabel!
    
    @IBOutlet weak var lblTermaprivacy: UILabel!
    @IBOutlet weak var lbl_patymentDescription: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var main_scrollVw: UIScrollView!
    @IBOutlet weak var lbl_ChoosePlan: UILabel!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    
    @IBOutlet weak var btnProceed: UIButton!
    
    @IBOutlet weak var btn_restorePurchase: UIButton!
    @IBOutlet weak var tblHeght: NSLayoutConstraint!
    @IBOutlet weak var btn_Cancle: UIButton!
    let viewModel = SubscriptionViewModel()
    let viewAuth = LogInVM()
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    var plans : [Plan]?
    var currentPlan : Plan?
    var selectedPlanId : String?
    var selectedIndex: IndexPath? {
            didSet {
                tblVw.reloadData() // Reload table to update images
            }
        }
    let arrayOfPrducts = ["com.shiftly.app.subscription.basic","com.shiftly.app.subscription.growth","com.shiftly.app.subscription.pro","com.shiftly.app.subscription.headOffice"]
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         self.lbl_patymentDescription.text = "If you choose to subscribe, payment will be charged to your iTunes account, and your subscription will automatically renew 24 hours before the end of the current period. You can turn off auto-renewal at any time in your iTunes account settings. If you don’t subscribe, you can continue using the app for free."
         */
     
        self.lbl_patymentDescription.text = "Payment will be charged to your iTunes account. Your subscription will automatically renew 24 hours before the end of the current period. The price may vary depending on your country or region. You can turn off auto-renewal in your iTunes account settings. You can continue using the app for free without subscribing."

        self.getListOfAllSubscriptions()
        tblVw.isScrollEnabled = false

        let nib = UINib(nibName: "SubscriptionTVC", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "SubscriptionTVC")
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.reloadData()
        manageHeight()

        applyGradientButtonStyle(to: self.btnProceed)
        self.btn_restorePurchase.titleLabel?.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_patymentDescription.font = FontManager.inter(.medium, size: 12.0)
        self.lblTermaprivacy.font = FontManager.inter(.medium, size: 12.0)
        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        self.lbl_ChoosePlan.font = FontManager.inter(.semiBold, size: 20.0)
        self.lbl_SubTitle.font = FontManager.inter(.regular, size: 14.0)
        self.btnProceed.titleLabel?.font  = FontManager.inter(.medium, size: 16.0)
        self.btn_Cancle.titleLabel?.font  = FontManager.inter(.medium, size: 16.0)
        if #available(iOS 10.0, *) {
                    main_scrollVw.refreshControl = refreshControl
                } else {
                    main_scrollVw.addSubview(refreshControl)
                }
                
                refreshControl.addTarget(self, action: #selector(refreshScrollView), for: .valueChanged)
        self.handleAppearanceFrBottomBtns()
        // Text with highlighted parts
                let text = "For more information, please visit our Terms of Use and Privacy Policy."
                let attributedString = NSMutableAttributedString(string: text)
                
                // Highlight "Terms of Use"
                let termsRange = (text as NSString).range(of: "Terms of Use")
                attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: termsRange)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
                
                // Highlight "Privacy Policy"
                let privacyRange = (text as NSString).range(of: "Privacy Policy")
                attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: privacyRange)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
                
        lblTermaprivacy.attributedText = attributedString
        lblTermaprivacy.isUserInteractionEnabled = true
                
                // Tap gesture
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        lblTermaprivacy.addGestureRecognizer(tapGesture)
                
                // Constraints
//
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SubscriptionManager.shared.controller = self
    }
    
    @IBAction func action_btnRestore(_ sender: Any) {
       
        LoaderManager.shared.show()

            Task {
                let restored = await SubscriptionManager.shared.restorePurchases()
                
                // Hide loader
                LoaderManager.shared.hide()
                
                if restored {
                    AlertManager.showAlert(on: self, title: "Success", message: "Your purchases have been restored.")
                } else {
                    AlertManager.showAlert(on: self, title: "Info", message: "No purchases to restore.")
                }
            }
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
            guard let label = gesture.view as? UILabel else { return }
            let text = label.text! as NSString
            let termsRange = text.range(of: "Terms of Use")
            let privacyRange = text.range(of: "Privacy Policy")
            
            let tapLocation = gesture.location(in: label)
            let index = indexOfCharacter(at: tapLocation, in: label)
            
            if NSLocationInRange(index, termsRange) {
                openURL("https://backpacker.csdevhub.com/terms-condition/employer")
            } else if NSLocationInRange(index, privacyRange) {
                openURL("https://backpacker.csdevhub.com/privacy-policy/employer")
            }
        }
        
        func openURL(_ urlString: String) {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
        
        func indexOfCharacter(at point: CGPoint, in label: UILabel) -> Int {
            guard let attributedText = label.attributedText else { return NSNotFound }
            
            let textStorage = NSTextStorage(attributedString: attributedText)
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            
            let textContainer = NSTextContainer(size: label.bounds.size)
            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.lineBreakMode = label.lineBreakMode
            layoutManager.addTextContainer(textContainer)
            
            let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            return index
        }
    @objc func refreshScrollView() {
           print("ScrollView pulled to refresh")

           // Call your data reload function here
        self.getListOfAllSubscriptions()

           // End refreshing after reload
       }

       func reloadData() {
           // Your logic to reload table or other content inside scroll view
           tblVw.reloadData()
           manageHeight() // If you’re updating table height
       }
    
    @IBAction func action_Proceed(_ sender: Any) {
        // Show loader when purchase starts
        LoaderManager.shared.show()

        Task {
            do {
                await SubscriptionManager.shared.purchasePlan(tier: SubscriptionManager.shared.selectedPlan ?? .basic)
                // Hide loader after success
                LoaderManager.shared.hide()
            } catch {
                // Hide loader on failure too
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Purchase failed", message: "\(error.localizedDescription)")
                print("Purchase failed: \(error.localizedDescription)")
            }
        }

    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func handleAppearanceFrBottomBtns(){
        if  SubscriptionManager.shared.selectedPlan == .free{
            self.btnProceed.isUserInteractionEnabled = false
            self.btnProceed.layer.opacity = 0.4
        }else{
            self.btnProceed.isUserInteractionEnabled = true
            self.btnProceed.layer.opacity = 1.0
        }
    }
    
}

extension SubscriptionVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plans?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblVw.dequeueReusableCell(withIdentifier: "SubscriptionTVC", for: indexPath) as! SubscriptionTVC
        
        if let plan = plans?[indexPath.row] {
            cell.lbl_header.text = plan.name ?? ""
            cell.lbl_price.text = "$\(plan.price ?? 0.0)/month"
            cell.lbl_description.text = plan.desc  ?? ""
            cell.indexPath = indexPath
            cell.lbl_feature1.text = plan.feature?[0] ?? ""
            cell.lbl_feature2.text = plan.feature?[1] ?? ""
            cell.lbl_feature3.text = plan.feature?[2] ?? ""
          //  cell.lbl_feature4.text = plan.feature?[3]
//                    }
            cell.onCellTapped = { [weak self] tappedIndex in
                        guard let self = self,
                              let tappedPlan = self.plans?[tappedIndex.row],
                              let planName = tappedPlan.name,
                              let selectedTier = SubscriptionTier.allCases.first(where: { $0.rawValue == planName }) else {
                            print("No matching tier found for tapped plan")
                            SubscriptionManager.shared.selectedPlan = .free
                                    // Update selected index for UI highlighting
                            self?.selectedIndex = tappedIndex
                            self?.selectedPlanId = self?.plans?[self?.selectedIndex?.row ?? 0].id ?? ""
                            self?.tblVw.reloadData()
                            
                            self?.handleAppearanceFrBottomBtns()
                            return
                        }

                        print("Cell tapped: \(tappedIndex.row)")
                        print("Selected Tier: \(selectedTier.rawValue)")
                SubscriptionManager.shared.selectedPlan = selectedTier
                        // Update selected index for UI highlighting
                        self.selectedIndex = tappedIndex
                self.selectedPlanId = self.plans?[self.selectedIndex?.row ?? 0].id ?? ""
                        self.tblVw.reloadData()

                    }
            
            self.handleAppearanceFrBottomBtns()
                    // Update cell image based on selectedIndex
                    let isSelected = (indexPath == selectedIndex)
                    cell.updateImage(isSelected: isSelected)
            
        }
     
        return cell
    }
    
   
    
    func manageHeight() {
        tblVw.layoutIfNeeded()
        if UIDevice.current.userInterfaceIdiom == .pad {
            let count = (self.plans?.count ?? 0 + 1 )
            tblHeght.constant =  CGFloat(((count) * 260))
        }else{
            let count = (self.plans?.count ?? 0 + 1 )
            tblHeght.constant =  CGFloat(((count) * 230))
        }
        
        tblVw.layoutIfNeeded()
    }

}
extension SubscriptionVC {
    
    private func getListOfAllSubscriptions()
    {
        LoaderManager.shared.show()
        viewModel.getlistOfSubscriptions { [weak self] (success: Bool, result: GetSubscriptionModel?, statusCode: Int?) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    LoaderManager.shared.hide()
                    guard let statusCode = statusCode else {
                        LoaderManager.shared.hide()
                        AlertManager.showAlert(on: self, title: "Error", message: "No response from server.")
                        return
                    }
                    let httpStatus = HTTPStatusCode(rawValue: statusCode)
                    
                    DispatchQueue.main.async {
                        
                        switch httpStatus {
                        case .ok, .created:
                            if success == true {
                                if result?.data != nil{
                                    self.isLoading = false
                                    self.plans?.removeAll()
                                    self.plans = result?.data ?? []
//                                    if let plan =  result?.data?.currentPlan{
//                                        self.currentPlan = plan
//                                    }
                                }else{
                                    AlertManager.showAlert(on: self, title: "Success", message: result?.message ?? "Something went wrong.")
                                }
                            } else {
                                AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                                LoaderManager.shared.hide()
                            }
                            self.refreshControl.endRefreshing()
                            self.tblVw.reloadData()
                            self.manageHeight()
                        case .badRequest:
                            AlertManager.showAlert(on: self, title: "Error", message: result?.message ?? "Something went wrong.")
                            self.refreshControl.endRefreshing()
                        case .unauthorized :
                            self.viewAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                                if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                                    self.getListOfAllSubscriptions()
                                } else {
                                    LoaderManager.shared.hide()
                                    self.isLoading = false
                                    self.refreshControl.endRefreshing()
                                    NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message ?? "Internal Server Error")
                                }
                            }
                            
                        case .unauthorizedToken:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            NavigationHelper.showLoginRedirectAlert(on: self, message: result?.message  ?? "Internal Server Error")
                        case .unknown:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Server Error", message: result?.message ?? "Something went wrong. Try again later."){
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .methodNotAllowed:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                        case .internalServerError:
                            LoaderManager.shared.hide()
                            self.refreshControl.endRefreshing()
                            AlertManager.showAlert(on: self, title: "Error", message:  result?.message ?? "Something went wrong.")
                            
                        }
                    }
                }
            }
    }
    
     func createNewUserPlan(){
        LoaderManager.shared.show()
         guard let purchase = SubscriptionManager.shared.purchasePlanDetail else {
                LoaderManager.shared.hide()
                AlertManager.showAlert(on: self, title: "Error", message: "No purchase found.")
                return
            }
        viewModel.createUserPlanAfterPurchase(purchaseInfo: purchase) { success, message ,statusCode in
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
                    if success == true {
                        AlertManager.showAlert(on: self, title: "Success", message: message ?? "Purchased Succesfully"){
                            
                        }
                        
                    } else {
                        AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                    }
                case .badRequest:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .unauthorized :
                    self.viewAuth.refreshToken { refreshSuccess, _, refreshStatusCode in
                        if refreshSuccess, [200, 201].contains(refreshStatusCode) {
                            self.createNewUserPlan()
                        } else {
                            NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                        }
                    }
                case .unauthorizedToken:
                    LoaderManager.shared.hide()
                    NavigationHelper.showLoginRedirectAlert(on: self, message: message ?? "Internal Server Error")
                case .unknown:
                    LoaderManager.shared.hide()
                    AlertManager.showAlert(on: self, title: "Server Error", message: message ?? "Something went wrong. Try again later.")
                case .methodNotAllowed:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                case .internalServerError:
                    AlertManager.showAlert(on: self, title: "Error", message: message ?? "Something went wrong.")
                }
            }
               }
    }
   
}
