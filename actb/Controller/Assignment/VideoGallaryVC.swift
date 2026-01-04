//
//  VideoGallaryVC.swift
//  BrittsImperial
//
//  Created by Khuss on 02/10/23.
//

import UIKit

class VideoGallaryVC: UIViewController {

    @IBOutlet weak var tblAssignment: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var arrUnitDetails = [UnitDetailstResult]()
    var unitCode = ""
    var unitTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = unitTitle
        
        getVideoGallary()
        
    }
    
    func getVideoGallary(){
        APIManagerHandler.shared.callSOAPAPIforDis_unit_video(requestXMLStr: getRequestXML()) { result in
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
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VideoGallaryVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUnitDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoGallaryCell
        
        cell.lblTitle.text = arrUnitDetails[indexPath.row].name ?? ""
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let urlString = arrUnitDetails[indexPath.row].video else {
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


extension VideoGallaryVC{
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
        <dis_unit_video xmlns="http://tempuri.org/">
              <unit_code>\(unitCode)</unit_code>
                      <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
            </dis_unit_video>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
