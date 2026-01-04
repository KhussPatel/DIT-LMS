//
//  FeeInstallmentVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/11/23.
//

import UIKit

class FeeInstallmentVC: UIViewController {

    @IBOutlet weak var tblFeeInstallment: UITableView!
    
    var resultData = [ResultData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension FeeInstallmentVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeeCell
        cell.lblTitle.text = "\(indexPath.row + 1). \(resultData[indexPath.row].feeHead ?? "")"
        
        
        cell.lblTotal.text = "$ \(resultData[indexPath.row].fee ?? 00)"
        
        cell.lblRemain.text = "$ \(resultData[indexPath.row].remainFee ?? 00)"
        
        let rmaianAmt = Double(resultData[indexPath.row].fee ?? 00) - (resultData[indexPath.row].remainFee ?? 0.0)
        
        cell.lblPaid.text = "$ \(String(format: "%.2f", rmaianAmt))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
