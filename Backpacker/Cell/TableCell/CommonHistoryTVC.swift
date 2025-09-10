//
//  CommonHistoryTVC.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import UIKit

class CommonHistoryTVC: UITableViewCell {

    @IBOutlet weak var collVw: UICollectionView!
    var jobdata = [EmpJob]() {
        didSet {
            collVw.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero

        let nib = UINib(nibName: "HomeJobCVC", bundle: nil)
        collVw.register(nib, forCellWithReuseIdentifier: "HomeJobCVC")
        collVw.dataSource = self
        collVw.delegate = self
        collVw.showsHorizontalScrollIndicator = false
        collVw.showsVerticalScrollIndicator = true

        if let layout = collVw.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
    }


        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
}


extension CommonHistoryTVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobdata.count
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeJobCVC", for: indexPath) as? HomeJobCVC else {
            return UICollectionViewCell()
        }
         let declineJob = jobdata[indexPath.item]
            cell.onTap = { [weak self]  index in
                guard let self = self else { return }
                print("Cell tapped at index: \(indexPath.item)")
                // Navigate or perform any action
                //self.onTap?(indexPath.item)
            }
            cell.onFavTap = { [weak self]  index in
                guard let self = self else { return }
                print("Cell Fav tapped at index: \(indexPath.item)")
                // Navigate or perform any action
                //self.onFavTap?(indexPath.item)
            }
            // Assign item to your label/image inside the cell
            // cell.titleLabel.text = item
            cell.lbl_Title.text = jobdata[indexPath.item].name ?? "No Data"
        if let amnt = jobdata[indexPath.item].price{
            cell.lblAmount.text = "$\(amnt) per day"
        }
               
            cell.lbl_SubTitle.text = jobdata[indexPath.item].description ?? "No Data"
            let baseURL1 = ApiConstants.API.API_IMAGEURL
            let baseURL2 = ApiConstants.API.API_IMAGEURL
            
            let imageURLString: String
            if let imagePath = declineJob.image, !imagePath.isEmpty {
                imageURLString = imagePath.hasPrefix("http") ? imagePath : baseURL1 + imagePath
            } else {
                imageURLString = ""
            }
            
            cell.imgVw.sd_setImage(
                with: URL(string: imageURLString),
                placeholderImage: UIImage(named: "img_Placehodler")
            ) { image, _, _, _ in
                if image == nil, let imagePath = declineJob.image, !imagePath.isEmpty {
                    let fallbackURL = imagePath.hasPrefix("http") ? imagePath : baseURL2 + imagePath
                    cell.imgVw.sd_setImage(
                        with: URL(string: fallbackURL),
                        placeholderImage: UIImage(named: "img_Placehodler")
                    )
                }
            }
            
            if jobdata[indexPath.item].favoriteStatus == 1 {
                cell.btn_fav.setImage(UIImage(named: "red_heart"), for: .normal)
            }else{
                cell.btn_fav.setImage(UIImage(named: "Heart"), for: .normal)
            }
            cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
            let strtTime = jobdata[indexPath.item].startTime
            let endTime = jobdata[indexPath.item].endTime
            let duration1 = Date.durationString(from: strtTime ?? "", to: endTime ?? "") // "8 hr"
            cell.lbl_duration.text = "Duration \(duration1)"
            cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
            cell.SetUpHeight(isHeightShow: false)
       
        cell.setUpUI(iscomeFromAccept: false,isComeForHiredetailpagee: true)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    // Size of each item (4 per row)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width

            return CGSize(width: (width / 2) - 12, height: 180)
       
    }
    
    // Horizontal spacing between items
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Vertical spacing between rows
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
       
    }
    
    // Section insets (padding from edges)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 8, bottom: 4, right: 8)
        
    }
}
