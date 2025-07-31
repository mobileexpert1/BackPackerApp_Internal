//
//  HistoryContainerVC.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import UIKit

class HistoryContainerVC: UIViewController {

    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var lbl_MainHeader: UILabel!
    @IBOutlet weak var headercollVw: UICollectionView!
    var selectedIndex =  0
    let colArray = ["Backpackers","Job"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_MainHeader.font = FontManager.inter(.medium, size: 16.0)
        headercollVw.register(UINib(nibName: "MainJobCVC", bundle: nil), forCellWithReuseIdentifier: "MainJobCVC")
        headercollVw.delegate = self
        headercollVw.dataSource = self
        headercollVw.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headercollVw.reloadData()
          // Select and trigger index 0 after reload
        DispatchQueue.main.async { [self] in
              let defaultIndexPath = IndexPath(item: selectedIndex, section: 0)
              self.headercollVw.selectItem(at: defaultIndexPath, animated: false, scrollPosition: [])
              self.collectionView(self.headercollVw, didSelectItemAt: defaultIndexPath)
          }
    }
    
    
    @IBAction func action_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension HistoryContainerVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
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
        AppState.shared.selectedJobIndex = selectedIndex
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
            vcIdentifier = "CommonHistoryVC"
        case 1:
            storyboardName = "Setting"
            vcIdentifier = "CommonHistoryVC"
        default:
            return
        }
        
        if let newVC = loadViewController(from: storyboardName, identifier: vcIdentifier) {
            // Pass data based on controller type
            switch newVC {
            case let listVC as CommonHistoryVC:
                if selectedIndex == 1 {
                    listVC.selectedIndex = 1
                }else{
                    listVC.selectedIndex = 0
                }
                break
            default:
                break
            }
                addChild(newVC)
                newVC.view.frame = containerVw.bounds
                containerVw.addSubview(newVC.view)
                newVC.didMove(toParent: self)
        }
        
        #else
        switch selectedIndex {
        case 0:
            storyboardName = "Home"
            vcIdentifier = "HomeVC"
        case 1:
            storyboardName = "Job"
            vcIdentifier = "EmployerBackPackerListVC"
        case 2:
            storyboardName = "Job"
            vcIdentifier = "EmployerBackPackerListVC"
        case 3:
            storyboardName = "Calendar"
            vcIdentifier = "CalendarVC"
        case 4:
            storyboardName = "History"
            vcIdentifier = "HistoryVC"
        default:
            return
        }
        
        if let newVC = loadViewController(from: storyboardName, identifier: vcIdentifier) {
            // Pass data based on controller type
                switch newVC {
                case let homeVC as HomeVC:
                    break

                case let listVC as EmployerBackPackerListVC:
                    if selectedIndex == 1 {
                        listVC.iscomeFromEmployer = true
                    }else{
                        listVC.iscomeFromEmployer = false
                    }
                case let calendarVC as CalendarVC:
                    break

                case let historyVC as HistoryVC:
                    break
                default:
                    break
                }

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
        let padding: CGFloat = 12 // Add padding for horizontal margins
        
        let textWidth = title.size(withAttributes: [.font: font]).width
        
        return CGSize(width: textWidth + padding, height: 50) // Adjust height as per design
    }
    func loadViewController(from storyboardName: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
