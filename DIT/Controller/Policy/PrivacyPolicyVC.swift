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
        
        // Call API to get privacy policy content
        getPrivacyPolicyData()
        
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
    
    // MARK: - Privacy Policy API Call
    func getPrivacyPolicyData() {
        let requestXML = getPrivacyPolicyRequestXML()
        
        APIManagerHandler.shared.callSOAPAPI_display_privacy_policy(requestXMLStr: requestXML) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    do {
                        print("📱 Raw JSON Response: \(String(data: jsonData, encoding: .utf8) ?? "")")
                        
                        let responseModel = try JSONDecoder().decode(PrivacyPolicyModel.self, from: jsonData)
                        
                        if let success = responseModel.success, success == "1" {
                            // Success case
                            if let htmlContent = responseModel.result?.first?.privacyPolicy {
                                self.displayHTMLContent(htmlContent)
                            } else {
                                print("❌ Error: Privacy policy content is empty")
                                self.lblPP.text = "Privacy policy content not available."
                            }
                        } else {
                            // Error case
                            print("❌ Error: Privacy policy not found")
                            self.lblPP.text = "Privacy policy not available."
                        }
                        
                    } catch {
                        print("Error decoding privacy policy response: \(error)")
                        self.lblPP.text = "Error loading privacy policy."
                    }
                    
                case .failure(let error):
                    print("Privacy Policy API Error: \(error.localizedDescription)")
                    self.lblPP.text = "Network error. Please try again."
                }
            }
        }
    }
    
    private func displayHTMLContent(_ htmlString: String) {
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
                lblPP.text = "Error parsing privacy policy content."
            }
        } else {
            lblPP.text = "Invalid privacy policy content."
        }
    }
    
    private func getPrivacyPolicyRequestXML() -> String {
        let stringParams : String = """
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <AuthUser xmlns="http://tempuri.org/">
              <UserName>Admin</UserName>
              <Password>123</Password>
              <Token>College</Token>
            </AuthUser>
          </soap:Header>
          <soap:Body>
            <display_privacy_policy xmlns="http://tempuri.org/">
            </display_privacy_policy>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
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


enum ScreenSource: String {
    case first = "First"
    case login = "Login"
    case sidemenu = "Sidemenu"
}

// MARK: - Privacy Policy Response Model
struct PrivacyPolicyModel: Codable {
    let success: String?
    let result: [PrivacyPolicyResult]?
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case result
    }
}

struct PrivacyPolicyResult: Codable {
    let privacyPolicy: String?
    
    enum CodingKeys: String, CodingKey {
        case privacyPolicy = "policy"
    }
}
