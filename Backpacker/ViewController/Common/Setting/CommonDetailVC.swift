//
//  CommonDetailVC.swift
//  Backpacker
//
//  Created by Mobile on 04/08/25.
//

import UIKit

class CommonDetailVC: UIViewController {

    @IBOutlet weak var collection_Vw: UICollectionView!
    let colArray = ["Account Details","Company Details"]
    var selectedIndex =  0
    @IBOutlet weak var containerVw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collection_Vw.reloadData()
          // Select and trigger index 0 after reload
        DispatchQueue.main.async { [self] in
              let defaultIndexPath = IndexPath(item: selectedIndex, section: 0)
              self.collection_Vw.selectItem(at: defaultIndexPath, animated: false, scrollPosition: [])
              self.collectionView(self.collection_Vw, didSelectItemAt: defaultIndexPath)
          }
    }
    func setUpUi(){
        self.selectedIndex = 0
        collection_Vw.register(UINib(nibName: "MainJobCVC", bundle: nil), forCellWithReuseIdentifier: "MainJobCVC")
        collection_Vw.delegate = self
        collection_Vw.dataSource = self
        collection_Vw.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
}
extension CommonDetailVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainJobCVC", for: indexPath) as? MainJobCVC else {
            return UICollectionViewCell()
        }
        
        cell.title_header.text = colArray[indexPath.item]
        cell.showBottomView(indexPath.item == selectedIndex)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath.item
        let indexesToReload = [
            IndexPath(item: previousIndex, section: 0),
            IndexPath(item: selectedIndex, section: 0)
        ]
        collectionView.reloadItems(at: indexesToReload)
        
        // Remove previous child
        for subview in containerVw.subviews {
            subview.removeFromSuperview()
        }
        for child in children {
            child.removeFromParent()
        }
        
        // Load new VC from respective storyboard
        var storyboardName = ""
        var vcIdentifier = ""
#if BackpackerHire
        switch selectedIndex {
        case 0:
            storyboardName = "Setting"
            vcIdentifier = "AccountDetailVC"
        case 1:
            storyboardName = "Setting"
            vcIdentifier = "CompanyDetailVC"
        default:
            return
        }
        if let newVC = loadViewController(from: storyboardName, identifier: vcIdentifier) {
                addChild(newVC)
                newVC.view.frame = containerVw.bounds
                containerVw.addSubview(newVC.view)
                newVC.didMove(toParent: self)
        }
#endif
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = colArray[indexPath.item]
        let font = FontManager.inter(.medium, size: 12.0) // Adjust if you use custom font
        let padding: CGFloat = 20 // Add padding for horizontal margins
        
        let textWidth = title.size(withAttributes: [.font: font]).width
        
        return CGSize(width: textWidth + padding, height: 50) // Adjust height as per design
    }
    func loadViewController(from storyboardName: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
