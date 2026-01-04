//
//  CourseVC.swift
//  BrittsImperial
//
//  Created by Khuss on 02/10/23.
//

import UIKit

class CourseVC: UIViewController {

    @IBOutlet weak var tblAssignment: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrUnitDetails = [UnitDetailstResult]()
    var unitCode = ""
    var unitTitle = ""
    
    var type = "" //Assignment, Cource
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = unitTitle
        
        if type == "Assignment"{
            getassigment()
        }else{
            getCourse()
        }
        
        
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CourseVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUnitDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AssignmentCell
                
        cell.lblUnitName.text = arrUnitDetails[indexPath.row].name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if type == "Assignment"{
            //getassigment()
            guard let urlString = arrUnitDetails[indexPath.row].assignmentPath else {
                print("assignmentPath not found")
                return
            }
            
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
        }else{
            guard let urlString = arrUnitDetails[indexPath.row].resourcesPath else {
                print("assignmentPath not found")
                return
            }
            
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
        }
    }
    
}

extension CourseVC{
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
                <dis_course_resources xmlns="http://tempuri.org/">
                      <unit_code>\(unitCode)</unit_code>
                    </dis_course_resources>
                  </soap:Body>
                </soap:Envelope>
                """
        
        return stringParams
    }
    
    func getCourse(){
        APIManagerHandler.shared.callSOAPAPIfor_dis_course_resources(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(UnitDetailstModel.self, from: jsonData)
                    
                    if let data = responseModel.result{
                        
                        self.arrUnitDetails = data
                        self.tblAssignment.reloadData()
                        
                    }
                    
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
}


extension CourseVC{
    func getassigment(){
        APIManagerHandler.shared.callSOAPAPIfor_dis_assignment(requestXMLStr: getRequestXMLAssignemtn()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(UnitDetailstModel.self, from: jsonData)
                    
                    if let data = responseModel.result{
                        
                        self.arrUnitDetails = data
                        self.tblAssignment.reloadData()
                        
                    }
                    
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
    
    func getRequestXMLAssignemtn() -> String{
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
                 <dis_assignment xmlns="http://tempuri.org/">
                       <unit_code>\(unitCode)</unit_code>
                     </dis_assignment>
                  </soap:Body>
                </soap:Envelope>
                """
        
        return stringParams
    }
}
