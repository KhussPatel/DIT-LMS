//
//  Validation.swift
//  BrittsImperial
//
//  Created by Khuss on 08/10/23.
//

import Foundation
import UIKit

class Validator {
    static func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for email validation
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isStringNotEmpty(_ input: String) -> Bool {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedInput.isEmpty
    }
    
    static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let numericCharacterSet = CharacterSet.decimalDigits
        let phoneNumberCharacterSet = CharacterSet(charactersIn: phoneNumber)
        // Check if the phone number contains only numeric characters
        return numericCharacterSet.isSuperset(of: phoneNumberCharacterSet)
    }
    
}


class AlertHelper {
    
    static func showAlert(from viewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertWithYesNo(from viewController: UIViewController, title: String, message: String, yesAction: @escaping () -> Void, noAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            yesAction()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            noAction?()
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
