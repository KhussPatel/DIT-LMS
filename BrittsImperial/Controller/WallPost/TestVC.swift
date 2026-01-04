//
//  TestVC.swift
//  BrittsImperial
//
//  Created by mac on 22/07/24.
//

import UIKit

class TestVC: UIViewController {
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUnitList()
    }
    
    func getUnitList(){
        APIManagerHandler.shared.callSOAPAPIforDis_full_view_ac_cal_for_student(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(ScheduleListModel.self, from: jsonData)
                    
                    if let data = responseModel.result{
                        
                        var unit_name = ""
                        
                        for items in data{
                            if let unitName = items.unitName, unitName != unit_name{
                                unit_name = unitName
                                //self.arrUnitList.append(items)
                                self.txtView.text += unitName + "\n"
                            }
                        }
                        
                        
                        
                        //self.tblAssignment.reloadData()
                        
                        //self.lblTitle.text = "Total \(self.arrUnitList.count) Unit's"
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
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}




extension TestVC{
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
                 <dis_full_view_ac_cal_for_student xmlns="http://tempuri.org/">
                      <coe_code>\(UserDefaultsHelper.getCOE_CODE() ?? "")</coe_code>
                    </dis_full_view_ac_cal_for_student>
                  </soap:Body>
                </soap:Envelope>
                """
        
        return stringParams
    }
}
