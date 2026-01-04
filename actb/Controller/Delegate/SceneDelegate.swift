//
//  SceneDelegate.swift
//  BrittsImperial
//
//  Created by Khuss on 25/09/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        if (UserDefaultsHelper.getIsLogin() ?? false) && UserDefaultsHelper.getStudentType() == "g"{
            self.window = UIWindow(windowScene: windowScene)
            //self.window =  UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "GuestDashboardVC") as? GuestDashboardVC else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootNC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        }else if (UserDefaultsHelper.getIsLogin() ?? false) && UserDefaultsHelper.getStudentType() == "s"{
            //self.window = UIWindow(windowScene: windowScene)
            //self.window =  UIWindow(frame: UIScreen.main.bounds)
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            guard let rootVC = storyboard.instantiateViewController(identifier: "DashboardVC") as? DashboardVC else {
//                print("ViewController not found")
//                return
//            }
//            let rootNC = UINavigationController(rootViewController: rootVC)
//            rootNC.setNavigationBarHidden(true, animated: false)
//            self.window?.rootViewController = rootNC
//            self.window?.makeKeyAndVisible()
            
           
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootNC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
                        
            
            callLoginAPI()
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func callLoginAPI() {
        APIManagerHandler.shared.callSOAPAPI(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                do {
                    let studentData = try JSONDecoder().decode(StudentLoginModel.self, from: jsonData)
                    
                    guard let success = studentData.success, success != "0" else {
                        DispatchQueue.main.async {
                            //Toast(text: "Something went wrong").show()
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let rootVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC else {
                                print("ViewController not found")
                                return
                            }
                            let rootNC = UINavigationController(rootViewController: rootVC)
                            rootNC.setNavigationBarHidden(true, animated: false)
                            self.window?.rootViewController = rootNC
                            self.window?.makeKeyAndVisible()
                            
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            if let dashboardVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC {
//                                let navController = UINavigationController(rootViewController: dashboardVC)
//                                navController.isNavigationBarHidden = true
//
//                                guard let window = UIApplication.shared.windows.first else { return }
//                                window.rootViewController = navController
//                                window.makeKeyAndVisible()
//
//                                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
//                            }
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if stdType == "g" {
            // Guest Student
            UserDefaultsHelper.setIsLogin(true)
            UserDefaultsHelper.setStudentType("g")
            UserDefaultsHelper.setStudentFamilyName(student.familyName ?? "")
            UserDefaultsHelper.setMobileNo(student.mobileNo ?? "")
            UserDefaultsHelper.setStudentEmail(student.email ?? "")
            
            guard let guestDashboardVC = storyboard.instantiateViewController(identifier: "GuestDashboardVC") as? GuestDashboardVC else {
                print("GuestDashboardVC not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: guestDashboardVC)
            rootNC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        } else {
            // Registered Student
            UserDefaultsHelper.setStudentType("s")
            
            UserDefaultsHelper.setStudentId(student.id ?? 0)
            UserDefaultsHelper.setStudentEmail(student.email ?? "")
            UserDefaultsHelper.setStudentUserName(student.username ?? "")
            UserDefaultsHelper.setStudentFMName(student.fmName ?? "")
            UserDefaultsHelper.setStudentFamilyName(student.familyName ?? "")
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
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "DashboardVC") as? DashboardVC else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            rootNC.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
            
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


func resetUserDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}
