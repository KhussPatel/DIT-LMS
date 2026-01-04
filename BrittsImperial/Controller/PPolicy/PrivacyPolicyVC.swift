//
//  PrivacyPolicyVC.swift
//  BrittsImperial
//
//  Created by Khushal iOS on 07/08/25.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var lblPP: UILabel!
    @IBOutlet weak var btnCheckbox: UIButton!
    
    @IBOutlet weak var vwButtonCountine: UIView!
    @IBOutlet weak var btnBackk: UIButton!
    
    var isFrom : ScreenSource = .first//Login//sidemenu
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let htmlString = """
                
                <p><b>Last updated:</b> August 7, 2025</p>
                <p>This Privacy Policy describes how we collect, use, and disclose your information when you use our application.</p>
                <p><b>Information Collection:</b> We may collect personal data such as name, email address, device information, and usage statistics.</p>
                <p><b>Contact Us:</b> support@example.com</p>
                                <p><b>Last updated:</b> August 7, 2025</p>
                                <p>This Privacy Policy describes how we collect, use, and disclose your information when you use our application.</p>
                                <p><b>Information Collection:</b> We may collect personal data such as name, email address, device information, and usage statistics.</p>
                                <p><b>Contact Us:</b> support@example.com</p>
                """
        
        // Convert HTML to Attributed String
        if let data = htmlString.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            do {
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                lblPP.attributedText = attributedString
                lblPP.numberOfLines = 0 // Allow multiline
            } catch {
                print("Error parsing HTML: \(error)")
            }
        }
        
        
        switch isFrom {
        case .first:
            setupForFirst()
        case .login, .sidemenu:
            setupForLogin()
        }
        
    }
    
    func setupForFirst(){
        vwButtonCountine.isHidden = false
        btnBackk.isUserInteractionEnabled = false
    }
    
    func setupForLogin(){
        vwButtonCountine.isHidden = true
        btnBackk.isUserInteractionEnabled = true
    }
    
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_CHECKBOX(_ sender: UIButton) {
        
        if btnCheckbox.isSelected{
            btnCheckbox.isSelected = false
        }else{
            btnCheckbox.isSelected = true
        }
        
    }
    
    @IBAction func btn_SUBMIT(_ sender: UIButton) {
        
        if !btnCheckbox.isSelected{
            Toast(text: "Please select checkbox").show()
        }else{
            UserDefaultsHelper.setAcceptPP(true)
            
            self.navigationController?.popViewController(animated: true)
        }
    }

}

