//
//  LoginVC.swift
//  BrittsImperial
//
//  Created by Khuss on 25/09/23.
//

import UIKit
import SwiftLoader


class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    func delay(seconds: Double, completion: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("LoginVC======LoginVC=====LoginVC=====LoginVC")
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        CheckUpdate.shared.showUpdate(withConfirmation: false)
        
    }
    
    @IBAction func btn_REGISTER(_ sender: UIButton) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func btn_POLICY_TERMs(_ sender: UIButton) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        loginVC.isFrom = .login
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func btn_HIDE_SHOW(_ sender: UIButton) {
        sender.isSelected.toggle()
            txtPass.isSecureTextEntry = !sender.isSelected
       
    }
    
    @IBAction func btn_FORGOT_PASS(_ sender: UIButton) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPassewordVC") as! ForgotPassewordVC
        self.navigationController?.pushViewController(loginVC, animated: true)
       
    }
    
    @IBAction func btn_LOGIN(_ sender: UIButton) {
        
        if !(Validator.isValidEmail(txtEmail.text ?? "")){
            print("Invalid Email")
            Toast(text: "Please enter valid email address.").show()
            return
        }
        
        if let text = txtPass.text, text.isEmpty {
            print("Invalid Email")
            Toast(text: "Please enter password.").show()
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
                    
                    if let stdData = studentData.result, stdData.count > 0{
                        
                        if let stdType = stdData[0].stdType, stdType == "g"{
                            //Guest Student
                            UserDefaultsHelper.setIsLogin(true)
                            UserDefaultsHelper.setStudentType("g")
                            UserDefaultsHelper.setStudentFName(stdData[0].fName ?? "")
                            UserDefaultsHelper.setMobileNo(stdData[0].mobileNo ?? "")
                            UserDefaultsHelper.setStudentEmail(stdData[0].email ?? "")
                            
                            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuestDashboardVC") as! GuestDashboardVC
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }else{
                            //Registerd Student
                            UserDefaultsHelper.setStudentType("s")
                            UserDefaultsHelper.setStudentPassword(self.txtPass.text ?? "")
                            UserDefaultsHelper.setStudentId(stdData[0].id ?? 0)
                            UserDefaultsHelper.setStudentEmail(stdData[0].email ?? "")
                            UserDefaultsHelper.setStudentUserName(stdData[0].username ?? "")
                            UserDefaultsHelper.setStudentFMName(stdData[0].fmName ?? "")
                            UserDefaultsHelper.setStudentFName(stdData[0].fName ?? "")
                            UserDefaultsHelper.setCOE_CODE(stdData[0].coeCode ?? "")
                            UserDefaultsHelper.setCampus(stdData[0].campus ?? "")
                            
                            UserDefaultsHelper.setSTD_ID(stdData[0].stdID ?? "")
                            UserDefaultsHelper.setCourseCode(stdData[0].courseCode ?? "")
                            
                            UserDefaultsHelper.setCourseName(stdData[0].courseName ?? "")
                            
                            UserDefaultsHelper.setProfilePic(stdData[0].profilePicLive ?? "")
                            
                            UserDefaultsHelper.setExpiry(stdData[0].proposedEndDate ?? "")
                            
                            UserDefaultsHelper.setdob(stdData[0].dob ?? "")
                            
                            UserDefaultsHelper.setMobileNo(stdData[0].mobileNo ?? "")
                            
                            UserDefaultsHelper.setProposed_start_date(stdData[0].proposedStartDate ?? "")
                            UserDefaultsHelper.setProposed_end_date(stdData[0].proposedEndDate ?? "")
//                            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
//                            self.navigationController?.pushViewController(loginVC, animated: true)
                            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                            self.navigationController?.pushViewController(loginVC, animated: true)
                        }
                       
                    }
                    
                    
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

extension LoginVC{
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
            <student_login_by_email xmlns="http://tempuri.org/">
              <email>\(txtEmail.text ?? "")</email>
            <pass>\(txtPass.text ?? "")</pass>
              <device_id></device_id>
              <from></from>
            </student_login_by_email>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}

enum ScreenSource: String {
    case first = "First"
    case login = "Login"
    case sidemenu = "Sidemenu"
}
