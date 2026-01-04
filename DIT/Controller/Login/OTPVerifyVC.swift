//
//  OTPVerifyVC.swift
//  BrittsImperial
//
//  Created by Khuss on 25/09/23.
//

import UIKit

class OTPVerifyVC: UIViewController {

    
    @IBOutlet weak var otpVw: DPOTPView!
    
    var responseData : StudentLoginData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = otpVw.becomeFirstResponder()
        otpVw.dpOTPViewDelegate = self
        
        
        
        if let data = responseData{
            print(data)
            otpVw.text = data.otp ?? ""
        }
    }
    
    @IBAction func btn_OTP_VERIFY(_ sender: UIButton) {
        if otpVw.validate(){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            self.navigationController?.pushViewController(loginVC, animated: true)
        }else{
            //Please enter valid otp toast
            Toast(text: "Please enter valid otp.").show()
        }
    }
}

extension OTPVerifyVC : DPOTPViewDelegate {
   func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}
