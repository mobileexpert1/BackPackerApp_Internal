//
//  MediaPickerManager.swift
//  Backpacker
//
//  Created by Mobile on 23/07/25.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import PhotosUI
class MediaPickerManager: NSObject {
    
    private weak var presentingVC: UIViewController?
    private var imagePickedHandler: ((UIImage) -> Void)?
    private var isComeFromNewAccommodation: Bool = false
    private var multipleImagesPickedHandler: (([UIImage]) -> Void)?

    init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
    }
    
    func showMediaOptions(isFromNewAccommodation: Bool, singleImageHandler: @escaping (UIImage) -> Void, multipleImagesHandler: (([UIImage]) -> Void)? = nil) {
        self.isComeFromNewAccommodation = isFromNewAccommodation
        self.imagePickedHandler = singleImageHandler
        self.multipleImagesPickedHandler = multipleImagesHandler
        
        let alert = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            if isFromNewAccommodation {
                self.openMultipleGalleryPicker()
            } else {
                self.openGallery()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        presentingVC?.present(alert, animated: true)
    }

    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert("Camera not available")
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.presentPicker(sourceType: .camera)
                } else {
                    self.showSettingsAlert("Camera access is denied. Please enable it from settings.")
                }
            }
        }
    }
    
    private func openGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            self.presentPicker(sourceType: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.presentPicker(sourceType: .photoLibrary)
                    } else {
                        self.showSettingsAlert("Photo library access is denied. Please enable it from settings.")
                    }
                }
            }
        default:
            showSettingsAlert("Photo library access is denied. Please enable it from settings.")
        }
    }

    private func openMultipleGalleryPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0 = unlimited selection
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        presentingVC?.present(picker, animated: true)
    }

    private func presentPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        presentingVC?.present(picker, animated: true, completion: nil)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        presentingVC?.present(alert, animated: true)
    }
    
    private func showSettingsAlert(_ message: String) {
        let alert = UIAlertController(title: "Permission Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        presentingVC?.present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MediaPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let selectedImage = image {
            imagePickedHandler?(selectedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
extension MediaPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var selectedImages: [UIImage] = []
        let group = DispatchGroup()
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        selectedImages.append(image)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.multipleImagesPickedHandler?(selectedImages)
        }
    }
}
