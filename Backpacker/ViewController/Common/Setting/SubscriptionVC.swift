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
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var main_scrollVw: UIScrollView!
    @IBOutlet weak var lbl_ChoosePlan: UILabel!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    
    @IBOutlet weak var btnProceed: UIButton!
    
    @IBOutlet weak var tblHeght: NSLayoutConstraint!
    @IBOutlet weak var btn_Cancle: UIButton!
    let viewModel = SubscriptionViewModel()
    let viewAuth = LogInVM()
    var isLoading : Bool = true
    let refreshControl = UIRefreshControl()
    var plans : [Plan]?
    var currentPlan : Plan?
    var selectedIndex: IndexPath? {
            didSet {
                tblVw.reloadData() // Reload table to update images
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getListOfAllSubscriptions()
        tblVw.isScrollEnabled = false

        let nib = UINib(nibName: "SubscriptionTVC", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "SubscriptionTVC")
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.reloadData()
        manageHeight()

        applyGradientButtonStyle(to: self.btnProceed)
        
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
   //     self.navigationController?.popViewController(animated: true)
//        Task {
//                    await purchasePlan(tier: .basic)
//                }
    }
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_Cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            cell.lbl_price.text = "\(plan.price ?? 0.0) per month"
            cell.lbl_description.text = plan.desc  ?? ""
            cell.indexPath = indexPath
            cell.lbl_feature1.text = plan.feature?[0] ?? ""
            cell.lbl_feature2.text = plan.feature?[1] ?? ""
            cell.lbl_feature3.text = plan.feature?[2] ?? ""
          //  cell.lbl_feature4.text = plan.feature?[3]
            cell.onCellTapped = { [weak self] tappedIndex in
                        print("Cell tapped: \(tappedIndex.row)")
                        self?.selectedIndex = tappedIndex
                    }
                    
                    // Update cell image based on selectedIndex
                    let isSelected = (indexPath == selectedIndex)
                    cell.updateImage(isSelected: isSelected)
        }
     
        return cell
    }
    
   
    
    func manageHeight() {
        tblVw.layoutIfNeeded()
        tblHeght.constant =  CGFloat(((self.plans?.count ?? 0) * 205))
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
                                    self.plans = result?.data?.plans ?? []
                                    if let plan =  result?.data?.currentPlan{
                                        self.currentPlan = plan
                                       
                                            
                                    }
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
   
}


extension SubscriptionVC {
    func purchasePlan(tier: SubscriptionTier) async {
            guard let plan = SubscriptionManager.shared.getPlan(for: tier),
                  let productID = plan.productID else {
                print("Invalid plan or product ID")
                return
            }

            do {
                let products = try await Product.products(for: ["com.shiftly.app.subscription.basic"])
                guard let product = products.first else {
                    print("Product not found on App Store")
                    return
                }

                let result = try await product.purchase()

                switch result {
                case .success(let verification):
                    let transaction = try checkVerified(verification)
                    await transaction.finish()
                    print("Purchase successful for \(tier.rawValue)")
                    // Unlock features or update UI
                case .userCancelled:
                    print("User cancelled the purchase")
                case .pending:
                    print("Purchase pending")
                @unknown default:
                    print("Unknown purchase result")
                }
            } catch {
                print("Purchase failed: \(error)")
            }
        }

        // MARK: - Verification Helper
        func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
            switch result {
            case .unverified(_, let error):
                throw error ?? StoreKitError.unknown
            case .verified(let signed):
                return signed
            }
        }
}
