//
//  MainJobController.swift
//  Backpacker
//
//  Created by Mobile on 21/07/25.
//

import UIKit

class MainJobController: UIViewController {
    
    @IBOutlet weak var title_Header: UILabel!
    
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var collVw: UICollectionView!
    let colArray = ["Jobs","Job Post","Calendar","History"]
    var selectedIndex =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collVw.register(UINib(nibName: "MainJobCVC", bundle: nil), forCellWithReuseIdentifier: "MainJobCVC")
        collVw.delegate = self
        collVw.dataSource = self
        collVw.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        self.title_Header.font = FontManager.inter(.semiBold, size: 16.0)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collVw.reloadData()
          // Select and trigger index 0 after reload
          DispatchQueue.main.async {
              let defaultIndexPath = IndexPath(item: 0, section: 0)
              self.collVw.selectItem(at: defaultIndexPath, animated: false, scrollPosition: [])
              self.collectionView(self.collVw, didSelectItemAt: defaultIndexPath)
          }
    }
    
}
extension MainJobController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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
        
        switch selectedIndex {
        case 0:
            storyboardName = "Home"
            vcIdentifier = "HomeVC"
        case 1:
            storyboardName = "Job"
            vcIdentifier = "JobPostVC"
        case 2:
            storyboardName = "Calendar"
            vcIdentifier = "CalendarVC"
        case 3:
            storyboardName = "History"
            vcIdentifier = "HistoryVC"
        default:
            return
        }
        
        if let newVC = loadViewController(from: storyboardName, identifier: vcIdentifier) {
            addChild(newVC)
            newVC.view.frame = containerVw.bounds
            containerVw.addSubview(newVC.view)
            newVC.didMove(toParent: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = colArray[indexPath.item]
        let font = FontManager.inter(.medium, size: 12.0) // Adjust if you use custom font
        let padding: CGFloat = 12 // Add padding for horizontal margins
        
        let textWidth = title.size(withAttributes: [.font: font]).width
        
        return CGSize(width: textWidth + padding, height: 50) // Adjust height as per design
    }
    func loadViewController(from storyboardName: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
