//
//  DropdownHelper.swift
//  Backpacker
//
//  Created by Mobile on 31/07/25.
//

import Foundation
import UIKit
 
class DropdownHelper: NSObject, UITableViewDelegate, UITableViewDataSource {

     private let containerView = UIView()

     private let tableView = UITableView()

     private var options: [String]

     private var optionImages: [String]

     private var selectedIndex: IndexPath?

     private weak var parentView: UIView?

     private weak var anchorButton: UIButton?

     var onOptionSelected: ((String) -> Void)?

     private var isDropdownOpen = false

     init(parentView: UIView, anchorButton: UIButton, options: [String], optionImages: [String]) {

         self.options = options

         self.optionImages = optionImages

         self.parentView = parentView

         self.anchorButton = anchorButton

         super.init()

         setupUI()

     }

     private func setupUI() {

         guard let parentView = parentView else { return }

         // Container

         containerView.layer.cornerRadius = 10

         containerView.layer.masksToBounds = false

         containerView.layer.shadowColor = UIColor.black.cgColor

         containerView.layer.shadowOpacity = 0.15

         containerView.layer.shadowOffset = CGSize(width: 0, height: 3)

         containerView.layer.shadowRadius = 6

         containerView.layer.borderWidth = 1

         containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor

         containerView.isHidden = true

         containerView.translatesAutoresizingMaskIntoConstraints = false

         parentView.addSubview(containerView)

         // TableView

         tableView.delegate = self

         tableView.dataSource = self

         tableView.layer.cornerRadius = 10

         tableView.layer.masksToBounds = true

         tableView.rowHeight = 40

         tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 10)

         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

         tableView.translatesAutoresizingMaskIntoConstraints = false

         containerView.addSubview(tableView)

         // Constraints

         NSLayoutConstraint.activate([

             containerView.topAnchor.constraint(equalTo: anchorButton!.bottomAnchor, constant: 5),

             containerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -25),


             containerView.widthAnchor.constraint(equalToConstant: 150),

             containerView.heightAnchor.constraint(equalToConstant: 130),

             tableView.topAnchor.constraint(equalTo: containerView.topAnchor),

             tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

             tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

             tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)

         ])

     }

     func toggleDropdown() {

         isDropdownOpen.toggle()

         containerView.isHidden = !isDropdownOpen

     }

     // MARK: - TableView DataSource & Delegate

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return options.count

     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = FontManager.inter(.medium, size: 14)
        cell.textLabel?.textColor = .black

        // Add 20pt padding to the left using inset
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.frame = CGRect(x: 20, y: 0, width: cell.contentView.frame.width - 20, height: cell.contentView.frame.height)
        cell.textLabel?.textAlignment = .left

        cell.imageView?.image = nil // remove any image if reused

        cell.backgroundColor = (selectedIndex == indexPath) ?
        UIColor.systemBlue.withAlphaComponent(0.2) :
            UIColor.white

        return cell
    }


     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         selectedIndex = indexPath

         let selectedOption = options[indexPath.row]
         onOptionSelected?(selectedOption)
         toggleDropdown()

     }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

 }
