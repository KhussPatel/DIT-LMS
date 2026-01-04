//
//  DeliveryTimeVC.swift
//  BrittsImperial
//
//  Created by Khuss on 07/10/23.
//

import UIKit

class DeliveryTimeVC: UIViewController {

    @IBOutlet weak var tblDelivery: UITableView!
    
    var dTimetable = [DeliveryTimetableData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDeliveryTimeTable()
    }
    
    func getDeliveryTimeTable(){
        APIManagerHandler.shared.callSOAPAPIfor_dis_del_timetable_for_student(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(DeliveryTimetableModel.self, from: jsonData)
                    
                    if let dt = responseModel.result,dt.count > 0{
                        self.dTimetable = dt
                        self.tblDelivery.reloadData()
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

extension DeliveryTimeVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dTimetable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DeliveryTimeCell
        
        let tempData = dTimetable[indexPath.row]
        cell.lblDay.text = tempData.dayName ?? ""
        cell.lblTime.text = "\(tempData.fromTime ?? "") onwards"
        cell.lblPermisis.text = tempData.premises ?? ""
        cell.lblTrainerName.text = tempData.trainerName ?? ""
        cell.btnTrainerEmail.setTitle(tempData.trainerEmail ?? "", for: .normal)
        
        cell.btnTrainerEmail.tag = indexPath.row

        cell.btnTrainerEmail.addTarget(self, action: #selector(emailTrainee(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func emailTrainee(sender: UIButton){
        let buttonTag = sender.tag
        let strEmail = dTimetable[sender.tag].trainerEmail ?? ""
        
//        guard let appURL = URL(string: strEmail) else{
//            print("No email found!!!!")
//            return
//        }
        
        let email = "foo@bar.com"
        if let url = URL(string: "mailto:\(strEmail)") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(appURL)
//        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension DeliveryTimeVC{
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
        <dis_del_timetable_for_student xmlns="http://tempuri.org/">
              <coe_code>\(UserDefaultsHelper.getCOE_CODE() ?? "")</coe_code>
            </dis_del_timetable_for_student>
             
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
