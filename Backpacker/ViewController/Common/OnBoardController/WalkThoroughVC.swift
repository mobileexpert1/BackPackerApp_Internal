//
//  WalkThoroughVC.swift
//  Backpacker
//
//  Created by Mobile on 03/07/25.
//

import UIKit

class WalkThoroughVC: UIViewController {
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionVw: UICollectionView!
    
    @IBOutlet weak var btn_Next: UIButton!
    
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var btn_Skip: UIButton!
    
#if BackpackerHire
    private let walkthroughItems: [WalkthroughItem] = [
   
        WalkthroughItem(title: Constants.Walkthrough.screen1Title, subTitle: Constants.Walkthrough.screen1SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen1Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen2Title, subTitle: Constants.Walkthrough.screen2SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen2Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen3Title, subTitle: Constants.Walkthrough.screen3SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen3Image)!),
        
        WalkthroughItem(title: Constants.Walkthrough.screen4Title, subTitle: Constants.Walkthrough.screen4SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen4Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen5Title, subTitle: Constants.Walkthrough.screen5SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen5Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen6Title, subTitle: Constants.Walkthrough.screen6SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen6Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen7Title, subTitle: Constants.Walkthrough.screen7SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen7Image)!)
    ]
    
#else
    
    private let walkthroughItems: [WalkthroughItem] = [
        WalkthroughItem(title: Constants.Walkthrough.screen2Title, subTitle: Constants.Walkthrough.screen2SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen2Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen1Title, subTitle: Constants.Walkthrough.screen1SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen1Image)!),
        
        WalkthroughItem(title: Constants.Walkthrough.screen3Title, subTitle: Constants.Walkthrough.screen3SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen3Image)!),
        
        WalkthroughItem(title: Constants.Walkthrough.screen4Title, subTitle: Constants.Walkthrough.screen4SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen4Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen5Title, subTitle: Constants.Walkthrough.screen5SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen5Image)!),
        WalkthroughItem(title: Constants.Walkthrough.screen6Title, subTitle: Constants.Walkthrough.screen6SubTitle,
                        image: UIImage(named: Constants.Walkthrough.screen6Image)!)
    ]
#endif
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for family in UIFont.familyNames.sorted() {
            print("▶︎ Font family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("    → \(name)")
            }
        }
        collectionVw.delegate = self
        collectionVw.dataSource = self
        collectionVw.isPagingEnabled = true
        collectionVw.showsHorizontalScrollIndicator = false
        
        // Setup Page Control
#if BackpackerHire
        pageController.numberOfPages = walkthroughItems.count
        #else
        
        pageController.numberOfPages = walkthroughItems.count
#endif
       
        pageController.currentPage = 0
        pageController.pageIndicatorTintColor = UIColor(named: "subTitleColor")
        pageController.currentPageIndicatorTintColor = UIColor(named: "themeColor")
        
        // Force horizontal scroll
        if let layout = collectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        self.setUpButtons()
        self.checkVisibiltyForNextBytton()
        updateButtonVisibility()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Dynamically update item size to match screen
        if let layout = collectionVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionVw.frame.size
        }
    }
    private func setUpButtons(){
        btn_Next.titleLabel?.font = FontManager.inter(.medium, size: 15.0)
        btn_Skip.titleLabel?.font = FontManager.inter(.regular, size: 15.0)
        
        // Corner Radius
        btn_Next.layer.cornerRadius = 10.0
        btn_Skip.layer.cornerRadius = 10.0
        
    }
    
    
    @IBAction func action_Back(_ sender: Any) {
        let prevIndex = pageController.currentPage - 1
          
          if prevIndex >= 0 {
              pageController.currentPage = prevIndex
              let indexPath = IndexPath(item: prevIndex, section: 0)
              collectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
          }

          updateButtonVisibility()
    }
    func updateButtonVisibility() {
        btn_Back.isHidden = pageController.currentPage == 0
        if pageController.currentPage == walkthroughItems.count - 1 {
            self.btn_Next.setTitle("Finish", for: .normal)
        }else{
            self.btn_Next.setTitle("Next", for: .normal)
            
        }
    }
    @IBAction func action_Next(_ sender: Any) {
        let nextIndex = pageController.currentPage + 1
        
        if nextIndex < walkthroughItems.count {
            pageController.currentPage = nextIndex
            let indexPath = IndexPath(item: nextIndex, section: 0)
            collectionVw.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            updateButtonVisibility()
        } else {
            UserDefaults.standard.set(true, forKey: "hasSeenWalkthrough")
            self.navigateToLogin()
        }
    }
    
    
    @IBAction func action_Submit(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasSeenWalkthrough")
        self.navigateToLogin()
    }
    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "LoginNavVC")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let window = delegate.window {
            window.rootViewController = navVC
            window.makeKeyAndVisible()
        }
    }
    
    private func checkVisibiltyForNextBytton(){
        if pageController.currentPage == 0{
            self.btn_Skip.isHidden = false
            self.btn_Skip.isUserInteractionEnabled = false
        }else{
            self.btn_Skip.isHidden = false
            self.btn_Skip.isUserInteractionEnabled = true
        }
    }
}

extension WalkThoroughVC : UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walkthroughItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkThoroughCVC", for: indexPath) as? WalkThoroughCVC else {
            return UICollectionViewCell()
        }
        
        let item = walkthroughItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    // Update page control when swiping manually
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageController.currentPage = currentPage
        self.checkVisibiltyForNextBytton()
        updateButtonVisibility()
        
    }
    
}
struct WalkthroughItem {
    let title: String
    let subTitle : String
    let image: UIImage
}
