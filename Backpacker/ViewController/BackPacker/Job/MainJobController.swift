//
//  MainJobController.swift
//  Backpacker
//
//  Created by Mobile on 21/07/25.
//

import UIKit

class MainJobController: UIViewController {
    
    @IBOutlet weak var title_Header: UILabel!
    
    @IBOutlet weak var BtnAddJob: UIButton!
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var collVw: UICollectionView!
#if BackpackerHire
    let colArray = ["Job Post","Backpackers"]
 
        let designationsJobs : [JobsDesignation] = [
            JobsDesignation(Name: "Software Engineer", star: "5 Star",distance: "10 Km"),
            JobsDesignation(Name: "UI/UX Designer", star: "2 Star",distance: "2 Km"),
            JobsDesignation(Name: "Product Manager", star: "3 Star",distance: "5 Km"),
            JobsDesignation(Name: "Data Analyst", star: "4 Star",distance: "10 Km"),
            JobsDesignation(Name: "Mobile Developer", star: "5 Star",distance: "15 Km"),
            JobsDesignation(Name: "QA Tester", star: "3 Star",distance: "10 Km"),
            JobsDesignation(Name: "DevOps Engineer", star: "1 Star",distance: "25 Km"),
            JobsDesignation(Name: "Project Coordinator", star: "22 Star",distance: "10 Km"),
            JobsDesignation(Name: "Backend Developer", star: "4 Star",distance: "20 Km"),
            JobsDesignation(Name: "Technical Lead", star: "4 Star",distance: "10 Km"),
        ]
#else
    let colArray = ["Jobs","Employer","Backpackers","Calendar","History"]
#endif
  
    var selectedIndex =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
#if Backapacker
        self.BtnAddJob.isHidden = true
        self.BtnAddJob.isUserInteractionEnabled = false
#else
        self.BtnAddJob.isHidden = false
        self.BtnAddJob.isUserInteractionEnabled = true
        
#endif
        self.BtnAddJob.titleLabel?.font = FontManager.inter(.medium, size: 12.0)
        collVw.register(UINib(nibName: "MainJobCVC", bundle: nil), forCellWithReuseIdentifier: "MainJobCVC")
        collVw.delegate = self
        collVw.dataSource = self
        collVw.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        self.title_Header.font = FontManager.inter(.semiBold, size: 16.0)
        selectedIndex  =  AppState.shared.selectedJobIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collVw.reloadData()
          // Select and trigger index 0 after reload
        DispatchQueue.main.async { [self] in
              let defaultIndexPath = IndexPath(item: selectedIndex, section: 0)
              self.collVw.selectItem(at: defaultIndexPath, animated: false, scrollPosition: [])
              self.collectionView(self.collVw, didSelectItemAt: defaultIndexPath)
          }
    }
    
    @IBAction func action_AddJob(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Job", bundle: nil)
        if let accVC = storyboard.instantiateViewController(withIdentifier: "AddNewJobVC") as? AddNewJobVC {
            self.navigationController?.pushViewController(accVC, animated: true)
        } else {
            print("❌ Could not instantiate AddNewAccomodationVC")
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
            storyboardName = "Job"
            vcIdentifier = "JobCollectionVC"
        case 1:
            storyboardName = "Job"
            vcIdentifier = "EmployerBackPackerListVC"
        default:
            return
        }
        
        if let newVC = loadViewController(from: storyboardName, identifier: vcIdentifier) {
            // Pass data based on controller type
                switch newVC {
                case let listVC as JobCollectionVC:
                    listVC.filteredDesignations = designationsJobs
                    listVC.isSearchViewVisible = true
                    
                case let listVC as EmployerBackPackerListVC:
                    listVC.iscomeFromEmployer = false
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
