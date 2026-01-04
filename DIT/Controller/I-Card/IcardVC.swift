//
//  IcardVC.swift
//  BrittsImperial
//
//  Created by Khuss on 21/10/23.
//

import UIKit

class IcardVC: UIViewController {

    @IBOutlet weak var vw_left: CustomCutoutView!
    @IBOutlet weak var vw_right: CustomCutoutView!
    
    
    @IBOutlet weak var vw_f: UIView!
    @IBOutlet weak var vw_b: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSTDID: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgQR: UIImageView!
    
    var isView1Visible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vw_left.cutoutPosition = .bottomRight
        vw_right.cutoutPosition = .topLeft
        // Do any additional setup after loading the view.
        //vw_main.primaryView.addSubview(vw_f)
        //vw_main.secondaryView.addSubview(vw_b)
        
        vw_f.isHidden = false
        vw_b.isHidden = true
        
        lblName.text = "\(UserDefaultsHelper.getStudentFMName() ?? "")"
        lblSTDID.text = "\(UserDefaultsHelper.getSTDID() ?? "")"
        lblCourse.text = UserDefaultsHelper.getCourseName()
        lblExp.text = UserDefaultsHelper.getExpiry()
        
        imgProfile.loadImageUsingCacheWithURLString(UserDefaultsHelper.getProfilePic() ?? "", placeHolder: UIImage(named: "avatar"))
        
        
        getIcardQRData()
        
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_FLIPCARD(_ sender: UIButton) {
        //vw_main.flip()
        
        //        let fromView = (isView1Visible ? vw_f : vw_b) ?? UIView()
        //        let toView = (isView1Visible ? vw_b : vw_f) ?? UIView()
        //
        //        UIView.transition(from: fromView, to: toView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { _ in
        //            // Animation completion block
        //            self.isView1Visible.toggle()
        //        }
        
        /////////////////////
        let fromView = isView1Visible ? vw_f : vw_b
        let toView = isView1Visible ? vw_b : vw_f
        
        if let fromView = fromView, let toView = toView {
            mainView.bringSubviewToFront(toView) // Ensure toView is in front for the flip animation
            
            UIView.transition(from: fromView, to: toView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { _ in
                // Animation completion block
                self.isView1Visible.toggle()
            }
        }
    }
}


extension IcardVC{
    
    
    func getIcardQRData(){
        APIManagerHandler.shared.callSOAPAPI_std_IcardQR(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(IcardQRModel.self, from: jsonData)
                    
                    if let arrQR = responseModel.result, arrQR.count > 0{
                        let qrURL = arrQR[0].qr ?? ""
                        self.imgQR.loadImageUsingCacheWithURLString(qrURL, placeHolder: UIImage(named: "QR-temp"))
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
             <get_student_idcard_qr xmlns="http://tempuri.org/">
                  <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
                </get_student_idcard_qr>
              </soap:Body>
            </soap:Envelope>
            """
        
        return stringParams
    }
    
}


struct IcardQRModel: Codable {
    let result: [IcardQRResultData]?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case result
        case success = "Success"
    }
}

// MARK: - Result
struct IcardQRResultData: Codable {
    let qr: String?
}
