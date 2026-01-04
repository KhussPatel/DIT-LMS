//
//  ViewController.swift
//  BrittsImperial
//
//  Created by Khuss on 25/09/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //callLoginAPI()
    }
    
    func callLoginAPI() {
        APIManagerHandler.shared.callSOAPAPI(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                do {
                    let studentData = try JSONDecoder().decode(StudentLoginModel.self, from: jsonData)
                    
                    guard let success = studentData.success, success != "0" else {
                        DispatchQueue.main.async {
                            Toast(text: "Something went wrong").show()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           
                            
                            if let dashboardVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC {
                                let navController = UINavigationController(rootViewController: dashboardVC)
                                navController.isNavigationBarHidden = true
                                
                                guard let window = UIApplication.shared.windows.first else { return }
                                window.rootViewController = navController
                                window.makeKeyAndVisible()
                                
                                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
                            }
                        }
                        return
                    }
                    
                    if let stdData = studentData.result, stdData.count > 0 {
                        DispatchQueue.main.async {
                            self.handleNavigationBasedOnStudentType("s", stdData[0])
                        }
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func handleNavigationBasedOnStudentType(_ stdType: String, _ student: StudentLoginData) {
        // Store the student data first
        if stdType == "g" {
            UserDefaultsHelper.setIsLogin(true)
            UserDefaultsHelper.setStudentType("g")
            UserDefaultsHelper.setStudentFName(student.fName ?? "")
            UserDefaultsHelper.setMobileNo(student.mobileNo ?? "")
            UserDefaultsHelper.setStudentEmail(student.email ?? "")
        } else {
            UserDefaultsHelper.setStudentType("s")
            UserDefaultsHelper.setStudentId(student.id ?? 0)
            UserDefaultsHelper.setStudentEmail(student.email ?? "")
            UserDefaultsHelper.setStudentUserName(student.username ?? "")
            UserDefaultsHelper.setStudentFMName(student.fmName ?? "")
            UserDefaultsHelper.setStudentFName(student.fName ?? "")
            UserDefaultsHelper.setCOE_CODE(student.coeCode ?? "")
            UserDefaultsHelper.setCampus(student.campus ?? "")
            UserDefaultsHelper.setSTD_ID(student.stdID ?? "")
            UserDefaultsHelper.setCourseCode(student.courseCode ?? "")
            UserDefaultsHelper.setCourseName(student.courseName ?? "")
            UserDefaultsHelper.setProfilePic(student.profilePicLive ?? "")
            UserDefaultsHelper.setExpiry(student.proposedEndDate ?? "")
            UserDefaultsHelper.setdob(student.dob ?? "")
            UserDefaultsHelper.setMobileNo(student.mobileNo ?? "")
            UserDefaultsHelper.setProposed_start_date(student.proposedStartDate ?? "")
            UserDefaultsHelper.setProposed_end_date(student.proposedEndDate ?? "")
        }

        // After storing the data, navigate to the appropriate dashboard
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewControllerIdentifier = ""
            
            if stdType == "g" {
                viewControllerIdentifier = "GuestDashboardVC"
            } else {
                viewControllerIdentifier = "DashboardVC"
            }
            
            if let dashboardVC = storyboard.instantiateViewController(identifier: viewControllerIdentifier) as? UIViewController {
                let navController = UINavigationController(rootViewController: dashboardVC)
                navController.isNavigationBarHidden = true
                
                guard let window = UIApplication.shared.windows.first else { return }
                window.rootViewController = navController
                window.makeKeyAndVisible()
                
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
    }
    
    func getRequestXML() -> String {
        let stringParams: String = """
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
              <email>\(UserDefaultsHelper.getStudentUserName() ?? "")</email>
              <pass>\(UserDefaultsHelper.getStudentPassword() ?? "")</pass>
              <device_id></device_id>
              <from></from>
            </student_login_by_email>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}


