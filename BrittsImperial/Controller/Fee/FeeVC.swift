//
//  FeeVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/10/23.
//

import UIKit

class FeeVC: UIViewController {

    @IBOutlet weak var vwGradiant: UIView!
    @IBOutlet weak var tblFee: UITableView!
    
    @IBOutlet weak var lblTotalFee: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblRemain: UILabel!
    
    var resultData3 = [ResultData3]()
    var resultData2 = [ResultData2]()
    var resultData4 = [ResultData4]()
    var resultData = [ResultData]()
           
    
    var selectedCurrency : ResultData3!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getFee()
    }
    
    func getFee(){
        APIManagerHandler.shared.callSOAPAPI_Display_student_payment_history(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(FeesModel.self, from: jsonData)
                    
                    if let data = responseModel.result{
                        self.resultData = data
                        var totalaAmt = 0
                        var Paid = 0.0
                        var Remain = 0.0
                        
                        
                        for i in data{
                            totalaAmt += i.fee ?? 0
                            Paid += i.collectedFee ?? 0.0
                            Remain += i.remainFee ?? 0.0
                        }
                        
                        self.lblTotalFee.text = "$ \(totalaAmt)"
                        self.lblPaid.text = "$ \(String(format: "%.2f", Paid))"
                        self.lblRemain.text = "$ \(String(format: "%.2f", Remain))"
                    }
                   
                    if let data = responseModel.result2{
                        self.resultData2 = data
                    }
                    
                    if let data = responseModel.result3{
                        self.resultData3 = data
                        
                        self.selectedCurrency = data[0]
                    }
                    
                    if let data = responseModel.result4{
                        self.resultData4 = data
                    }
                    
                    self.tblFee.reloadData()
                    
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
    
    @IBAction func btn_HISTORY(_ sender: UIButton) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeeHistoryVC") as! FeeHistoryVC
        VC.resultData2 = resultData2
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btn_Installment(_ sender: UIButton) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeeInstallmentVC") as! FeeInstallmentVC
        VC.resultData = resultData
        self.navigationController?.pushViewController(VC, animated: true)
    }

}

extension FeeVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData4.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeeCell
        cell.lblTitle.text = "\(indexPath.row + 1). \(resultData4[indexPath.row].feeHead ?? "")"
        
        
        cell.lblTotal.text = "\(selectedCurrency.icon ?? "") \(resultData4[indexPath.row].fee ?? 00)"
        
        cell.lblRemain.text = "\(selectedCurrency.icon ?? "") \(resultData4[indexPath.row].remainFee ?? 00)"
        
        let rmaianAmt = Double(resultData4[indexPath.row].fee ?? 00) - (resultData4[indexPath.row].remainFee ?? 0.0)
        
        cell.lblPaid.text = "\(selectedCurrency.icon ?? "") \(String(format: "%.2f", rmaianAmt))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension FeeVC{
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
        <display_student_payment_history xmlns="http://tempuri.org/">
              <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
            </display_student_payment_history>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
