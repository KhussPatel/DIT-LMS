//
//  ImagePickerHelper.swift
//  BrittsImperial
//
//  Created by mac on 27/07/24.
//

import Foundation
import UIKit

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var pickerController: UIImagePickerController!
    private weak var viewController: UIViewController?
    private var completion: ((UIImage?) -> Void)?

    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        pickerController = UIImagePickerController()
        pickerController.delegate = self
    }
    
    func showImagePickerOptions(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        let alert = UIAlertController(title: "Select Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                self.showImagePicker(sourceType: .camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
                self.showImagePicker(sourceType: .photoLibrary)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        pickerController.sourceType = sourceType
        viewController?.present(pickerController, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        completion?(image)
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(nil)
        pickerController.dismiss(animated: true, completion: nil)
    }
}
