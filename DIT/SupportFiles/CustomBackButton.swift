//
//  CustomBackButton.swift
//  BrittsImperial
//
//  Created by Khuss on 20/07/24.
//

import Foundation
import UIKit

class CustomBackButton: UIButton {
    
    // Set your desired insets here
    private let imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        // Apply the insets to the content rect to get the image rect
        let insetRect = contentRect.inset(by: imageInsets)
        return super.imageRect(forContentRect: insetRect)
    }
}
