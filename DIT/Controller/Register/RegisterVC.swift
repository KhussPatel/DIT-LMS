//
//  RegisterVC.swift
//  BrittsImperial
//
//  Created by mac on 03/03/24.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_REGISTER(_ sender: UIButton) {
        
        if !(Validator.isStringNotEmpty(txtName.text ?? "")){
            print("Invalid Name")
            Toast(text: "Please enter first name.").show()
            return
        }
        
        if !(Validator.isValidEmail(txtEmail.text ?? "")){
            print("Invalid Email")
            Toast(text: "Please enter valid email address.").show()
            return
        }
        
        if !(Validator.isValidPhoneNumber(txtPhone.text ?? "")){
            print("Invalid Phone")
            Toast(text: "Please enter valid phone number.").show()
            return
        }
        
        if !(Validator.isStringNotEmpty(txtPass.text ?? "")){
            print("Invalid Name")
            Toast(text: "Please enter password.").show()
            return
        }
        
        getUserRegister()
        
    }
}



extension RegisterVC {
    func getUserRegister(){
        
        APIManagerHandler.shared.callSOAPAPI_ins_guest_student(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let studentData = try JSONDecoder().decode(StudentLoginModel.self, from: jsonData)
                    
                    
                    guard let success = studentData.success, success != "0" else {
                        Toast(text: "something went wrong").show()
                        return
                        
                    }
                    
                    AlertHelper.showAlert(from: self, title: "Successfully", message: "Register successfully", completion: {
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
}


extension RegisterVC{
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
            <ins_guest_student xmlns="http://tempuri.org/">
              <name>\(txtName.text ?? "")</name>
              <mobile>\(txtPhone.text ?? "")</mobile>
              <email>\(txtEmail.text ?? "")</email>
            <pass>\(txtPass.text ?? "")</pass>
            </ins_guest_student>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
