//
//  ChangePassVC.swift
//  BrittsImperial
//
//  Created by Khuss on 28/06/24.
//

import UIKit

class ChangePassVC: UIViewController {

    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtOldPass.isSecureTextEntry = true
        txtNewPass.isSecureTextEntry = true
        txtConfirmPass.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_CHANGE(_ sender: UIButton) {
        changePassword()
    }
    
    func changePassword() {
        guard let oldPassword = txtOldPass.text, !oldPassword.isEmpty else {
            Toast(text: "Please enter your old password").show()
            return
        }
        
        guard let newPassword = txtNewPass.text, !newPassword.isEmpty else {
            Toast(text: "Please enter a new password").show()
            return
        }
        
        guard let confirmPassword = txtConfirmPass.text, !confirmPassword.isEmpty else {
            Toast(text: "Please confirm your new password").show()
            return
        }
        
        guard newPassword == confirmPassword else {
            Toast(text: "New password and confirm password do not match").show()
            return
        }
        
        guard oldPassword == UserDefaultsHelper.getStudentPassword() ?? "" else {
            Toast(text: "Old password is not match.").show()
            return
        }
        // Add additional password validation if needed
        
        // Call the API to change the password
        callChangePass()
    }
    
    func handleLogout() {
        // Code to execute when "Yes" is tapped
        print("User tapped 'Yes'")
        resetUserDefaults()
        
        
        if let window = UIApplication.shared.windows.first {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationHomeVC = UINavigationController(rootViewController: homeVC)
            window.rootViewController = navigationHomeVC
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension ChangePassVC{
    func callChangePass(){
        APIManagerHandler.shared.callSOAPAPI_change_std_pass(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(DeliveryTimetableModel.self, from: jsonData)
                    
                    Toast(text: "Password change success.").show()
                    
                    sleep(2)
                    self.handleLogout()
                    //UserDefaultsHelper.setStudentPassword(self.txtNewPass.text ?? "")
                    
                    //self.navigationController?.popViewController(animated: true)
                    print("Decoded Person: \(responseModel)")
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
        <change_std_pass xmlns="http://tempuri.org/">
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
                <new_pass>\(self.txtNewPass.text ?? "")</new_pass>
                      <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
            </change_std_pass>
             
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
