//
//  ForgotPassewordVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/09/23.
//

import UIKit

class ForgotPassewordVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_FORGOT_PASS(_ sender: UIButton) {
        if !(Validator.isValidEmail(txtEmail.text ?? "")){
            print("Invalid Email")
            Toast(text: "Please enter valid email address.").show()
            return
        }
        
        APIManagerHandler.shared.callSOAPAPI(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let studentData = try JSONDecoder().decode(StudentLoginModel.self, from: jsonData)
                    
                    
                    guard let success = studentData.success, success != "0" else {
                        Toast(text: "something went wrong").show()
                        return
                        
                    }
                    
                    AlertHelper.showAlert(from: self, title: "Success", message: "Password reset link send into your email , please checkout your email", completion: {
                        print("OK button tapped")
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    
                    print("Decoded Person: \(studentData)")
                } catch {
                    print("Error decoding data: \(error)")
                }
                
                print("JSON Response: \(jsonData)")
            case .failure(let error):
                // Handle the error here
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       
    }
    
}


extension ForgotPassewordVC{
    func getRequestXML() -> String{
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
            <send_emp_forgot_pass_mail xmlns="http://tempuri.org/">
              <email>\(txtEmail.text ?? "")</email>
            </send_emp_forgot_pass_mail>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
