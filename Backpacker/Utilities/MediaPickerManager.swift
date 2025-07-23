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

class MediaPickerManager: NSObject {
    
    private weak var presentingVC: UIViewController?
    private var imagePickedHandler: ((UIImage) -> Void)?
    
    init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
    }
    
    func showMediaOptions(completion: @escaping (UIImage) -> Void) {
        self.imagePickedHandler = completion
        
        let alert = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        presentingVC?.present(alert, animated: true, completion: nil)
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
