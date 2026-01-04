//
//  UnitListVC.swift
//  BrittsImperial
//
//  Created by Khuss on 21/10/23.
//

import UIKit

class UnitListVC: UIViewController {
    
    @IBOutlet weak var tblAssignment: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrUnitList = [ScheduleListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        
//                        var unit_name = ""
//                        
//                        for items in data{
//                            if let unitName = items.unitName, unitName != unit_name{
//                                unit_name = unitName
//                                self.arrUnitList.append(items)
//                                
//                            }
//                        }
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM, yyyy" // Match the format of the dates in the JSON

                        // Current date
                        let currentDate = Date()
                        
                        let filteredUnits = data.filter { unit in
                            
                            if unit.unitName != nil{
                                if let endDate = dateFormatter.date(from: unit.endDate ?? "") {
                                    return endDate < currentDate
                                }
                            }
                            
                            return false
                            
                        }
                        
                        
                        self.arrUnitList = self.removeDuplicates(from: filteredUnits)
                        //self.arrUnitList = filteredUnits
                        
                        self.tblAssignment.reloadData()
                        
                        self.lblTitle.text = "Total \(self.arrUnitList.count) Unit's"
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
    
    func removeDuplicates(from array: [ScheduleListData]) -> [ScheduleListData] {
        var uniqueUnits = [String: ScheduleListData]()
        var unitNamesSet = [ScheduleListData]()
        
        var unitCode = ""
        for unit in array {
            
            if unit.unitCode ?? "" != unitCode{
                unitCode = unit.unitCode ?? ""
                unitNamesSet.append(unit)
            }
        }
        
        // Convert dictionary values to an array
        return unitNamesSet
    }
}

extension UnitListVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUnitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UnitListCell
        
        cell.lblUnitName.text = arrUnitList[indexPath.row].unitName ?? ""
        cell.lblUnitCode.text = arrUnitList[indexPath.row].unitCode ?? ""
        
        cell.lblUnitNumber.text = String(format: "%2d", indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if Constants.selectedMenu == .Assignement{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "CourseVC") as! CourseVC
            next.type = "Assignment"
            next.unitCode = arrUnitList[indexPath.row].unitCode ?? ""
            next.unitTitle = arrUnitList[indexPath.row].unitName ?? ""
            self.navigationController?.pushViewController(next, animated: true)
        }else if Constants.selectedMenu == .Course{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "CourseVC") as! CourseVC
            next.unitCode = arrUnitList[indexPath.row].unitCode ?? ""
            next.unitTitle = arrUnitList[indexPath.row].unitName ?? ""
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if Constants.selectedMenu == .Video{
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "VideoGallaryVC") as! VideoGallaryVC
            next.unitCode = arrUnitList[indexPath.row].unitCode ?? ""
            next.unitTitle = arrUnitList[indexPath.row].unitName ?? ""
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
}


extension UnitListVC{
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
                      <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
                        <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
                    </dis_full_view_ac_cal_for_student>
                  </soap:Body>
                </soap:Envelope>
                """
        
        return stringParams
    }
}
