//
//  AcademicVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/06/24.
//

import UIKit

class AcademicVC: UIViewController {
    @IBOutlet weak var tblTimeTable: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    
    var arrTimeTable = [AcademicTimeTableList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAcademicTimeTable()
    }

    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AcademicVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcademicCell") as! AcademicCell
        cell.setData(obj: arrTimeTable[indexPath.row])
        return cell
    }
    
    
}

extension AcademicVC{
    
    
    func getAcademicTimeTable(){
        APIManagerHandler.shared.callSOAPAPI_dis_student_wise_cap_chart(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(AcademicTimeTableModel.self, from: jsonData)
                    
                    if let temp = responseModel.result, temp.count > 0{
                        self.arrTimeTable = temp
                        self.vwHeader.isHidden = false
                    }else{
                        self.arrTimeTable.removeAll()
                        self.vwHeader.isHidden = true
                    }
                    
                    self.tblTimeTable.reloadData()
                    
                    
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
             <dis_student_wise_cap_chart xmlns="http://tempuri.org/">
                  <coe_code>\(UserDefaultsHelper.getCOE_CODE() ?? "")</coe_code>
                              <campus>\(UserDefaultsHelper.getCampus() ?? "")</campus>
                </dis_student_wise_cap_chart>
              </soap:Body>
            </soap:Envelope>
            """
        
        return stringParams
    }
    
}
//MARK: ------ UITableViewCell ---------
class AcademicCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblSTime: UILabel!
    @IBOutlet weak var lblETime: UILabel!
    @IBOutlet weak var lblClassRoom: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setData(obj: AcademicTimeTableList){
        if let dday = obj.dayName{
            //lblDay.text = shortDayName(from: day)
            lblDay.text = dday
        }
        
        
//        if let room = obj.classRoom{
//            lblClassRoom.text = removeRoomPrefix(from: room)
//        }else{
//            lblClassRoom.text = obj.classRoom ?? ""
//        }
        
        if let room = obj.classRoom{
            lblClassRoom.text = room
        }
        
        
        lblSTime.text = obj.fromTime ?? ""
        lblETime.text = obj.toTime ?? ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shortDayName(from fullName: String) -> String? {
        let dayMapping: [String: String] = [
            "Monday": "Mon",
            "Tuesday": "Tue",
            "Wednesday": "Wed",
            "Thursday": "Thu",
            "Friday": "Fri",
            "Saturday": "Sat",
            "Sunday": "Sun"
        ]
        
        return dayMapping[fullName]
    }

    func removeRoomPrefix(from string: String) -> String {
        let result = string.replacingOccurrences(of: "Room ", with: "")
        return result
    }
}
