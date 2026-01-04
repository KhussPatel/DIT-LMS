//
//  FeeHistoryVC.swift
//  BrittsImperial
//
//  Created by Khuss on 21/11/23.
//

import UIKit

class FeeHistoryVC: UIViewController {

    @IBOutlet weak var tblFeeHistory: UITableView!
    
    var resultData2 = [ResultData2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension FeeHistoryVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeeHistoryCell
        
        cell.lblTitle.text = resultData2[indexPath.row].feeHead ?? ""
        cell.lbldata.text = resultData2[indexPath.row].collectionDate ?? ""
        cell.lblReceiveAmt.text = "\(resultData2[indexPath.row].recCurrencyIcon ?? "") \(resultData2[indexPath.row].recAmount ?? 0)"
        
        let rmaianAmt = Double(resultData2[indexPath.row].usdAmount ?? 0.0)
        cell.lblUSD.text = "$\(String(format: "%.2f", rmaianAmt))"
        cell.lblNotes.text = "Notes: \(resultData2[indexPath.row].note ?? "")"
        cell.lblCollectBy.text = "Collected By: "
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
